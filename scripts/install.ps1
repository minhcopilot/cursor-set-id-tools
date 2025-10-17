# Cursor Set ID Tools - Auto Install Script for Windows PowerShell
# Author: minhcopilot
# Repository: https://github.com/minhcopilot/cursor-set-id-tools

# Set execution policy for this script
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Set console encoding to UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$PSDefaultParameterValues['*:Encoding'] = 'utf8'

# Window title
$Host.UI.RawUI.WindowTitle = "Cursor Set ID Tools Installer"

# Define colors
$ColorInfo = "Cyan"
$ColorSuccess = "Green"  
$ColorError = "Red"
$ColorWarning = "Yellow"
$ColorInstall = "Magenta"

# Symbols
$EMOJI_SUCCESS = "[+]"
$EMOJI_ERROR = "[X]"
$EMOJI_INFO = "[i]"
$EMOJI_INSTALL = "[*]"
$EMOJI_ROCKET = "[>]"
$EMOJI_WARNING = "[!]"

# Function to print colored output
function Show-Info {
    param([string]$Message)
    Write-Host "$EMOJI_INFO $Message" -ForegroundColor $ColorInfo
}

function Show-Success {
    param([string]$Message)
    Write-Host "$EMOJI_SUCCESS $Message" -ForegroundColor $ColorSuccess
}

function Show-Error {
    param([string]$Message)
    Write-Host "$EMOJI_ERROR $Message" -ForegroundColor $ColorError
}

function Show-Warning {
    param([string]$Message)
    Write-Host "$EMOJI_WARNING $Message" -ForegroundColor $ColorWarning
}

function Show-Install {
    param([string]$Message)
    Write-Host "$EMOJI_INSTALL $Message" -ForegroundColor $ColorInstall
}

# Function to check if command exists
function Test-Command {
    param([string]$Command)
    return [bool](Get-Command $Command -ErrorAction SilentlyContinue)
}

# Function to check if running as administrator
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Function to install Python automatically
function Install-Python {
    Show-Warning "Python chua duoc cai dat. Dang tien hanh cai dat tu dong..."
    
    # Check winget
    if (Test-Command "winget") {
        Show-Install "Dang cai dat Python qua winget..."
        try {
            winget install -e --id Python.Python.3.12 --silent --accept-package-agreements --accept-source-agreements
            # Refresh PATH
            $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
            Show-Success "Python da duoc cai dat thanh cong!"
            return $true
        } catch {
            Show-Warning "Khong the cai dat qua winget, thu phuong phap khac..."
        }
    }
    
    # If winget not available, download and install Python manually
    Show-Install "Dang tai Python installer..."
    $pythonUrl = "https://www.python.org/ftp/python/3.12.0/python-3.12.0-amd64.exe"
    $pythonInstaller = "$env:TEMP\python-installer.exe"
    
    try {
        # Download Python installer
        Invoke-WebRequest -Uri $pythonUrl -OutFile $pythonInstaller -UseBasicParsing
        
        Show-Install "Dang cai dat Python (co the mat vai phut)..."
        # Install Python with pip and add to PATH
        Start-Process -FilePath $pythonInstaller -ArgumentList "/quiet", "InstallAllUsers=0", "PrependPath=1", "Include_pip=1" -Wait
        
        # Refresh PATH
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        
        # Clean up installer
        Remove-Item $pythonInstaller -Force
        
        Show-Success "Python da duoc cai dat thanh cong!"
        return $true
    } catch {
        Show-Error "Khong the cai dat Python tu dong: $_"
        Show-Info "Vui long cai dat Python thu cong tu: https://www.python.org/downloads/"
        Show-Warning "Luu y: Nho chon 'Add Python to PATH' khi cai dat!"
        Read-Host "Nhan Enter de thoat"
        exit 1
    }
}

# Function to install Git automatically
function Install-Git {
    Show-Warning "Git chua duoc cai dat. Dang tien hanh cai dat tu dong..."
    
    # Check winget
    if (Test-Command "winget") {
        Show-Install "Dang cai dat Git qua winget..."
        try {
            winget install -e --id Git.Git --silent --accept-package-agreements --accept-source-agreements
            # Refresh PATH
            $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
            Show-Success "Git da duoc cai dat thanh cong!"
            return $true
        } catch {
            Show-Warning "Khong the cai dat qua winget, thu phuong phap khac..."
        }
    }
    
    # If winget not available, download and install Git manually
    Show-Install "Dang tai Git installer..."
    $gitUrl = "https://github.com/git-for-windows/git/releases/download/v2.42.0.windows.2/Git-2.42.0.2-64-bit.exe"
    $gitInstaller = "$env:TEMP\git-installer.exe"
    
    try {
        # Download Git installer
        Invoke-WebRequest -Uri $gitUrl -OutFile $gitInstaller -UseBasicParsing
        
        Show-Install "Dang cai dat Git (co the mat vai phut)..."
        # Install Git silently
        Start-Process -FilePath $gitInstaller -ArgumentList "/VERYSILENT", "/NORESTART", "/NOCANCEL", "/SP-", "/CLOSEAPPLICATIONS", "/RESTARTAPPLICATIONS", "/COMPONENTS=icons,ext\reg\shellhere,assoc,assoc_sh" -Wait
        
        # Refresh PATH
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        
        # Clean up installer
        Remove-Item $gitInstaller -Force
        
        Show-Success "Git da duoc cai dat thanh cong!"
        return $true
    } catch {
        Show-Error "Khong the cai dat Git tu dong: $_"
        Show-Info "Vui long cai dat Git thu cong tu: https://git-scm.com/download/win"
        Read-Host "Nhan Enter de thoat"
        exit 1
    }
}

