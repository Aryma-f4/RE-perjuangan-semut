# Panduan Lengkap Pengembangan (Step-by-Step Guide)

Panduan ini dirancang untuk pemula (0% knowledge) agar bisa membangun server dan menjalankan game Ant Wars (Perjuangan Semut) secara lokal.

---

## BAGIAN 1: Persiapan Server (Backend)

Kita akan membuat server emulator sederhana menggunakan bahasa **Rust**. Server ini bertugas menerima data dari game (klien) dan membalasnya.

### 1. Instalasi Rust
1.  Kunjungi [rustup.rs](https://rustup.rs/).
2.  Download dan jalankan installer untuk OS Anda (Windows/Mac/Linux).
3.  Buka terminal (CMD/PowerShell) dan ketik: `cargo --version`. Jika muncul angka versi, instalasi berhasil.

### 2. Menjalankan Server Emulator
Saya telah menyiapkan kode dasar server di folder `server_emulator`.

1.  Buka terminal di folder proyek ini.
2.  Masuk ke folder server:
    ```bash
    cd server_emulator
    ```
3.  Jalankan server:
    ```bash
    cargo run
    ```
4.  Tunggu proses download dan compile selesai.
5.  Jika berhasil, akan muncul tulisan: `Server running at http://127.0.0.1:8080`.
    *   **Jangan tutup terminal ini.** Server harus terus menyala agar game bisa dimainkan.

---

## BAGIAN 2: Persiapan Klien (Game APK)

Tantangan utama adalah game asli (`antwarsmobilestarling.swf`) dikunci untuk menghubungi server resmi yang sudah mati. Kita harus mengubahnya agar menghubungi server lokal kita (`127.0.0.1`).

Ada dua cara untuk melakukan ini:

### CARA A: DNS Spoofing (Paling Mudah - Tidak perlu build ulang)
Cara ini menipu HP/Emulator agar mengira komputer Anda adalah server resmi.

1.  Pastikan Server Emulator (Bagian 1) sudah jalan.
2.  Instal **Fiddler Classic** atau **Charles Proxy** di komputer Anda (opsional, untuk debug).
3.  **Di Windows**:
    *   Buka Notepad sebagai Administrator.
    *   Buka file: `C:\Windows\System32\drivers\etc\hosts`.
    *   Tambahkan baris ini di paling bawah:
        ```
        127.0.0.1 mvlpidat01.boyaagame.com
        127.0.0.1 pclpidat01.boyaagame.com
        ```
    *   Simpan file.
4.  **Di Android Emulator (Bluestacks/LDPlayer)**:
    *   Anda perlu mengedit file `/system/etc/hosts` di dalam emulator (butuh Root).
    *   Atau, ganti setting DNS emulator ke IP komputer Anda (jika menggunakan DNS server lokal).
    *   **Alternatif Mudah**: Gunakan aplikasi "Hosts Go" di Android untuk mengarahkan domain tersebut ke IP Komputer Anda (misal `192.168.1.X`).

### CARA B: Recompile SWF (Cara "Proper" - Lebih Sulit)
Cara ini memodifikasi kode sumber game (`src/Constants.as`) dan memaket ulang menjadi APK baru.

#### 1. Persiapan Tools
*   Download **IntelliJ IDEA** (Community Edition gratis).
*   Download **Apache Flex SDK 4.6** + **AIR SDK** (Cari "Apache Flex SDK Installer").
*   Download **Android Studio**.

#### 2. Edit Kode
1.  Buka file `antwarsmobilestarling.swf-decompile/src/Constants.as`.
2.  Cari baris `private static var _isLocal:Boolean`.
3.  Ubah array `CONST_ARR` menjadi `[3, false, true, 1]` (ini mengaktifkan mode lokal).
4.  Cari `_IpAddress` dan ubah menjadi `http://127.0.0.1:8080/antwarsmobile/`.

#### 3. Compile SWF
Anda membutuhkan perintah `amxmlc` dari Flex SDK untuk mengubah kode `.as` menjadi `.swf`.
```bash
# Contoh command (jalankan di terminal)
amxmlc -source-path+=src -output=bin/antwarsmobilestarling.swf src/AntWars.as
```
*(Catatan: Anda mungkin perlu memperbaiki banyak error library yang hilang karena dekompilasi tidak selalu 100% sempurna)*.

#### 4. Build APK
1.  Ambil file `antwarsmobilestarling.swf` yang baru dibuat.
2.  Timpa file lama di `app/src/main/assets/antwarsmobilestarling.swf`.
3.  Buka proyek ini di **Android Studio**.
4.  Klik menu **Build > Build Bundle(s) / APK(s) > Build APK**.
5.  Install APK hasil build ke HP Anda.

---

## BAGIAN 3: Mengembangkan Fitur

Saat ini server emulator (`server_emulator/src/main.rs`) hanya memiliki fitur Login dasar.

Untuk menambah fitur (misal: Toko/Shop):
1.  Buka `server_emulator/src/main.rs`.
2.  Lihat bagian `match params.method.as_str()`.
3.  Tambahkan case baru, misal:
    ```rust
    "GameCopys.buyProp" => {
        // Logika pembelian item
        HttpResponse::Ok().json(serde_json::json!({"status": 1, "msg": "Beli Sukses"}))
    },
    ```
4.  Restart server (`Ctrl+C`, lalu `cargo run` lagi) setiap kali mengubah kode.

---

## Ringkasan untuk Pemula
1.  Instal Rust.
2.  Jalankan `cd server_emulator && cargo run`.
3.  Gunakan **Cara A (DNS Spoofing)** karena jauh lebih mudah daripada compile ulang game Flash lama.
4.  Install APK asli (dari folder repo `Perjuangan Semut_1.14.85_APKPure.apk`) ke Emulator.
5.  Set Hosts di Emulator agar `mvlpidat01.boyaagame.com` mengarah ke IP Komputer Anda.
6.  Buka Game. Lihat terminal server Rust, jika ada tulisan "Request: ...", berarti berhasil konek!
