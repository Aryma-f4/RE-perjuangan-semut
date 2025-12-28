# Instruksi Kompilasi SWF (Final Fix)

Error `configuration variable ... must only be set once` terjadi karena perintah sebelumnya memuat ulang konfigurasi default. Kita harus menghapus opsi `-load-config` karena `mxmlc` sudah memuatnya secara otomatis.

## Langkah 1: Persiapan

Pastikan Anda berada di folder `antwarsmobilestarling.swf-decompile` di terminal.
Buat folder `libs` jika belum ada: `mkdir libs`.

## Langkah 2: Jalankan Perintah Baru (Windows)

Copy perintah berikut ke terminal (CMD/PowerShell):

```cmd
C:\apacheflex\bin\mxmlc.bat -source-path+=src -library-path+=libs -static-link-runtime-shared-libraries=true -output "..\antwars-web\public\antwars.swf" -target-player=11.4 src\Main.as
```

**Perbaikan:**
1.  **Hapus `-load-config`**: Menghilangkan konflik konfigurasi ganda.
2.  **Gunakan `mxmlc`**: Compiler standar Flash Web.

## Langkah 3: Troubleshooting

Jika sukses, file `antwars.swf` akan muncul di folder `..\antwars-web\public\`. Anda bisa langsung refresh browser `localhost:3000` untuk melihat hasilnya.
