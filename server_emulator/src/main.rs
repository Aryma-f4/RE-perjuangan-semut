use actix_web::{web, App, HttpServer, HttpResponse, Responder, http};
use actix_cors::Cors;
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
    param: serde_json::Value,
    mid: Option<i64>,
}

async fn gateway(form: web::Form<GatewayRequest>, pool: web::Data<SqlitePool>) -> impl Responder {
    let params: WinParam = match serde_json::from_str(&form.win_param) {
        Ok(p) => p,
        Err(_) => return HttpResponse::BadRequest().body("Invalid JSON in win_param"),
    };

    println!("Request: {:?}", params);

    match params.method.as_str() {
        "GameMember.load" => HttpResponse::Ok().json(serde_json::json!({
            "status": 1,
            "mid": params.mid.unwrap_or(1001),
            "mrolename": "DevUser",
            "mlevel": 10,
            "sex": 0,
            "mpoint": 5000,
            "appearance": "1|1|1|1"
        })),
        _ => HttpResponse::Ok().json(serde_json::json!({"status": 0, "msg": "Method stubbed"}))
    }
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    env_logger::init();

    // Database setup (Mock for now)
    let db_url = "sqlite::memory:";
    let pool = SqlitePool::connect(db_url).await.unwrap();

    println!("Server running at http://127.0.0.1:8080");

    HttpServer::new(move || {
        // Setup CORS to allow Tauri client (or browser) to connect
        let cors = Cors::default()
            .allow_any_origin()
            .allow_any_method()
            .allow_any_header()
            .max_age(3600);

        App::new()
            .wrap(cors)
            .app_data(web::Data::new(pool.clone()))
            // Support both old path and new clean path
            .route("/antwarsmobile/api/flashapi.php", web::post().to(gateway))
            .route("/api/flashapi.php", web::post().to(gateway))
    })
    .bind(("127.0.0.1", 8080))?
    .run()
    .await
}
