# 📦 Panduan Kompresi Proyek Flutter Monekito

Panduan lengkap untuk membuat file ZIP yang kecil dari proyek Flutter ini.

## 🎯 Tujuan
- Mengurangi ukuran file ZIP dari beberapa GB menjadi beberapa MB
- Menghapus file-file yang tidak perlu
- Mengoptimalkan kompresi untuk distribusi yang efisien

## 🚀 Cara Cepat (Otomatis)

### 1. Jalankan Script Pembersihan
```powershell
# Jalankan script pembersihan
.\clean_for_zip.ps1
```

### 2. Buat ZIP yang Dioptimalkan
```powershell
# Buat ZIP dengan kompresi maksimal
.\create_optimized_zip.ps1

# Atau dengan nama custom
.\create_optimized_zip.ps1 -ProjectName "monekito-v1.0" -CompressionLevel "9"
```

## 🧹 Pembersihan Manual

### File/Direktori yang Dihapus:
- `build/` - Output build Flutter
- `.dart_tool/` - Cache Dart
- `android/build/` - Output build Android
- `android/app/build/` - Output build APK
- `pubspec.lock` - Lock file dependencies
- `.flutter-plugins*` - Plugin cache
- `.packages` - Package cache
- `.pub/` - Pub cache
- `.fvm/` - Flutter version manager cache
- `.idea/` - IntelliJ IDEA settings
- `.vscode/` - VS Code settings
- `android/keys/` - Keystore files
- `*.log` - Log files
- `*.tmp`, `*.temp` - Temporary files

### Perintah Manual:
```powershell
# Hapus direktori build
Remove-Item -Recurse -Force build, .dart_tool, android/build, android/app/build

# Hapus cache
Remove-Item -Recurse -Force .flutter-plugins*, .packages, .pub, .fvm

# Hapus IDE settings
Remove-Item -Recurse -Force .idea, .vscode

# Hapus keystore
Remove-Item -Recurse -Force android/keys

# Hapus file temporary
Get-ChildItem -Recurse -Include "*.log", "*.tmp", "*.temp" | Remove-Item -Force
```

## 📦 Kompresi Manual

### Menggunakan 7-Zip (Direkomendasikan)
1. Download dan install [7-Zip](https://7-zip.org/)
2. Buka 7-Zip File Manager
3. Navigasi ke direktori proyek
4. Pilih semua file dan folder
5. Klik "Add" dan pilih:
   - Archive format: 7z
   - Compression level: Ultra
   - Dictionary size: 1024 MB
   - Word size: 64
   - Solid block size: 64

### Menggunakan PowerShell
```powershell
# Kompresi dasar
Compress-Archive -Path "." -DestinationPath "monekito.zip" -Force

# Kompresi dengan exclusion
$exclude = @("build", ".dart_tool", "android/build", ".idea", ".vscode")
$files = Get-ChildItem -Path "." -Exclude $exclude
Compress-Archive -Path $files -DestinationPath "monekito-clean.zip" -Force
```

### Menggunakan WinRAR
1. Buka WinRAR
2. Pilih file dan folder yang akan dikompres
3. Klik "Add to archive"
4. Pilih:
   - Archive format: RAR
   - Compression method: Best
   - Dictionary size: 1024 MB
   - Solid archiving: Yes

## 📊 Perbandingan Ukuran

### Sebelum Pembersihan:
- Proyek asli: ~2-5 GB
- Termasuk build files, cache, dan temporary files

### Setelah Pembersihan:
- Proyek bersih: ~50-200 MB
- Hanya source code dan assets yang diperlukan

### Setelah Kompresi:
- ZIP dengan 7-Zip: ~20-80 MB
- ZIP dengan PowerShell: ~40-150 MB
- RAR dengan WinRAR: ~30-100 MB

## 🔧 Optimasi Lanjutan

### 1. Hapus Assets yang Tidak Perlu
```powershell
# Hapus screenshot dan mockup (jika tidak diperlukan)
Remove-Item -Recurse -Force "app-marketplaces/screenshots"
Remove-Item -Recurse -Force "app-marketplaces/Mockups"
```

### 2. Hapus Database Sample
```powershell
# Hapus database sample (jika tidak diperlukan)
Remove-Item -Force "assets/sql/samples/*.db"
```

### 3. Hapus Font yang Tidak Digunakan
```powershell
# Periksa font yang benar-benar digunakan di pubspec.yaml
# Hapus font yang tidak diperlukan
```

### 4. Optimasi Gambar
```powershell
# Gunakan tools seperti ImageOptim atau TinyPNG
# Konversi PNG ke WebP untuk ukuran lebih kecil
```

## ⚠️ Perhatian

### Jangan Hapus:
- `lib/` - Source code utama
- `assets/` - Assets aplikasi (kecuali yang tidak diperlukan)
- `android/app/src/` - Source Android
- `ios/Runner/` - Source iOS
- `pubspec.yaml` - Konfigurasi dependencies
- `README.md` - Dokumentasi

### Backup Sebelum Pembersihan:
```powershell
# Buat backup sebelum pembersihan
Copy-Item -Path "." -Destination "../monekito-backup" -Recurse
```

## 🎉 Hasil Akhir

Setelah mengikuti panduan ini, Anda akan mendapatkan:
- ✅ File ZIP yang jauh lebih kecil (80-90% pengurangan ukuran)
- ✅ Proyek yang bersih dan siap didistribusikan
- ✅ Tidak ada file cache atau temporary yang tidak perlu
- ✅ Kompresi yang optimal untuk transfer dan storage

## 📞 Bantuan

Jika mengalami masalah:
1. Jalankan script `clean_for_zip.ps1` terlebih dahulu
2. Pastikan tidak ada proses Flutter yang sedang berjalan
3. Restart terminal jika diperlukan
4. Gunakan 7-Zip untuk kompresi terbaik

---

**Happy Compressing! 🎯📦** 