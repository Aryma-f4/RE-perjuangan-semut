# Instruksi Kompilasi SWF (Koreksi)

Terdapat kesalahan sintaks pada perintah sebelumnya. Compiler `amxmlc`/`mxmlc` tidak menggunakan flag `-src` atau `--main-file`.

Berikut adalah perintah yang **BENAR** untuk mengkompilasi ulang kode game.

## Langkah 1: Persiapan

Pastikan Anda berada di folder `antwarsmobilestarling.swf-decompile` di terminal.

## Langkah 2: Jalankan Perintah

Copy dan paste perintah di bawah ini (sesuaikan path `amxmlc.bat` jika perlu):

**Windows:**
```cmd
C:\apacheflex\bin\amxmlc.bat -source-path+=src -library-path+=libs -static-link-runtime-shared-libraries=true -output "..\antwars-web\public\antwars.swf" -target-player=11.4 src\AntWars.as
```

**Penjelasan Perubahan:**
1.  **Hapus `-src`**: Diganti dengan `-source-path+=src`.
2.  **Hapus `--main-file`**: File utama (`src\AntWars.as`) diletakkan di **akhir perintah** sebagai argumen posisi.
3.  **Ganti `-include-libraries`**: Diganti dengan `-library-path+=libs` (agar library dilink dengan benar).
4.  **Tambah `-static-link-runtime-shared-libraries=true`**: Opsi ini penting agar SWF tidak error saat dijalankan di Ruffle karena kekurangan library RSL bawaan.

## Langkah 3: Troubleshooting

Jika masih ada error seperti `Type was not found ...`:
*   Cek apakah folder `libs` benar-benar berisi file `.swc` (library game). Jika kosong/tidak ada, Anda mungkin perlu mencari library Starling/Feathers SWC versi lama dan memasukkannya ke sana.
