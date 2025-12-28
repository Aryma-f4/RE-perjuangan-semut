# Panduan Lengkap Pengembangan (The Savior Guide v2)

Ini adalah panduan **"Zero to Hero"** untuk membangun kembali game Ant Wars menggunakan **Next.js** (Web Client) dan **Rust** (Server Backend).

---

## BAGIAN 1: Struktur Aset (PENTING)

Agar game bisa berjalan, aset (gambar, xml) harus disusun dengan benar agar bisa dibaca oleh `ResManager` yang baru kita patch.

1.  Masuk ke folder `antwars-web/public/`.
2.  Buat struktur folder berikut:
    ```
    antwars-web/public/
    ├── antwars.swf  (Hasil compile)
    ├── ruffle.js
    └── version/
        └── facebookid/
            ├── ChangerLog.xml
            ├── lan.xml
            ├── MAP_SMALL/
            │   └── ...
            └── res/
                └── textures/
                    └── ...
    ```
    *Tips: Copy isi folder `app/src/main/assets/` dari proyek Android lama ke `antwars-web/public/version/facebookid/`.*

---

## BAGIAN 2: Download Ruffle (Flash Emulator)

1.  Download file bernama **self-hosted** dari [Ruffle Releases](https://github.com/ruffle-rs/ruffle/releases).
2.  Ekstrak dan copy `ruffle.js` serta `core.ruffle.wasm` ke `antwars-web/public/`.

---

## BAGIAN 3: Compile SWF (Wajib)

Lihat file `BUILD_INSTRUCTIONS.md` (Windows) atau `MACOS_SETUP.md` (Mac) untuk cara mengkompilasi kode yang sudah saya patch. **Jangan pakai SWF lama**, itu akan crash.

---

## BAGIAN 4: Menjalankan Server & Klien

1.  **Server Rust**:
    *   `cd server_emulator`
    *   `cargo run` (Gunakan Admin/Sudo jika error permission port 80).
2.  **Klien Web**:
    *   `cd antwars-web`
    *   `npm install`
    *   `npm run dev`
3.  **Hosts File**:
    *   Jangan lupa edit `hosts` file agar domain asli mengarah ke `127.0.0.1` (Lihat `MACOS_SETUP.md` atau panduan sebelumnya).

Selamat bermain!
