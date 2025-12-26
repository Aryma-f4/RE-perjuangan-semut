use actix_web::{web, HttpResponse, Responder};
use crate::models::{WinParam, PlayerData, UserCurrency};
use serde::Deserialize;
use serde_json::json;
use sqlx::SqlitePool;

// The raw form data structure
#[derive(Deserialize)]
pub struct GatewayForm {
    pub sid: Option<String>,
    pub win_param: String, // This is a JSON string we need to parse manually
}

pub async fn gateway_handler(
    form: web::Form<GatewayForm>,
    pool: web::Data<SqlitePool>,
) -> impl Responder {
    // 1. Parse win_param JSON
    let params: WinParam = match serde_json::from_str(&form.win_param) {
        Ok(p) => p,
        Err(e) => return HttpResponse::BadRequest().body(format!("Invalid JSON in win_param: {}", e)),
    };

    println!("Method called: {}", params.method);

    // 2. Dispatch based on method name
    match params.method.as_str() {
        "GameMember.load" => handle_member_load(&params, &pool).await,
        "GameMember.getAccount" => handle_get_account(&params, &pool).await,
        "GameMember.create" => handle_create_member(&params, &pool).await,
        _ => {
            println!("Unknown method: {}", params.method);
            HttpResponse::Ok().json(json!({ "status": -1, "msg": "Method not implemented" }))
        }
    }
}

async fn handle_member_load(params: &WinParam, pool: &SqlitePool) -> HttpResponse {
    let mid = params.mid.unwrap_or(0);

    // Fetch player data
    let player: Option<PlayerData> = sqlx::query_as!(
        PlayerData,
        "SELECT * FROM player_data WHERE mid = ?",
        mid
    )
    .fetch_optional(pool)
    .await
    .unwrap_or(None);

    if let Some(p) = player {
        // The client expects a specific JSON structure.
        // Based on PlayerData.as `addOtherInfo`:
        // { "mgender": sex, "mrolename": babyName, "mlevel": level, "mid": mid, ... }
        let response = json!({
            "mid": p.mid,
            "mrolename": p.name,
            "mgender": p.sex,
            "mlevel": p.level,
            "mpoint": p.exp,
            "appearance": p.appearance,
            // ... other fields as required by client
        });
        HttpResponse::Ok().body(response.to_string())
    } else {
         // Maybe return a code indicating creation is needed
         HttpResponse::Ok().json(json!({"status": 0, "msg": "User not found"}))
    }
}

async fn handle_get_account(params: &WinParam, pool: &SqlitePool) -> HttpResponse {
    let mid = params.mid.unwrap_or(0);

    let currency: Option<UserCurrency> = sqlx::query_as!(
        UserCurrency,
        "SELECT * FROM user_currency WHERE mid = ?",
        mid
    )
    .fetch_optional(pool)
    .await
    .unwrap_or(None);

    if let Some(c) = currency {
        // Based on AccountData.as `updateAccount`:
        // { "currency": gameGold, "boyaacurrency": boyaaCoin, ... }
        let response = json!({
            "currency": c.game_gold,
            "boyaacurrency": c.boyaa_coin,
            "excertificate": c.free_coin,
            "auctecoin": c.aucte_coin
        });
        HttpResponse::Ok().body(response.to_string())
    } else {
        HttpResponse::Ok().json(json!({"status": 0, "msg": "Account not found"}))
    }
}

async fn handle_create_member(params: &WinParam, pool: &SqlitePool) -> HttpResponse {
     // Params usually: [name, sex, ...] inside the `param` field which is an array
     if let Some(args) = params.param.as_array() {
        if args.len() >= 2 {
            let name = args[0].as_str().unwrap_or("Unknown");
            let sex = args[1].as_u64().unwrap_or(0) as i32;
            let mid = params.mid.unwrap_or(0);

            // Insert into DB
            let _ = sqlx::query!(
                "INSERT INTO player_data (mid, name, sex) VALUES (?, ?, ?)",
                mid, name, sex
            )
            .execute(pool)
            .await;

             // Initialize currency
            let _ = sqlx::query!(
                "INSERT OR IGNORE INTO user_currency (mid) VALUES (?)",
                mid
            )
            .execute(pool)
            .await;

            return HttpResponse::Ok().json(json!({"status": 1, "mid": mid}));
        }
     }
     HttpResponse::BadRequest().body("Invalid parameters")
}
