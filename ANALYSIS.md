# Database Layout and Business Process Analysis

This document outlines the analysis of the *Perjuangan Semut* (Ant Wars) client codebase to reverse engineer the server requirements.

## 1. Business Processes

The application is a Flash/Starling mobile game that communicates with a PHP-based backend.

### Network Protocol
*   **Transport:** HTTP POST
*   **Endpoint:** A single gateway URL (defined in `Constants.WebGateway`).
*   **Data Format:**
    *   **Request:** Form URL Encoded variables.
        *   `sid`: Session ID (for authentication).
        *   `win_param`: A JSON string containing:
            *   `mid`: Member ID (User ID).
            *   `key`: Authentication Key.
            *   `method`: The API method to call (e.g., "GameMember.load").
            *   `param`: Arguments for the method (Array or Object).
    *   **Response:** The server returns a string, which the client typically parses as JSON.

### Key Workflows
1.  **Login/Initialization:**
    *   `GameMember.load`: Fetches initial user data.
    *   `GameMember.getAccount`: Fetches currency balances (Gold, Coins, etc.).
    *   `GameSignin.get_v2sign_info`: Fetches daily login reward status.
    *   `GameMember.getNotice`: Fetches server announcements.

2.  **Character Management:**
    *   `GameMember.create`: Creates a new character with `name`, `sex`, etc.
    *   `GameMember.checkRepeatRole`: Checks if a character name is taken.

3.  **Inventory & Economy:**
    *   `GameProps.get_fight_weapons`: Retrieves weapons available for battle.
    *   `GameCopys.buyProp` / `useProp`: Buying and using items.
    *   Currency types identified: `gameGold` (Currency), `boyaaCoin` (Premium), `freeCoin` (Exchange Certs), `aucteCoin`.

4.  **Social:**
    *   `GameFriends.getFrds`: Retrieves friend list.
    *   `GameFriends.addFriend` / `deleteFriend`: Manage relationships.
    *   `GameMember.bindLogin`: Binds guest account to social platforms (Facebook, etc.).

5.  **Gameplay/Missions:**
    *   Missions are loaded from XML but progress is synced.
    *   Battle logic seems partially client-side (Flash), with results or state changes sent to the server (e.g., `GameCopys.getMobileCopyPrize`).

## 2. Database Layout

Based on the ActionScript data models, here is the proposed database schema.

### Tables

1.  **`users`**: Core account info.
    *   `mid` (INT, PK): User ID.
    *   `sid` (VARCHAR): Session ID.
    *   `key` (VARCHAR): Auth key.
    *   `method` (INT): Login method (e.g., Guest, FB).
    *   `created_at` (TIMESTAMP).

2.  **`player_data`**: The character profile (one-to-one with `users`).
    *   `mid` (INT, FK): User ID.
    *   `name` (VARCHAR): Character name.
    *   `sex` (INT): Gender (0/1).
    *   `level` (INT): Current level.
    *   `exp` (INT): Experience points.
    *   `energy` (INT): Energy/Stamina.
    *   `rank` (INT): Ranking.
    *   `win` (INT), `fail` (INT): PvP stats.
    *   `vip_level` (INT).
    *   `appearance` (VARCHAR): String like "1|1|1|1" defining avatar parts.

3.  **`user_currency`**: Economy stats (one-to-one with `users`).
    *   `mid` (INT, FK).
    *   `game_gold` (INT): Standard currency.
    *   `boyaa_coin` (INT): Premium currency.
    *   `free_coin` (INT).

4.  **`items`**: Inventory (one-to-many with `users`).
    *   `id` (INT, PK): Unique instance ID (`onlyID`).
    *   `mid` (INT, FK): Owner.
    *   `type_id` (INT): Item template ID.
    *   `frame_id` (INT): Sub-ID/Variant.
    *   `amount` (INT): Quantity.
    *   `place` (INT): Location (0=Bag, 1=Equipped, 3=Storage).
    *   `status` (INT): 0=Expired, 1=Valid.
    *   `attributes` (TEXT): Pipe-separated stats (e.g., attack|defense|...).
    *   `strengthen_level` (INT): Upgrade level.

5.  **`friends`**: Social graph.
    *   `mid` (INT, FK): User.
    *   `friend_mid` (INT, FK): Friend.
    *   `status` (INT): 0=Pending, 1=Accepted.

6.  **`guilds`** (Unions):
    *   `cid` (INT, PK): Guild ID.
    *   `name` (VARCHAR).
    *   `leader_mid` (INT).
    *   `level` (INT).

7.  **`guild_members`**:
    *   `cid` (INT, FK).
    *   `mid` (INT, FK).
    *   `position` (INT): Role (Member, Vice, Leader).
    *   `contribution` (INT).

## 3. Server Implementation Plan (Rust)

A Rust server will be implemented to mimic the PHP gateway.

*   **Framework:** `actix-web` for the HTTP server.
*   **Database:** `sqlx` with `sqlite` for a self-contained, easy-to-run emulator.
*   **JSON Handling:** `serde_json`.
*   **Routing:** A single POST `/` or `/gateway` endpoint that deserializes the `win_param` and dispatches to handler functions.

### Directory Structure
```
antwars-server/
├── Cargo.toml
├── src/
│   ├── main.rs         # Server entry point
│   ├── db.rs           # Database connection and setup
│   ├── models.rs       # Structs matching DB tables
│   ├── gateway.rs      # Parses `win_param` and routes requests
│   └── handlers/
│       ├── mod.rs
│       ├── member.rs   # GameMember.* methods
│       └── copy.rs     # GameCopys.* methods
└── schema.sql          # SQL schema definition
```
