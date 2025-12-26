use sqlx::SqlitePool;
use std::env;
use std::path::Path;
use tokio::fs;

pub async fn init_db() -> SqlitePool {
    let database_url = env::var("DATABASE_URL").expect("DATABASE_URL must be set");

    // Create the DB file if it doesn't exist
    if !Path::new("antwars.db").exists() {
        println!("Database file not found, creating...");
        fs::File::create("antwars.db").await.expect("Failed to create db file");
    }

    let pool = SqlitePool::connect(&database_url).await.expect("Failed to connect to database");

    // Apply schema
    let schema = fs::read_to_string("../schema.sql").await.expect("Failed to read schema.sql");
    sqlx::query(&schema).execute(&pool).await.expect("Failed to apply schema");

    println!("Database initialized and schema applied.");

    pool
}
