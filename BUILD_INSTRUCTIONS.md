# Instruksi Kompilasi SWF (Final Fix)

Error `unable to open '{airHome}'` terjadi karena Anda menggunakan `amxmlc` (Compiler AIR) padahal SDK Anda belum dikonfigurasi dengan AIR SDK lengkap, atau kita sebenarnya ingin mengkompilasi untuk **Web (Flash Player)**, bukan AIR.

Solusinya adalah menggunakan **`mxmlc`** (Compiler Flash Standard) dan memaksa konfigurasi web.

## Langkah 1: Persiapan

Pastikan Anda berada di folder `antwarsmobilestarling.swf-decompile` di terminal.
Buat folder `libs` jika belum ada: `mkdir libs`.

## Langkah 2: Jalankan Perintah Baru

Gunakan perintah ini di terminal (folder `antwarsmobilestarling.swf-decompile`).
**Catatan Penting:** File utama adalah `src\Main.as`.

**Windows:**
```cmd
C:\apacheflex\bin\mxmlc.bat -load-config="C:\apacheflex\frameworks\flex-config.xml" -source-path+=src -library-path+=libs -static-link-runtime-shared-libraries=true -output "..\antwars-web\public\antwars.swf" -target-player=11.4 src\Main.as
```

**Perubahan Penting:**
1.  Ganti `amxmlc.bat` menjadi **`mxmlc.bat`**.
2.  Ganti `src\AntWars.as` menjadi **`src\Main.as`**.
3.  Tambah parameter `-load-config` yang menunjuk ke `flex-config.xml`. Ini memaksa compiler untuk menggunakan mode Web/Flash Player, bukan AIR.

## Langkah 3: Troubleshooting

Jika masih ada error seperti `Type was not found ...`:
*   Karena hasil decompile sudah menyertakan library (Starling, Feathers) di dalam folder `src`, biasanya tidak butuh file tambahan di `libs`. Namun, pastikan semua folder seperti `com`, `starling`, `feathers` ada di dalam `src`.
