# Instruksi Kompilasi SWF (Wajib)

Karena Ruffle tidak mendukung fitur "Adobe AIR" (desktop) yang digunakan game asli, Anda **WAJIB** mengkompilasi ulang kode game menjadi file SWF web biasa.

Saya telah memodifikasi file `src/Application.as` dan `src/Constants.as` di folder source code Anda agar kompatibel dengan Web.

## Langkah 1: Download Apache Flex SDK

1.  Download **Apache Flex SDK 4.16.1** (atau versi 4.x lainnya).
    *   Link: [https://flex.apache.org/download-binaries.html](https://flex.apache.org/download-binaries.html)
2.  Ekstrak folder tersebut, misal ke: `C:\FlexSDK`.
3.  Pastikan di dalam folder `bin` ada file `amxmlc.bat` (Windows) atau `amxmlc` (Mac/Linux).

## Langkah 2: Struktur Folder

Pastikan struktur folder Anda seperti ini:
```
D:\projects\reverse\jule-perjuangan-semut\
  ├── antwarsmobilestarling.swf-decompile\
  │     ├── src\
  │     │    ├── AntWars.as
  │     │    ├── Application.as (Sudah dimodifikasi)
  │     │    └── ...
  │     └── libs\  (Jika ada library .swc)
```

## Langkah 3: Menjalankan Kompilasi

Buka terminal (CMD/PowerShell) di folder `antwarsmobilestarling.swf-decompile` dan jalankan perintah berikut:

**Windows:**
```cmd
C:\FlexSDK\bin\amxmlc.bat -src "src" -include-libraries "libs" -output "..\antwars-web\public\antwars.swf" --main-file "src\AntWars.as" -target-player=11.4
```

**Linux/Mac:**
```bash
/path/to/flexsdk/bin/amxmlc -src "src" -include-libraries "libs" -output "../antwars-web/public/antwars.swf" --main-file "src/AntWars.as" -target-player=11.4
```

*Catatan: Anda mungkin perlu menyesuaikan path `-include-libraries` jika library game (Starling, Feathers, dll) ada di folder lain.*

## Langkah 4: Test

Setelah berhasil compile, file `antwars.swf` baru akan muncul di folder `antwars-web/public/`. Refresh browser Next.js Anda (`localhost:3000`), dan Ruffle seharusnya bisa memuat game tanpa error `NativeApplication`.