# Main installation function
function Install-CursorSetIdTools {
    Show-Info "Bat dau cai dat Cursor Set ID Tools..."

    # Check and install Python if needed
    if (-not (Test-Command "python")) {
        Install-Python
        Start-Sleep -Seconds 2
        
        # Check again after installation
        if (-not (Test-Command "python")) {
            Show-Error "Python van chua san sang. Vui long khoi dong lai PowerShell va thu lai."
            Read-Host "Nhan Enter de thoat"
            exit 1
        }
    } else {
        Show-Success "Python da duoc cai dat san"
    }

    # Check pip (Python 3.4+ automatically includes pip)
    if (-not (Test-Command "pip")) {
        Show-Warning "pip chua san sang, dang thu khac phuc..."
        # Try using python -m pip
        try {
            python -m ensurepip --default-pip 2>$null
            Show-Success "pip da duoc kich hoat!"
        } catch {
            Show-Error "Khong the kich hoat pip. Vui long cai dat lai Python."
            Read-Host "Nhan Enter de thoat"
            exit 1
        }
    } else {
        Show-Success "pip da duoc cai dat san"
    }

    # Check and install git if needed
    if (-not (Test-Command "git")) {
        Install-Git
        Start-Sleep -Seconds 2
        
        # Check again after installation
        if (-not (Test-Command "git")) {
            Show-Error "Git van chua san sang. Vui long khoi dong lai PowerShell va thu lai."
            Read-Host "Nhan Enter de thoat"
            exit 1
        }
    } else {
        Show-Success "Git da duoc cai dat san"
    }

    # Setup installation directory
    $InstallDir = Join-Path $env:USERPROFILE "cursor-set-id-tools"

    # Remove existing directory if exists
    if (Test-Path $InstallDir) {
        try {
            Remove-Item -Path $InstallDir -Recurse -Force
        } catch {
            Show-Error "Khong the xoa thu muc hien co: $_"
            Read-Host "Nhan Enter de thoat"
            exit 1
        }
    }

    # Clone repository
    Show-Install "Dang tai xuong..."
    try {
        git clone https://github.com/minhcopilot/cursor-set-id-tools.git $InstallDir 2>$null
    } catch {
        Show-Error "Khong the tai xuong. Vui long kiem tra ket noi internet."
        Read-Host "Nhan Enter de thoat"
        exit 1
    }

    # Change to installation directory
    Set-Location $InstallDir

    # Install Python dependencies
    Show-Install "Dang cai dat cac thu vien Python can thiet..."
    try {
        # Try to upgrade pip first
        python -m pip install --upgrade pip --quiet 2>$null
        
        # Install from requirements.txt
        python -m pip install -r requirements.txt --quiet
        Show-Success "Da cai dat tat ca thu vien thanh cong!"
    } catch {
        Show-Warning "Thu cai dat voi quyen user..."
        try {
            python -m pip install --user -r requirements.txt --quiet
            Show-Success "Da cai dat tat ca thu vien thanh cong!"
        } catch {
            Show-Error "Khong the cai dat dependencies: $_"
            Show-Info "Ban co the thu cai dat thu cong: pip install -r requirements.txt"
            Read-Host "Nhan Enter de thoat"
            exit 1
        }
    }

    Show-Success "Cai dat hoan tat!"
    
    # Auto run tool
    Show-Install "Dang khoi dong tool..."
    try {
        Set-Location $InstallDir
        python main.py
    } catch {
        Show-Warning "Khong the tu dong chay. Hay vao thu muc $InstallDir va chay 'python main.py'"
        Read-Host "Nhan Enter de thoat"
    }
}

# Banner and startup message
function Show-Banner {
    Write-Host "`n"
    Write-Host "=============================================================" -ForegroundColor Cyan
    Write-Host "                                                             " -ForegroundColor Cyan
    Write-Host "         CURSOR SET ID TOOLS - AUTO INSTALLER                " -ForegroundColor Cyan
    Write-Host "                                                             " -ForegroundColor Cyan
    Write-Host "      Tool tu dong cai dat tat ca dependencies               " -ForegroundColor Cyan
    Write-Host "           bao gom Python, Git va pip!                       " -ForegroundColor Cyan
    Write-Host "                                                             " -ForegroundColor Cyan
    Write-Host "=============================================================" -ForegroundColor Cyan
    Write-Host "`n"
}

# Run installation
try {
    Show-Banner
    Install-CursorSetIdTools
} catch {
    Show-Error "Loi: $_"
    Show-Info "Neu gap van de, vui long bao cao tai: https://github.com/minhcopilot/cursor-set-id-tools/issues"
    Read-Host "Nhan Enter de thoat"
    exit 1
}