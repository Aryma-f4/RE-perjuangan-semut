# Instruksi Kompilasi SWF (Final Fix)

Error `unable to open '{airHome}'` terjadi karena Anda menggunakan `amxmlc` (Compiler AIR) padahal SDK Anda belum dikonfigurasi dengan AIR SDK lengkap, atau kita sebenarnya ingin mengkompilasi untuk **Web (Flash Player)**, bukan AIR.

Solusinya adalah menggunakan **`mxmlc`** (Compiler Flash Standard) dan memaksa konfigurasi web.

## Langkah 1: Jalankan Perintah Baru

Gunakan perintah ini di terminal (folder `antwarsmobilestarling.swf-decompile`):

**Windows:**
```cmd
C:\apacheflex\bin\mxmlc.bat -load-config="C:\apacheflex\frameworks\flex-config.xml" -source-path+=src -library-path+=libs -static-link-runtime-shared-libraries=true -output "..\antwars-web\public\antwars.swf" -target-player=11.4 src\AntWars.as
```

**Perubahan Penting:**
1.  Ganti `amxmlc.bat` menjadi **`mxmlc.bat`**.
2.  Tambah parameter `-load-config` yang menunjuk ke `flex-config.xml`. Ini memaksa compiler untuk menggunakan mode Web/Flash Player, bukan AIR.

## Langkah 2: Jika Masih Error (Opsi Alternatif)

Jika cara di atas masih gagal karena setup SDK yang rumit, Anda bisa mencoba **mendownload SWF yang sudah saya patch** (Jika saya bisa memberikannya, tapi saya tidak bisa).

Maka, pastikan di dalam folder `C:\apacheflex\frameworks\libs\player\11.4\` ada file `playerglobal.swc`. Jika folder versi `11.4` tidak ada, ganti `-target-player=11.4` menjadi versi yang ada di folder tersebut (misal `14.0` atau `20.0`).

Selamat mencoba!
