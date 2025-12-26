# Panduan Lengkap Pengembangan (The Savior Guide)

Ini adalah panduan **"Zero to Hero"** untuk membangun kembali game Ant Wars menggunakan teknologi modern (Rust & Tauri), karena Android Emulator KitKat sudah tidak bisa diandalkan.

Kita akan menggunakan strategi **"Rewrite Client"**:
1.  **Server**: Backend Rust yang meniru logika server asli.
2.  **Klien**: Aplikasi Desktop (Tauri) yang meniru tampilan dan logika APK asli.

---

## BAGIAN 1: Persiapan Lingkungan (Setup)

Anda perlu menginstal tools berikut di komputer Anda (Windows/Mac/Linux):

1.  **Rust**: Bahasa pemrograman utama.
    *   Download di [rustup.rs](https://rustup.rs).
2.  **Node.js**: Diperlukan untuk build sistem Tauri.
    *   Download di [nodejs.org](https://nodejs.org).
3.  **Tauri CLI**:
    *   Buka terminal dan jalankan: `cargo install tauri-cli`.

---

## BAGIAN 2: Menjalankan Server (Backend)

Server ini bertugas menyimpan data akun dan logika game.

1.  Buka terminal di folder root proyek ini.
2.  Masuk ke folder server:
    ```bash
    cd server_emulator
    ```
3.  Jalankan server:
    ```bash
    cargo run
    ```
4.  Tunggu hingga muncul: `Server running at http://127.0.0.1:8080`.
    *   **Biarkan terminal ini terbuka.**

---

## BAGIAN 3: Menjalankan Klien (Frontend)

Ini adalah pengganti APK lama. Aplikasi ini berjalan native di PC Anda.

1.  Buka terminal **baru** (terminal server jangan ditutup).
2.  Masuk ke folder klien:
    ```bash
    cd antwars-client
    ```
3.  Jalankan mode development:
    ```bash
    cargo tauri dev
    ```
4.  Akan muncul jendela aplikasi dengan tombol **"Login (GameMember.load)"**.
5.  Klik tombol tersebut.
    *   Jika sukses, akan muncul Popup: "Login Success! Welcome DevUser".
    *   Di terminal Server, Anda akan melihat log request yang masuk.

---

## BAGIAN 4: Cara Debugging (PENTING)

Karena Anda membangun ulang, debugging adalah kunci.

1.  **Debug Klien (Frontend)**:
    *   Di jendela aplikasi Tauri, klik kanan -> **Inspect Element**.
    *   Ini membuka "Developer Tools" (sama seperti Chrome).
    *   Tab **Console**: Melihat log error atau `console.log`.
    *   Tab **Network**: Melihat request yang dikirim ke server.

2.  **Debug Server (Backend)**:
    *   Lihat terminal tempat Anda menjalankan `cargo run`.
    *   Gunakan `println!("Variable: {:?}", variable);` di kode Rust untuk melihat isi data saat development.

---

## BAGIAN 5: Menggunakan Aset Game Asli

Agar klien Tauri terlihat seperti game asli, kita perlu mengambil gambar (tekstur) dari APK.

1.  Aset asli ada di folder repo: `app/src/main/assets/res/`.
2.  Copy folder `res` tersebut ke dalam folder UI klien: `antwars-client/ui/assets/`.
3.  Di kode HTML/JS (`antwars-client/ui/index.html`), Anda bisa memuat gambar tersebut.
    *   Contoh: `<img src="assets/res/textures/0.5x/UI/login_bg.png">`

---

## BAGIAN 6: Roadmap Pengembangan Selanjutnya

Anda sekarang punya fondasi yang **berjalan 100%**. Langkah selanjutnya adalah memindahkan logika game satu per satu.

1.  **Lobby**: Buat tampilan HTML/Canvas yang menampilkan karakter.
2.  **Inventory**:
    *   Klien: Kirim request `GameMember.getNewWeapon`.
    *   Server: Tambahkan handler di `server_emulator/src/main.rs`.
3.  **Battle**:
    *   Gunakan library game engine JS (seperti **Phaser.js** atau **Bevy** di Rust) untuk membuat logika tembak-tembakan semut di dalam Tauri.

**Selamat! Anda tidak lagi butuh Android Emulator jadul.**
