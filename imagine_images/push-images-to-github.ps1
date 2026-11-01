# PowerShell script: Kopieer afbeeldingen naar Desktop en push naar GitHub
# Voer dit uit in PowerShell (als Administrator indien nodig)

$ErrorActionPreference = "Stop"

# Configuratie
$DesktopPath = [Environment]::GetFolderPath("Desktop")
$RepoName = "vlaamse-digitale-uitnodigingen"
$RepoUrl = "https://github.com/icecoldsteve/vlaamse-digitale-uitnodigingen.git"
$ImagesFolder = Join-Path $DesktopPath "imagine_images"
$RepoFolder = Join-Path $DesktopPath $RepoName

Write-Host "=== Vlaamse Uitnodigingen - Afbeeldingen naar GitHub ===" -ForegroundColor Cyan

# Stap 1: Maak map op Desktop
if (-not (Test-Path $ImagesFolder)) {
    New-Item -ItemType Directory -Path $ImagesFolder | Out-Null
    Write-Host "Map aangemaakt: $ImagesFolder" -ForegroundColor Green
} else {
    Write-Host "Map bestaat al: $ImagesFolder" -ForegroundColor Yellow
}

# Stap 2: Instructie voor afbeeldingen
Write-Host "`nSTAP 2: Plaats de afbeeldingen" -ForegroundColor Cyan
Write-Host "Kopieer de volgende JPG-bestanden naar: $ImagesFolder" -ForegroundColor White
Write-Host @"
2R3u3.jpg
4tIlB.jpg
5Vzow.jpg
Gi063.jpg
LO0Ii.jpg
PqGsU.jpg
ZqACk.jpg
k4Lxm.jpg
oPMXG.jpg
qNywA.jpg
sG1FP.jpg
ubu4B.jpg
wLzza.jpg
yl7gS.jpg
"@ -ForegroundColor Gray

$continue = Read-Host "`nHeb je de afbeeldingen in $ImagesFolder geplaatst? (j/n)"
if ($continue -ne "j") {
    Write-Host "Stop. Plaats eerst de afbeeldingen en start het script opnieuw." -ForegroundColor Red
    exit
}

# Stap 3: Clone of update repo
Write-Host "`nSTAP 3: GitHub repo voorbereiden" -ForegroundColor Cyan
if (Test-Path $RepoFolder) {
    Write-Host "Repo bestaat al, pullen..." -ForegroundColor Yellow
    Set-Location $RepoFolder
    git pull origin main
} else {
    Write-Host "Clonen van repo..." -ForegroundColor Green
    Set-Location $DesktopPath
    git clone $RepoUrl
    Set-Location $RepoFolder
}

# Stap 4: Kopieer afbeeldingen naar repo
Write-Host "`nSTAP 4: Afbeeldingen kopiëren naar repo" -ForegroundColor Cyan
$TargetImages = Join-Path $RepoFolder "imagine_images"
if (-not (Test-Path $TargetImages)) {
    New-Item -ItemType Directory -Path $TargetImages | Out-Null
}

Copy-Item -Path "$ImagesFolder\*.jpg" -Destination $TargetImages -Force
Write-Host "Afbeeldingen gekopieerd naar $TargetImages" -ForegroundColor Green

# Stap 5: Git commit en push
Write-Host "`nSTAP 5: Commit en push naar GitHub" -ForegroundColor Cyan
Set-Location $RepoFolder
git add imagine_images/
git status

$commit = Read-Host "`nCommit message (Enter voor standaard)"
if ([string]::IsNullOrWhiteSpace($commit)) {
    $commit = "Add invitation images"
}

git commit -m $commit
git push origin main

Write-Host "`nKlaar! Afbeeldingen staan nu op GitHub." -ForegroundColor Green
Write-Host "Repo: $RepoUrl" -ForegroundColor Cyan
Write-Host "`nVolgende stap: koppel de repo aan Vercel voor de live site." -ForegroundColor Yellow
