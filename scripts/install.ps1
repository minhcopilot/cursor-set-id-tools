# Cursor Set ID Tools - Script Cài Đặt Tự Động cho Windows PowerShell
# Tác giả: minhcopilot
# Repository: https://github.com/minhcopilot/cursor-set-id-tools

# Thiết lập execution policy cho script này
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Màu sắc và định dạng
$Host.UI.RawUI.WindowTitle = "Trình Cài Đặt Cursor Set ID Tools"

# Định nghĩa màu sắc
$ColorInfo = "Cyan"
$ColorSuccess = "Green"  
$ColorError = "Red"
$ColorWarning = "Yellow"
$ColorInstall = "Magenta"

# Biểu tượng
$SUCCESS = "✅"
$ERROR = "❌"
$INFO = "ℹ️"
$INSTALL = "📦"
$ROCKET = "🚀"
$WARNING = "⚠️"

# Hàm in output có màu
function Write-Info {
    param([string]$Message)
    Write-Host "$INFO $Message" -ForegroundColor $ColorInfo
}

function Write-Success {
    param([string]$Message)
    Write-Host "$SUCCESS $Message" -ForegroundColor $ColorSuccess
}

function Write-Error {
    param([string]$Message)
    Write-Host "$ERROR $Message" -ForegroundColor $ColorError
}

function Write-Warning {
    param([string]$Message)
    Write-Host "$WARNING $Message" -ForegroundColor $ColorWarning
}

function Write-Install {
    param([string]$Message)
    Write-Host "$INSTALL $Message" -ForegroundColor $ColorInstall
}

# Hàm kiểm tra lệnh có tồn tại không
function Test-Command {
    param([string]$Command)
    return [bool](Get-Command $Command -ErrorAction SilentlyContinue)
}

