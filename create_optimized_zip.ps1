# Script untuk membuat ZIP yang dioptimalkan dari proyek Flutter
param(
    [string]$ProjectName = "monekito-optimized",
    [string]$CompressionLevel = "9"
)

Write-Host "📦 Membuat ZIP yang dioptimalkan untuk proyek Flutter..." -ForegroundColor Green

# Jalankan script pembersihan terlebih dahulu
Write-Host "🧹 Menjalankan pembersihan proyek..." -ForegroundColor Yellow
& ".\clean_for_zip.ps1"

# Tunggu sebentar
Start-Sleep -Seconds 2

# Periksa apakah 7-Zip tersedia
$7zPath = $null
$possiblePaths = @(
    "C:\Program Files\7-Zip\7z.exe",
    "C:\Program Files (x86)\7-Zip\7z.exe",
    "${env:ProgramFiles}\7-Zip\7z.exe",
    "${env:ProgramFiles(x86)}\7-Zip\7z.exe"
)

foreach ($path in $possiblePaths) {
    if (Test-Path $path) {
        $7zPath = $path
        break
    }
}

if ($7zPath) {
    Write-Host "✅ 7-Zip ditemukan di: $7zPath" -ForegroundColor Green
    
    # Buat nama file ZIP dengan timestamp
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $zipFileName = "${ProjectName}_${timestamp}.7z"
    
    Write-Host "📁 Membuat file: $zipFileName" -ForegroundColor Cyan
    
    # Buat file 7z dengan kompresi maksimal
    $arguments = @(
        "a",                    # Add to archive
        "-t7z",                 # 7z format
        "-m0=lzma2",           # LZMA2 compression method
        "-mx=$CompressionLevel", # Maximum compression
        "-mfb=64",             # Block size
        "-md=1024m",           # Dictionary size
        "-ms=on",              # Solid archive
        $zipFileName,          # Archive name
        ".",                   # Current directory
        "-x!*.git*",           # Exclude git files
        "-x!*.svn*",           # Exclude svn files
        "-x!*.hg*",            # Exclude mercurial files
        "-x!*.DS_Store*",      # Exclude macOS files
        "-x!Thumbs.db*",       # Exclude Windows files
        "-x!*.tmp",            # Exclude temp files
        "-x!*.log",            # Exclude log files
        "-x!*.cache*",         # Exclude cache files
        "-x!node_modules*",    # Exclude node modules
        "-x!vendor*",          # Exclude vendor files
        "-x!coverage*",        # Exclude coverage files
        "-x!*.zip",            # Exclude existing zip files
        "-x!*.7z",             # Exclude existing 7z files
        "-x!*.rar"             # Exclude existing rar files
    )
    
    Write-Host "🔧 Menggunakan kompresi level: $CompressionLevel" -ForegroundColor Yellow
    Write-Host "⏳ Memulai kompresi (ini mungkin memakan waktu beberapa menit)..." -ForegroundColor Yellow
    
    # Jalankan 7-Zip
    $process = Start-Process -FilePath $7zPath -ArgumentList $arguments -Wait -PassThru -NoNewWindow
    
    if ($process.ExitCode -eq 0) {
        Write-Host "✅ ZIP berhasil dibuat: $zipFileName" -ForegroundColor Green
        
        # Tampilkan informasi ukuran
        $fileInfo = Get-Item $zipFileName
        $sizeMB = [math]::Round($fileInfo.Length / 1MB, 2)
        Write-Host "📊 Ukuran file: $sizeMB MB" -ForegroundColor Cyan
        
        # Tampilkan lokasi file
        $fullPath = $fileInfo.FullName
        Write-Host "📍 Lokasi file: $fullPath" -ForegroundColor Cyan
        
    } else {
        Write-Host "❌ Gagal membuat ZIP. Exit code: $($process.ExitCode)" -ForegroundColor Red
    }
    
} else {
    Write-Host "❌ 7-Zip tidak ditemukan!" -ForegroundColor Red
    Write-Host "💡 Silakan install 7-Zip dari: https://7-zip.org/" -ForegroundColor Yellow
    Write-Host "🔄 Mencoba menggunakan PowerShell Compress-Archive..." -ForegroundColor Yellow
    
    # Fallback ke PowerShell Compress-Archive
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $zipFileName = "${ProjectName}_${timestamp}.zip"
    
    try {
        # Buat ZIP dengan PowerShell
        Compress-Archive -Path "." -DestinationPath $zipFileName -Force
        
        Write-Host "✅ ZIP berhasil dibuat: $zipFileName" -ForegroundColor Green
        
        # Tampilkan informasi ukuran
        $fileInfo = Get-Item $zipFileName
        $sizeMB = [math]::Round($fileInfo.Length / 1MB, 2)
        Write-Host "📊 Ukuran file: $sizeMB MB" -ForegroundColor Cyan
        
        # Tampilkan lokasi file
        $fullPath = $fileInfo.FullName
        Write-Host "📍 Lokasi file: $fullPath" -ForegroundColor Cyan
        
    } catch {
        Write-Host "❌ Gagal membuat ZIP dengan PowerShell: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "🎉 Selesai!" -ForegroundColor Green
Write-Host "💡 Tips untuk ukuran lebih kecil:" -ForegroundColor Yellow
Write-Host "   - Install 7-Zip untuk kompresi yang lebih baik" -ForegroundColor Yellow
Write-Host "   - Gunakan kompresi level 9 (maksimal)" -ForegroundColor Yellow
Write-Host "   - Hapus file yang tidak perlu sebelum kompresi" -ForegroundColor Yellow 