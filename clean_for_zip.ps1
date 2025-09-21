# Script untuk membersihkan proyek Flutter sebelum di-compress
Write-Host "🧹 Membersihkan proyek Flutter untuk kompresi ZIP..." -ForegroundColor Green

# Hapus direktori build
Write-Host "🗑️  Menghapus direktori build..." -ForegroundColor Yellow
if (Test-Path "build") {
    Remove-Item -Recurse -Force "build"
    Write-Host "✅ Direktori build dihapus" -ForegroundColor Green
}

# Hapus direktori .dart_tool
Write-Host "🗑️  Menghapus direktori .dart_tool..." -ForegroundColor Yellow
if (Test-Path ".dart_tool") {
    Remove-Item -Recurse -Force ".dart_tool"
    Write-Host "✅ Direktori .dart_tool dihapus" -ForegroundColor Green
}

# Hapus direktori android/build
Write-Host "🗑️  Menghapus direktori android/build..." -ForegroundColor Yellow
if (Test-Path "android/build") {
    Remove-Item -Recurse -Force "android/build"
    Write-Host "✅ Direktori android/build dihapus" -ForegroundColor Green
}

# Hapus direktori android/app/build
Write-Host "🗑️  Menghapus direktori android/app/build..." -ForegroundColor Yellow
if (Test-Path "android/app/build") {
    Remove-Item -Recurse -Force "android/app/build"
    Write-Host "✅ Direktori android/app/build dihapus" -ForegroundColor Green
}

# Hapus file lock
Write-Host "🗑️  Menghapus file lock..." -ForegroundColor Yellow
if (Test-Path "pubspec.lock") {
    Remove-Item "pubspec.lock"
    Write-Host "✅ File pubspec.lock dihapus" -ForegroundColor Green
}

# Hapus direktori .flutter-plugins
Write-Host "🗑️  Menghapus direktori .flutter-plugins..." -ForegroundColor Yellow
if (Test-Path ".flutter-plugins") {
    Remove-Item -Recurse -Force ".flutter-plugins"
    Write-Host "✅ Direktori .flutter-plugins dihapus" -ForegroundColor Green
}

# Hapus direktori .flutter-plugins-dependencies
Write-Host "🗑️  Menghapus direktori .flutter-plugins-dependencies..." -ForegroundColor Yellow
if (Test-Path ".flutter-plugins-dependencies") {
    Remove-Item -Recurse -Force ".flutter-plugins-dependencies"
    Write-Host "✅ Direktori .flutter-plugins-dependencies dihapus" -ForegroundColor Green
}

# Hapus direktori .packages
Write-Host "🗑️  Menghapus direktori .packages..." -ForegroundColor Yellow
if (Test-Path ".packages") {
    Remove-Item -Recurse -Force ".packages"
    Write-Host "✅ Direktori .packages dihapus" -ForegroundColor Green
}

# Hapus direktori .pub
Write-Host "🗑️  Menghapus direktori .pub..." -ForegroundColor Yellow
if (Test-Path ".pub") {
    Remove-Item -Recurse -Force ".pub"
    Write-Host "✅ Direktori .pub dihapus" -ForegroundColor Green
}

# Hapus direktori .fvm
Write-Host "🗑️  Menghapus direktori .fvm..." -ForegroundColor Yellow
if (Test-Path ".fvm") {
    Remove-Item -Recurse -Force ".fvm"
    Write-Host "✅ Direktori .fvm dihapus" -ForegroundColor Green
}

# Hapus direktori .idea
Write-Host "🗑️  Menghapus direktori .idea..." -ForegroundColor Yellow
if (Test-Path ".idea") {
    Remove-Item -Recurse -Force ".idea"
    Write-Host "✅ Direktori .idea dihapus" -ForegroundColor Green
}

# Hapus direktori .vscode
Write-Host "🗑️  Menghapus direktori .vscode..." -ForegroundColor Yellow
if (Test-Path ".vscode") {
    Remove-Item -Recurse -Force ".vscode"
    Write-Host "✅ Direktori .vscode dihapus" -ForegroundColor Green
}

# Hapus file keystore
Write-Host "🗑️  Menghapus file keystore..." -ForegroundColor Yellow
if (Test-Path "android/app/upload-keystore.jks") {
    Remove-Item "android/app/upload-keystore.jks"
    Write-Host "✅ File keystore dihapus" -ForegroundColor Green
}

# Hapus direktori keys
Write-Host "🗑️  Menghapus direktori keys..." -ForegroundColor Yellow
if (Test-Path "android/keys") {
    Remove-Item -Recurse -Force "android/keys"
    Write-Host "✅ Direktori keys dihapus" -ForegroundColor Green
}

# Hapus file log
Write-Host "🗑️  Menghapus file log..." -ForegroundColor Yellow
Get-ChildItem -Recurse -Include "*.log" | Remove-Item -Force
Write-Host "✅ File log dihapus" -ForegroundColor Green

# Hapus file temporary
Write-Host "🗑️  Menghapus file temporary..." -ForegroundColor Yellow
Get-ChildItem -Recurse -Include "*.tmp", "*.temp", "*.swp", "*.swo", "*~" | Remove-Item -Force
Write-Host "✅ File temporary dihapus" -ForegroundColor Green

Write-Host "🎉 Proyek berhasil dibersihkan!" -ForegroundColor Green
Write-Host "📦 Sekarang bisa di-compress menjadi ZIP dengan ukuran yang lebih kecil" -ForegroundColor Cyan
Write-Host "💡 Tips: Gunakan 7-Zip atau WinRAR dengan kompresi maksimal" -ForegroundColor Yellow 