# Hàm kiểm tra có chạy với quyền administrator không
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Hàm cài đặt chính
function Install-CursorSetIdTools {
    # Hiển thị banner
    Write-Host ""
    Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Blue
    Write-Host "║              Trình Cài Đặt Cursor Set ID Tools               ║" -ForegroundColor Blue
    Write-Host "║            Script Cài Đặt Tự Động cho Windows               ║" -ForegroundColor Blue
    Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Blue
    Write-Host ""

    # Kiểm tra có chạy với quyền administrator không
    if (Test-Administrator) {
        Write-Success "Đang chạy với quyền Administrator"
    } else {
        Write-Warning "Không chạy với quyền Administrator. Một số tính năng có thể cần quyền admin sau này."
    }

    # Kiểm tra Python đã được cài đặt chưa
    if (-not (Test-Command "python")) {
        Write-Error "Python chưa được cài đặt hoặc không có trong PATH."
        Write-Host "Vui lòng cài đặt Python 3.7+ từ https://www.python.org/downloads/" -ForegroundColor Yellow
        Write-Host "Đảm bảo chọn 'Add Python to PATH' trong quá trình cài đặt" -ForegroundColor Yellow
        Read-Host "Nhấn Enter để thoát"
        exit 1
    }

    # Lấy phiên bản Python
    try {
        $pythonVersion = python --version 2>&1
        Write-Success "Đã tìm thấy Python: $pythonVersion"
    } catch {
        Write-Error "Không thể lấy phiên bản Python"
        exit 1
    }

    # Kiểm tra pip có sẵn không
    if (-not (Test-Command "pip")) {
        Write-Error "pip chưa được cài đặt hoặc không có trong PATH."
        Write-Host "Vui lòng cài đặt lại Python với pip đi kèm" -ForegroundColor Yellow
        Read-Host "Nhấn Enter để thoát"
        exit 1
    }

    try {
        $pipVersion = pip --version 2>&1
        Write-Success "Đã tìm thấy pip: $pipVersion"
    } catch {
        Write-Error "Không thể lấy phiên bản pip"
        exit 1
    }

    # Kiểm tra git đã được cài đặt chưa
    if (-not (Test-Command "git")) {
        Write-Error "Git chưa được cài đặt hoặc không có trong PATH."
        Write-Host "Vui lòng cài đặt Git từ https://git-scm.com/download/win" -ForegroundColor Yellow
        Read-Host "Nhấn Enter để thoát"
        exit 1
    }

    try {
        $gitVersion = git --version 2>&1
        Write-Success "Đã tìm thấy Git: $gitVersion"
    } catch {
        Write-Error "Không thể lấy phiên bản Git"
        exit 1
    }

    # Thiết lập thư mục cài đặt
    $InstallDir = Join-Path $env:USERPROFILE "cursor-set-id-tools"
    Write-Info "Thư mục cài đặt: $InstallDir"

    # Xóa thư mục hiện có nếu tồn tại
    if (Test-Path $InstallDir) {
        Write-Warning "Thư mục $InstallDir đã tồn tại. Đang xóa..."
        try {
            Remove-Item -Path $InstallDir -Recurse -Force
            Write-Success "Đã xóa thư mục hiện có"
        } catch {
            Write-Error "Không thể xóa thư mục hiện có: $_"
            Read-Host "Nhấn Enter để thoát"
            exit 1
        }
    }

    # Clone repository
    Write-Install "Đang clone repository cursor-set-id-tools..."
    try {
        git clone https://github.com/minhcopilot/cursor-set-id-tools.git $InstallDir
        Write-Success "Clone repository thành công!"
    } catch {
        Write-Error "Không thể clone repository. Vui lòng kiểm tra kết nối internet."
        Write-Host "Lỗi: $_" -ForegroundColor Red
        Read-Host "Nhấn Enter để thoát"
        exit 1
    }

    # Chuyển đến thư mục cài đặt
    Set-Location $InstallDir

    # Cài đặt Python dependencies
    Write-Install "Đang cài đặt Python dependencies..."
    try {
        pip install -r requirements.txt
        Write-Success "Cài đặt dependencies thành công!"
    } catch {
        Write-Error "Không thể cài đặt dependencies: $_"
        Write-Install "Thử với flag --user..."
        try {
            pip install --user -r requirements.txt
            Write-Success "Cài đặt dependencies thành công với flag --user!"
        } catch {
            Write-Error "Không thể cài đặt dependencies ngay cả với flag --user: $_"
            Read-Host "Nhấn Enter để thoát"
            exit 1
        }
    }

    # Tạo batch file launcher trong thư mục user
    $LauncherDir = Join-Path $env:USERPROFILE "AppData\Local\Microsoft\WindowsApps"
    $LauncherPath = Join-Path $LauncherDir "cursor-set-id-tools.bat"
    
    Write-Install "Đang tạo launcher script..."
    try {
        $BatchContent = @"
@echo off
cd /d "$InstallDir"
python main.py %*
pause
"@
        Set-Content -Path $LauncherPath -Value $BatchContent -Force
        Write-Success "Launcher script đã được tạo tại $LauncherPath"
    } catch {
        Write-Warning "Không thể tạo launcher trong WindowsApps. Tạo trong thư mục cài đặt thay thế."
        $LauncherPath = Join-Path $InstallDir "run.bat"
        $BatchContent = @"
@echo off
cd /d "$InstallDir"
python main.py %*
pause
"@
        Set-Content -Path $LauncherPath -Value $BatchContent -Force
        Write-Success "Launcher script đã được tạo tại $LauncherPath"
    }

    # Tạo desktop shortcut
    try {
        $WshShell = New-Object -comObject WScript.Shell
        $DesktopPath = [System.Environment]::GetFolderPath('Desktop')
        $ShortcutPath = Join-Path $DesktopPath "Cursor Set ID Tools.lnk"
        $Shortcut = $WshShell.CreateShortcut($ShortcutPath)
        $Shortcut.TargetPath = "python"
        $Shortcut.Arguments = "main.py"
        $Shortcut.WorkingDirectory = $InstallDir
        $Shortcut.Description = "Cursor Set ID Tools"
        $Shortcut.Save()
        Write-Success "Desktop shortcut đã được tạo"
    } catch {
        Write-Warning "Không thể tạo desktop shortcut: $_"
    }

    # Cài đặt hoàn tất
    Write-Host ""
    Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║                    Cài Đặt Hoàn Tất!                        ║" -ForegroundColor Green
    Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    Write-Success "Cursor Set ID Tools đã được cài đặt thành công!"
    Write-Host ""
    Write-Info "Cách chạy:"
    Write-Host "  Cách 1: Sử dụng desktop shortcut 'Cursor Set ID Tools'" -ForegroundColor White
    Write-Host "  Cách 2: Chạy 'cursor-set-id-tools' từ command prompt (nếu có)" -ForegroundColor White
    Write-Host "  Cách 3: Điều hướng đến $InstallDir và chạy 'python main.py'" -ForegroundColor White
    Write-Host ""
    Write-Info "Vị trí: $InstallDir"
    Write-Host ""
    Write-Warning "Quan trọng: Hãy đảm bảo đóng ứng dụng Cursor trước khi sử dụng chức năng reset!"
    Write-Host ""
    Write-Host "$ROCKET Sẵn sàng sử dụng! Hãy chạy tool và thưởng thức!" -ForegroundColor Green
    Write-Host ""
    Read-Host "Nhấn Enter để thoát"
}

# Xử lý lỗi
try {
    Install-CursorSetIdTools
} catch {
    Write-Error "Đã xảy ra lỗi không mong muốn: $_"
    Write-Host "Vui lòng thử chạy script này với quyền Administrator" -ForegroundColor Yellow
    Read-Host "Nhấn Enter để thoát"
    exit 1
} 