use actix_web::{web, App, HttpServer, HttpResponse, Responder};
use serde::{Deserialize, Serialize};
use sqlx::SqlitePool;
use std::env;

#[derive(Deserialize)]
struct GatewayRequest {
    win_param: String,
}

#[derive(Deserialize, Debug)]
struct WinParam {
    method: String,
    // param can be array or object, treating as Value for now
    param: serde_json::Value,
    mid: Option<i64>,
}

async fn gateway(form: web::Form<GatewayRequest>, pool: web::Data<SqlitePool>) -> impl Responder {
    let params: WinParam = match serde_json::from_str(&form.win_param) {
        Ok(p) => p,
        Err(_) => return HttpResponse::BadRequest().body("Invalid JSON"),
    };

    println!("Request: {:?}", params);

    match params.method.as_str() {
        "GameMember.load" => HttpResponse::Ok().json(serde_json::json!({
            "status": 1,
            "mid": params.mid.unwrap_or(1001),
            "mrolename": "DevUser",
            "mlevel": 99,
            "sex": 0
        })),
        _ => HttpResponse::Ok().json(serde_json::json!({"status": 0, "msg": "Method stubbed"}))
    }
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    env_logger::init();

    // Database setup (Mock for now if file missing)
    let db_url = "sqlite::memory:";
    let pool = SqlitePool::connect(db_url).await.unwrap();

    println!("Server running at http://127.0.0.1:8080");

    HttpServer::new(move || {
        App::new()
            .app_data(web::Data::new(pool.clone()))
            .route("/antwarsmobile/api/flashapi.php", web::post().to(gateway))
            .route("/api/flashapi.php", web::post().to(gateway))
    })
    .bind(("127.0.0.1", 8080))?
    .run()
    .await
}
