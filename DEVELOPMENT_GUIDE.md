# Panduan Pengembangan Private Server Ant Wars

Dokumen ini berisi langkah-langkah teknis untuk membangun server emulator sendiri (Private Server) menggunakan kode sumber klien yang telah Anda miliki.

## 1. Alur Sistem (System Flow)

Permainan ini menggunakan arsitektur **Client-Server** klasik berbasis HTTP.

1.  **Start Up**: Klien memuat konfigurasi dari `Constants.as`.
2.  **Resource Loading**: Klien mengunduh aset (gambar, suara, XML) dari URL `ResUrl`.
3.  **Login/Handshake**: Klien mengirim permintaan POST ke `WebGateway` (`api/flashapi.php`).
4.  **Game Loop**: Setiap aksi pemain (beli item, masuk dungeon) dikirim sebagai "Command" ke Gateway, server memproses logika, dan mengembalikan hasil (JSON) untuk diperbarui di klien.

## 2. Persiapan Awal (Prerequisites)

Karena server asli sudah mati, Anda harus membuat klien "berbicara" dengan server buatan Anda sendiri.

### Opsi A: Modifikasi Klien (Recompile)
Jika Anda bisa mengkompilasi ulang kode ActionScript (menggunakan Adobe Flash Builder atau SDK Flex/AIR):
1.  Buka `src/Constants.as`.
2.  Ubah variabel `_IpAddress` menjadi alamat server lokal Anda (misal: `http://127.0.0.1:8080/antwarsmobile/`).
3.  Ubah `CONST_ARR` elemen ke-3 menjadi `true` (untuk mode local).
    ```actionscript
    // Ubah false menjadi true
    public static const CONST_ARR:Array = [3,false,true,1];
    ```

### Opsi B: DNS Spoofing (Tanpa Recompile)
Jika Anda hanya menggunakan APK/SWF yang sudah jadi:
1.  Ubah file `hosts` di komputer/HP Anda.
2.  Arahkan domain asli (`mvlpidat01.boyaagame.com` atau `pclpidat01.boyaagame.com`) ke `127.0.0.1`.
3.  Jalankan server Anda di port 80 (HTTP standar).

## 3. Tahap Pengembangan Server

Anda bisa menggunakan bahasa pemrograman apa saja (Rust, Node.js, PHP, Python). Berikut roadmap menggunakan **Rust** (seperti yang Anda rencanakan dengan Tauri nanti).

### Tahap 1: Static File Server
Klien akan mencoba mengunduh aset sebelum login.
*   **Tugas**: Buat server HTTP yang melayani folder statis.
*   **Struktur Folder**:
    ```
    /antwarsmobile/
      └── version/
          └── facebookid/  (sesuai Constants.lanVersion)
              ├── config.xml
              ├── MAP_SMALL/
              └── ... (aset lain dari hasil decompile)
    ```
*   **Test**: Buka browser ke `http://localhost:8080/antwarsmobile/version/facebookid/config.xml`. Jika file XML muncul, tahap ini sukses.

### Tahap 2: API Gateway (`flashapi.php`)
Klien mengirim semua logika game ke satu URL ini.
*   **Endpoint**: `POST /antwarsmobile/api/flashapi.php`
*   **Parameter POST**:
    *   `sid`: Session ID.
    *   `win_param`: JSON String. Contoh: `{"method": "GameMember.load", "mid": 123, ...}`.
*   **Tugas**: Buat rute di server Anda untuk menerima POST ini, parse JSON `win_param`, dan lihat `method` apa yang dipanggil.

### Tahap 3: Mocking Login (`GameMember.load`)
Saat game loading, metode pertama yang dipanggil biasanya `GameMember.load` atau `GameMember.getAccount`.
*   **Request**: `method: "GameMember.load"`
*   **Response**: Anda harus mengembalikan JSON sesuai struktur `PlayerData`.
    ```json
    {
        "status": 1,
        "mid": 1001,
        "mrolename": "Admin",
        "mlevel": 1,
        "mpoint": 0,
        "sex": 0
        ...
    }
    ```
*   **Goal**: Sampai loading bar selesai dan masuk ke Lobby (Kota Utama).

### Tahap 4: Fitur Utama
Setelah berhasil masuk Lobby, implementasikan fitur satu per satu:
1.  **Inventory**: Handle `GameMember.getNewWeapon` atau loading `GoodsList`.
2.  **Shop**: Handle pembelian item.
3.  **Map/Dungeon**: Handle logika masuk map (`GameCopys.getCopyGrade`).

## 4. Tips Debugging
*   **Lihat Log Klien**: Di `Constants.as`, `debug` diset ke `false`. Jika Anda recompile, set ke `true` untuk melihat `trace()` output di konsol Flash/Debug player. Ini sangat berharga untuk melihat JSON apa yang dikirim klien.
*   **Wireshark / Charles Proxy**: Jika menggunakan Opsi B (DNS Spoofing), gunakan tools ini untuk mengintip paket data HTTP yang dikirim klien.

---

### Langkah Selanjutnya
Saya sarankan Anda mulai dengan **Tahap 1** (Static Server) dan **Tahap 2** (Gateway Mocking) menggunakan Rust (Actix-web atau Axum). Apakah Anda ingin saya buatkan contoh kode Rust sederhana untuk menangani Tahap 1 dan 2?
