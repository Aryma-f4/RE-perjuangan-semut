# Panduan Setup untuk MacOS (Apple Silicon M1/M2)

Panduan ini khusus untuk pengguna MacBook dengan chip M1/M2 untuk menjalankan proyek Ant Wars Emulator.

## 1. Persiapan Terminal

Pastikan Anda menggunakan Terminal bawaan atau iTerm2. Disarankan untuk tidak menggunakan mode Rosetta kecuali terpaksa, namun beberapa tools lama (Flex SDK) mungkin butuh Java versi lama yang lebih stabil di x86_64.

## 2. Instalasi Homebrew

Jika belum punya, instal Homebrew:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## 3. Instalasi Rust & Node.js

```bash
# Instal Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"

# Instal Node.js
brew install node
```

## 4. Instalasi Java (PENTING)

Flex SDK membutuhkan Java 8 atau Java 11. Java versi terbaru sering bermasalah dengan compiler lama ini. Kita gunakan `sdkman` untuk mengelola versi Java.

```bash
# Instal SDKMAN
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

# Instal Java 8 (Zulu build support M1/M2 bagus)
sdk install java 8.0.382-zulu

# Set sebagai default
sdk use java 8.0.382-zulu
```

## 5. Setup Apache Flex SDK

1.  Download SDK dari: [https://flex.apache.org/download-binaries.html](https://flex.apache.org/download-binaries.html)
2.  Ekstrak ke folder yang mudah diakses, misal `~/Documents/flex_sdk`.
3.  **Berikan izin eksekusi**:
    MacOS sering memblokir file binary dari internet.
    ```bash
    cd ~/Documents/flex_sdk/bin
    chmod +x mxmlc
    xattr -d com.apple.quarantine mxmlc  # Jika perlu
    ```

## 6. Compile SWF di Mac (DIPERBARUI)

Jalankan perintah ini dari folder source code (`antwarsmobilestarling.swf-decompile`).
Catatan: Kita menggunakan `src/Main.as` karena `AntWars.as` tidak ditemukan. Jika folder `libs` kosong/tidak ada, buat dulu dengan `mkdir libs`.

```bash
# Buat folder libs jika belum ada
mkdir -p libs

# Compile (Sesuaikan path ke flex_sdk Anda)
~/Documents/flex_sdk/bin/mxmlc \
  -load-config+="$HOME/Documents/flex_sdk/frameworks/flex-config.xml" \
  -source-path+=src \
  -library-path+=libs \
  -static-link-runtime-shared-libraries=true \
  -output="../antwars-web/public/antwars.swf" \
  -target-player=11.4 \
  src/Main.as
```

## 7. Menjalankan Server (Port 80)

Di Mac, port 80 adalah privileged port.

1.  Edit `server_emulator/src/main.rs`: Pastikan `.bind(("127.0.0.1", 80))`
2.  Jalankan dengan `sudo`:
    ```bash
    cd server_emulator
    sudo ~/.cargo/bin/cargo run
    ```

## 8. Edit Hosts File

```bash
sudo nano /etc/hosts
```
Tambahkan:
```
127.0.0.1 mvlpidat01.boyaagame.com
127.0.0.1 pclpidat01.boyaagame.com
```
Simpan dengan `Ctrl+O`, lalu `Enter`, lalu `Ctrl+X`.

Selamat mencoba!
