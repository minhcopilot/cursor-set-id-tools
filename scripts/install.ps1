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
$EMOJI_SUCCESS = "✅"
$EMOJI_ERROR = "❌"
$EMOJI_INFO = "ℹ️"
$EMOJI_INSTALL = "📦"
$EMOJI_ROCKET = "🚀"
$EMOJI_WARNING = "⚠️"

# Hàm in output có màu
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
    Show-Info "Bắt đầu cài đặt Cursor Set ID Tools..."

    # Kiểm tra Python đã được cài đặt chưa
    if (-not (Test-Command "python")) {
        Show-Error "Python chưa được cài đặt. Vui lòng cài đặt Python 3.7+ từ https://www.python.org/downloads/"
        Read-Host "Nhấn Enter để thoát"
        exit 1
    }

    # Kiểm tra pip có sẵn không
    if (-not (Test-Command "pip")) {
        Show-Error "pip chưa được cài đặt. Vui lòng cài đặt lại Python với pip đi kèm"
        Read-Host "Nhấn Enter để thoát"
        exit 1
    }

    # Kiểm tra git đã được cài đặt chưa
    if (-not (Test-Command "git")) {
        Show-Error "Git chưa được cài đặt. Vui lòng cài đặt Git từ https://git-scm.com/download/win"
        Read-Host "Nhấn Enter để thoát"
        exit 1
    }

    # Thiết lập thư mục cài đặt
    $InstallDir = Join-Path $env:USERPROFILE "cursor-set-id-tools"

    # Xóa thư mục hiện có nếu tồn tại
    if (Test-Path $InstallDir) {
        try {
            Remove-Item -Path $InstallDir -Recurse -Force
        } catch {
            Show-Error "Không thể xóa thư mục hiện có: $_"
            Read-Host "Nhấn Enter để thoát"
            exit 1
        }
    }

    # Clone repository
    Show-Install "Đang tải xuống..."
    try {
        git clone https://github.com/minhcopilot/cursor-set-id-tools.git $InstallDir 2>$null
    } catch {
        Show-Error "Không thể tải xuống. Vui lòng kiểm tra kết nối internet."
        Read-Host "Nhấn Enter để thoát"
        exit 1
    }

    # Chuyển đến thư mục cài đặt
    Set-Location $InstallDir

    # Cài đặt Python dependencies
    Show-Install "Đang cài đặt..."
    try {
        pip install -r requirements.txt --quiet
    } catch {
        try {
            pip install --user -r requirements.txt --quiet
        } catch {
            Show-Error "Không thể cài đặt dependencies."
            Read-Host "Nhấn Enter để thoát"
            exit 1
        }
    }

    Show-Success "Cài đặt hoàn tất!"
    
    # Tự động chạy tool
    Show-Install "Đang khởi động tool..."
    try {
        Set-Location $InstallDir
        python main.py
    } catch {
        Show-Warning "Không thể tự động chạy. Hãy vào thư mục $InstallDir và chạy 'python main.py'"
        Read-Host "Nhấn Enter để thoát"
    }
}

# Chạy cài đặt
try {
    Install-CursorSetIdTools
} catch {
    Show-Error "Lỗi: $_"
    exit 1
} 