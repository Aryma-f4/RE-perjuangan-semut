mod db;
mod handlers;
mod models;

use actix_web::{middleware, web, App, HttpServer};
use dotenv::dotenv;
use std::env;

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    dotenv().ok();
    env_logger::init();

    // Set default env if not present
    if env::var("DATABASE_URL").is_err() {
        env::set_var("DATABASE_URL", "sqlite:antwars.db");
    }

    let pool = db::init_db().await;

    println!("Starting server at http://127.0.0.1:8080");

    HttpServer::new(move || {
        App::new()
            .app_data(web::Data::new(pool.clone()))
            .wrap(middleware::Logger::default())
            .service(
                web::resource("/gateway") // The single entry point
                    .route(web::post().to(handlers::gateway_handler)),
            )
            // Some clients might try root
            .service(
                web::resource("/")
                    .route(web::post().to(handlers::gateway_handler)),
            )
    })
    .bind(("127.0.0.1", 8080))?
    .run()
    .await
}
