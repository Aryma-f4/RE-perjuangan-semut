# Panduan Lengkap Pengembangan (The Savior Guide)

Ini adalah panduan **"Zero to Hero"** untuk membangun kembali game Ant Wars menggunakan teknologi modern (Rust & Tauri) dengan Emulasi Flash.

Strategi kita adalah:
1.  **Server**: Backend Rust yang meniru logika server asli.
2.  **Klien**: Aplikasi Desktop (Tauri) yang menjalankan **Ruffle** (Flash Emulator) untuk memutar file `.swf` asli tanpa butuh Android Emulator.

---

## BAGIAN 1: Persiapan Lingkungan (Setup)

Anda perlu menginstal tools berikut di komputer Anda:

1.  **Rust**: [rustup.rs](https://rustup.rs).
2.  **Node.js**: [nodejs.org](https://nodejs.org).
3.  **Tauri CLI**: Buka terminal dan jalankan `cargo install tauri-cli`.

---

## BAGIAN 2: Download Ruffle (Flash Emulator)

Karena kita menjalankan file SWF, kita butuh engine emulator.

1.  Buka website [Ruffle Releases](https://github.com/ruffle-rs/ruffle/releases).
2.  Cari rilis terbaru (misal `nightly`).
3.  Download file yang bernama **self-hosted** (contoh: `ruffle_nightly_2023_xx_xx_selfhosted.zip`).
4.  Ekstrak file zip tersebut.
5.  Ambil file `ruffle.js` dan file `core.ruffle.wasm` (atau folder core-nya).
6.  Copy file-file tersebut ke folder: `antwars-client/ui/`.
    *   Pastikan `antwars-client/ui/ruffle.js` ada.

---

## BAGIAN 3: Menjalankan Server (Backend)

**PENTING: Port 80**
Game asli mencoba menghubungi server di port HTTP standar (80). Server kita perlu berjalan di port 80 agar metode DNS Spoofing berhasil. Ini membutuhkan akses Administrator/Root.

1.  Buka file `server_emulator/src/main.rs`.
2.  Ubah baris `.bind(("127.0.0.1", 8080))?` menjadi `.bind(("127.0.0.1", 80))?`.
3.  Buka terminal sebagai **Administrator** (Windows) atau gunakan `sudo` (Linux/Mac).
4.  Masuk ke folder server dan jalankan:
    ```bash
    cargo run
    ```
5.  Tunggu hingga muncul: `Server running at http://127.0.0.1:80`.

---

## BAGIAN 4: Menjalankan Klien (Game)

1.  Pastikan file game asli sudah ada di folder klien. Copy file `app/src/main/assets/antwarsmobilestarling.swf` ke `antwars-client/ui/antwars.swf`.
2.  Buka terminal **baru**.
3.  Masuk ke folder klien:
    ```bash
    cd antwars-client
    ```
4.  Jalankan aplikasi:
    ```bash
    cargo tauri dev
    ```
5.  Aplikasi akan terbuka dan Ruffle akan memuat game.

---

## BAGIAN 5: Mengatasi Koneksi Server (PENTING)

Agar SWF mau berbicara dengan server lokal (`127.0.0.1`), Anda punya 2 pilihan:

**Pilihan A: DNS Spoofing (Mudah)**
1.  Edit file `hosts` di komputer Anda (`C:\Windows\System32\drivers\etc\hosts` atau `/etc/hosts`) sebagai Administrator.
2.  Tambahkan:
    ```
    127.0.0.1 mvlpidat01.boyaagame.com
    127.0.0.1 pclpidat01.boyaagame.com
    ```
3.  Simpan file. Sekarang game akan mengira komputer Anda adalah server resmi.

**Pilihan B: Modifikasi SWF (Susah)**
1.  Anda perlu recompile SWF menggunakan Flex SDK seperti dijelaskan di panduan sebelumnya, mengubah IP di `Constants.as`.
2.  Lalu ganti file `antwars-client/ui/antwars.swf` dengan hasil compile baru Anda.

---

## BAGIAN 6: Debugging

1.  **Lihat Log Server**: Perhatikan terminal `server_emulator`. Jika ada tulisan "Request: ...", berarti game berhasil menghubungi server Anda!
2.  **Inspect Element**: Di jendela game, Klik Kanan -> Inspect. Lihat tab **Network** untuk melihat apakah file `.swf` atau request API gagal (merah).

Selamat mencoba membangkitkan kembali Ant Wars!
