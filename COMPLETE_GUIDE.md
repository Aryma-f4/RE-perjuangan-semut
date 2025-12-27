# Panduan Lengkap Pengembangan (The Savior Guide v2)

Ini adalah panduan **"Zero to Hero"** untuk membangun kembali game Ant Wars menggunakan **Next.js** (Web Client) dan **Rust** (Server Backend). Kita beralih ke Next.js karena lebih stabil untuk emulasi Flash (Ruffle) dibanding Tauri.

---

## BAGIAN 1: Persiapan Lingkungan (Setup)

Anda perlu menginstal tools berikut:

1.  **Rust**: [rustup.rs](https://rustup.rs).
2.  **Node.js**: [nodejs.org](https://nodejs.org) (v18 ke atas).

---

## BAGIAN 2: Download Ruffle (Flash Emulator)

1.  Buka website [Ruffle Releases](https://github.com/ruffle-rs/ruffle/releases).
2.  Cari rilis terbaru (misal `nightly`).
3.  Download file bernama **self-hosted** (contoh: `ruffle_nightly_2023_xx_xx_selfhosted.zip`).
4.  Ekstrak file zip tersebut.
5.  Ambil file `ruffle.js` dan file `core.ruffle.wasm` (atau folder core-nya).
6.  Copy file-file tersebut ke folder: `antwars-web/public/`.
    *   Pastikan `antwars-web/public/ruffle.js` ada.

---

## BAGIAN 3: Menjalankan Server (Backend)

**PENTING: Port 80**
Game asli (via Flash) mencoba menghubungi server di port 80. Server kita harus berjalan di port 80. Ini butuh akses Administrator.

1.  Buka terminal sebagai **Administrator** (Windows) atau `sudo` (Mac/Linux).
2.  Masuk ke folder server:
    ```bash
    cd server_emulator
    ```
3.  Jalankan server:
    ```bash
    cargo run
    ```
4.  Tunggu hingga muncul: `Server running at http://127.0.0.1:80`.

---

## BAGIAN 4: Menjalankan Klien (Web Game)

1.  Pastikan file game asli sudah ada di folder public (saya sudah mengcopynya ke `antwars-web/public/antwars.swf`).
2.  Buka terminal **baru**.
3.  Masuk ke folder web:
    ```bash
    cd antwars-web
    ```
4.  Instal dependensi (pertama kali saja):
    ```bash
    npm install
    ```
5.  Jalankan web server:
    ```bash
    npm run dev
    ```
6.  Buka browser dan akses: `http://localhost:3000`.
7.  Game akan dimuat oleh Ruffle.

---

## BAGIAN 5: Koneksi ke Server (Hosts File)

Agar Flash Client yang berjalan di browser mau menghubungi Server Rust kita, kita harus menipu domain aslinya.

1.  Edit file `hosts` di komputer Anda (`C:\Windows\System32\drivers\etc\hosts` atau `/etc/hosts`) sebagai Administrator.
2.  Tambahkan:
    ```
    127.0.0.1 mvlpidat01.boyaagame.com
    127.0.0.1 pclpidat01.boyaagame.com
    ```
3.  Simpan file. Sekarang request dari Game (Flash) akan belok ke `127.0.0.1:80` (Server Rust Anda).

---

## BAGIAN 6: Debugging

1.  **Server Logs**: Lihat terminal Rust untuk melihat request yang masuk (`Request: WinParam...`).
2.  **Browser Console**: Tekan F12 di browser saat membuka game.
    *   Tab **Console**: Lihat log dari Ruffle.
    *   Tab **Network**: Lihat request `flashapi.php` yang merah/hijau.

Selamat coding!
