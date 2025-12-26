-- Users Table: Authentication info
CREATE TABLE IF NOT EXISTS users (
    mid INTEGER PRIMARY KEY AUTOINCREMENT,
    sid TEXT NOT NULL,
    auth_key TEXT NOT NULL,
    method INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Player Data Table: Character profile
CREATE TABLE IF NOT EXISTS player_data (
    mid INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    sex INTEGER DEFAULT 0,
    level INTEGER DEFAULT 1,
    exp INTEGER DEFAULT 0,
    energy INTEGER DEFAULT 100,
    rank INTEGER DEFAULT 0,
    win INTEGER DEFAULT 0,
    fail INTEGER DEFAULT 0,
    vip_level INTEGER DEFAULT 0,
    appearance TEXT DEFAULT '1|1|1|1',
    FOREIGN KEY(mid) REFERENCES users(mid)
);

-- User Currency Table: Economy
CREATE TABLE IF NOT EXISTS user_currency (
    mid INTEGER PRIMARY KEY,
    game_gold INTEGER DEFAULT 1000,
    boyaa_coin INTEGER DEFAULT 100,
    free_coin INTEGER DEFAULT 0,
    aucte_coin INTEGER DEFAULT 0,
    FOREIGN KEY(mid) REFERENCES users(mid)
);

-- Items Table: Inventory
CREATE TABLE IF NOT EXISTS items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    mid INTEGER NOT NULL,
    type_id INTEGER NOT NULL,
    frame_id INTEGER NOT NULL,
    amount INTEGER DEFAULT 1,
    place INTEGER DEFAULT 0, -- 0: Bag, 1: Equipped, 3: Storage
    status INTEGER DEFAULT 1, -- 1: Valid, 0: Expired
    attributes TEXT DEFAULT '', -- e.g., "100|50|20..."
    strengthen_level INTEGER DEFAULT 0,
    FOREIGN KEY(mid) REFERENCES users(mid)
);

-- Friends Table
CREATE TABLE IF NOT EXISTS friends (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    mid INTEGER NOT NULL,
    friend_mid INTEGER NOT NULL,
    status INTEGER DEFAULT 1,
    FOREIGN KEY(mid) REFERENCES users(mid),
    FOREIGN KEY(friend_mid) REFERENCES users(mid)
);

-- Guilds (Unions) Table
CREATE TABLE IF NOT EXISTS guilds (
    cid INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    leader_mid INTEGER NOT NULL,
    level INTEGER DEFAULT 1,
    notice TEXT DEFAULT ''
);

-- Guild Members Table
CREATE TABLE IF NOT EXISTS guild_members (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    cid INTEGER NOT NULL,
    mid INTEGER NOT NULL,
    position INTEGER DEFAULT 0, -- 0: Member, 1: Leader
    contribution INTEGER DEFAULT 0,
    FOREIGN KEY(cid) REFERENCES guilds(cid),
    FOREIGN KEY(mid) REFERENCES users(mid)
);

-- Initial seed data for testing
INSERT INTO users (mid, sid, auth_key, method) VALUES (1, 'demo_session_id', 'demo_key', 1);
INSERT INTO player_data (mid, name, sex, level, exp) VALUES (1, 'AntHero', 1, 5, 500);
INSERT INTO user_currency (mid) VALUES (1);
