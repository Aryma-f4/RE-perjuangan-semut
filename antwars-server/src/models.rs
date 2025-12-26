use sqlx::{FromRow, SqlitePool};
use serde::{Deserialize, Serialize};

#[derive(Debug, FromRow, Serialize, Deserialize)]
pub struct User {
    pub mid: i64,
    pub sid: String,
    pub auth_key: String,
}

#[derive(Debug, FromRow, Serialize, Deserialize)]
pub struct PlayerData {
    pub mid: Option<i64>,
    pub name: String,
    pub sex: Option<i64>,
    pub level: Option<i64>,
    pub exp: Option<i64>,
    pub energy: Option<i64>,
    pub rank: Option<i64>,
    pub win: Option<i64>,
    pub fail: Option<i64>,
    pub vip_level: Option<i64>,
    pub appearance: Option<String>,
}

#[derive(Debug, FromRow, Serialize, Deserialize)]
pub struct UserCurrency {
    pub mid: Option<i64>,
    pub game_gold: Option<i64>,
    pub boyaa_coin: Option<i64>,
    pub free_coin: Option<i64>,
    pub aucte_coin: Option<i64>,
}

// Request payload structure from "win_param"
#[derive(Debug, Deserialize)]
pub struct WinParam {
    pub mid: Option<i64>,
    pub key: Option<String>,
    pub method: String,
    pub param: serde_json::Value,
}
