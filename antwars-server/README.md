# AntWars Emulator Server

This is a basic emulator server for *Perjuangan Semut* (Ant Wars), written in Rust.

## Prerequisites

1.  **Rust**: Install from [rustup.rs](https://rustup.rs/).
2.  **SQLx CLI**: Required for database management.
    ```bash
    cargo install sqlx-cli --no-default-features --features native-tls,sqlite
    ```

## Setup

1.  Navigate to the server directory:
    ```bash
    cd antwars-server
    ```

2.  Create the database and apply migrations (schema):
    ```bash
    export DATABASE_URL=sqlite:antwars.db
    sqlx database create
    # Identify the migration folder or just use the schema.sql via the app's runtime init
    # For compile-time checks, we need the DB to exist
    sqlite3 antwars.db < ../schema.sql
    ```

    *Note: The server code attempts to apply `../schema.sql` at startup if the DB is missing, but `cargo build` requires the DB to exist to verify SQL queries.*

## Running

1.  Start the server:
    ```bash
    export DATABASE_URL=sqlite:antwars.db
    cargo run
    ```

2.  The server will listen on `http://127.0.0.1:8080`.

## Endpoints

*   **POST /gateway** (or `/`): Accepts the game client's encoded parameters.
    *   Parameter: `win_param` (JSON string)

## Implemented Methods

*   `GameMember.load`: Fetches character profile.
*   `GameMember.getAccount`: Fetches currency info.
*   `GameMember.create`: Creates a new character.

## Project Structure

*   `src/main.rs`: Entry point.
*   `src/handlers.rs`: Logic for handling specific game commands.
*   `src/models.rs`: Database structs.
*   `src/db.rs`: Database initialization.
