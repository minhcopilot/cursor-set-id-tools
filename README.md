# Cursor Reset ID Tools

## 🔧 Chức năng

### ❌ Close Cursor Application (Đóng ứng dụng Cursor)
- Đóng tất cả các tiến trình Cursor một cách an toàn
- Sử dụng `psutil` để detect và terminate processes
- Có timeout mechanism để đảm bảo tiến trình được đóng

### 🔄 Reset Machine ID (Reset Machine ID)
- Reset machine ID của Cursor để bypass limitations
- Tạo backup file gốc trước khi thay đổi
- Hỗ trợ Windows, macOS và Linux
- Tự động generate machine ID mới

### ❌ Exit Program (Thoát chương trình)
- Thoát khỏi tool một cách an toàn
- Hỗ trợ Ctrl+C để force exit

## 📦 Cài đặt

### ⭐ Auto Run Script (Khuyến nghị)

Auto script sẽ tự động:
- ✅ Kiểm tra và cài đặt các dependencies cần thiết
- ✅ Clone repository từ GitHub
- ✅ Cài đặt Python packages
- ✅ Tạo launcher script để chạy dễ dàng
- ✅ Tạo desktop shortcut (Windows)

**Linux/macOS:**
```bash
curl -fsSL https://raw.githubusercontent.com/minhcopilot/cursor-set-id-tools/refs/heads/main/scripts/install.sh -o install.sh && chmod +x install.sh && ./install.sh
```

**Windows:**
```powershell
irm https://raw.githubusercontent.com/minhcopilot/cursor-set-id-tools/refs/heads/main/scripts/install.ps1 | iex
```

> **✨ Tính năng mới:** Script cài đặt đã được cập nhật để **TỰ ĐỘNG CÀI ĐẶT** Python, pip và Git nếu chưa có trên cả **Windows, Linux và macOS**! Bạn chỉ cần chạy lệnh trên và script sẽ lo tất cả.
>
> - **Windows**: Tự động cài Python 3.12 và Git qua winget hoặc tải installer
> - **macOS**: Tự động cài Homebrew (nếu chưa có), sau đó cài Python3 và Git
> - **Linux**: Tự động phát hiện distro (Ubuntu/Debian/Fedora/CentOS/Arch) và dùng package manager phù hợp

### 📖 Cài đặt thủ công

#### Bước 1: Clone repository
```bash
git clone https://github.com/minhcopilot/cursor-set-id-tools.git
cd cursor-set-id-tools
```

#### Bước 2: Cài đặt Python Dependencies
```bash
pip install -r requirements.txt
```

#### Bước 3: Chạy tool
```bash
python main.py
```

## 🖥️ Hệ điều hành hỗ trợ

- ✅ Windows 10/11
- ✅ macOS
- ✅ Linux (Ubuntu, Debian, Fedora, etc.)

## ⚙️ Cấu hình

Tool sẽ tự động tạo file cấu hình tại:
- **Windows**: `%USERPROFILE%\Documents\.cursor-free-vip\config.ini`
- **macOS/Linux**: `~/Documents/.cursor-free-vip/config.ini`

## 🔒 Quyền Admin

Một số chức năng có thể yêu cầu quyền Administrator:
- **Windows**: Chạy với "Run as Administrator"
- **Linux/macOS**: Sử dụng `sudo python main.py`

## 📁 Cấu trúc file

```
cursor-set-id-tools/
├── main.py              # File chính
├── quit_cursor.py       # Chức năng đóng Cursor
├── reset_machine_manual.py # Chức năng reset Machine ID
├── config.py            # Quản lý cấu hình
├── utils.py             # Các hàm tiện ích
├── logo.py              # Hiển thị logo
├── scripts/             # Script cài đặt tự động
│   ├── install.sh       # Auto install cho Linux/macOS
│   └── install.ps1      # Auto install cho Windows
├── locales/             # File dịch ngôn ngữ
│   ├── en.json
│   ├── vi.json
│   └── ...
├── requirements.txt     # Python dependencies
└── README.md           # Hướng dẫn này
```

## 🚨 Lưu ý quan trọng

1. **Backup**: Tool sẽ tự động tạo backup trước khi thay đổi Machine ID
2. **Cursor phải được đóng**: Đóng Cursor trước khi reset Machine ID
3. **Quyền hệ thống**: Một số thao tác cần quyền Administrator
4. **Sử dụng cẩn thận**: Chỉ sử dụng với Cursor của bạn

## 🔧 Troubleshooting

### ❌ Lỗi "Python chưa được cài đặt" hoặc "Git chưa được cài đặt"

#### **Giải pháp tự động (Windows):**
Script `install.ps1` đã được cập nhật để **tự động cài đặt** Python và Git nếu chưa có. Chỉ cần chạy:
```powershell
irm https://raw.githubusercontent.com/minhcopilot/cursor-set-id-tools/refs/heads/main/scripts/install.ps1 | iex
```

#### **Giải pháp tự động (Linux/macOS):**
Script `install.sh` cũng đã được cập nhật để **tự động cài đặt**. Chỉ cần chạy:
```bash
curl -fsSL https://raw.githubusercontent.com/minhcopilot/cursor-set-id-tools/refs/heads/main/scripts/install.sh -o install.sh && chmod +x install.sh && ./install.sh
```

Script sẽ tự động:
1. ✅ Phát hiện hệ điều hành và distro
2. ✅ Kiểm tra Python3, nếu chưa có → cài đặt tự động
3. ✅ Kiểm tra Git, nếu chưa có → cài đặt tự động
4. ✅ Kiểm tra và kích hoạt pip
5. ✅ Cài đặt tất cả thư viện Python cần thiết
6. ✅ Tự động chạy tool

**Hỗ trợ các distro Linux:**
- Ubuntu/Debian (dùng `apt`)
- Fedora (dùng `dnf`)
- CentOS/RHEL (dùng `yum`)
- Arch/Manjaro (dùng `pacman`)

**macOS:**
- Tự động cài Homebrew nếu chưa có
- Tự động cài Python3 và Git qua Homebrew

**Giải pháp thủ công:**
- **Windows**: Python từ [python.org](https://www.python.org/downloads/), Git từ [git-scm.com](https://git-scm.com/download/win)
- **macOS**: `brew install python3 git`
- **Ubuntu/Debian**: `sudo apt install python3 python3-pip git`
- **Fedora**: `sudo dnf install python3 python3-pip git`
- **Arch**: `sudo pacman -S python python-pip git`

### ❌ Lỗi "pip chưa được cài đặt"

Script đã được cập nhật để tự động khắc phục:
- Tự động chạy `python -m ensurepip` để kích hoạt pip
- Nếu vẫn lỗi, hãy cài đặt lại Python và chọn tích "Include pip"

### ❌ Lỗi "Permission Denied"
- Chạy với quyền Administrator (Windows) hoặc sudo (Linux/macOS)

### ❌ Lỗi "Cursor not found"
- Kiểm tra xem Cursor đã được cài đặt chưa
- Cập nhật đường dẫn trong config file nếu cần

### ⚠️ Script không chạy được trên Windows

Nếu gặp lỗi "running scripts is disabled on this system":
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Sau đó chạy lại lệnh cài đặt:
```powershell
irm https://raw.githubusercontent.com/minhcopilot/cursor-set-id-tools/refs/heads/main/scripts/install.ps1 | iex
```

### 🔄 Sau khi cài đặt Python/Git, script vẫn báo lỗi

**Windows:** Hãy **khởi động lại PowerShell** hoặc **mở PowerShell mới** và chạy lại lệnh cài đặt. Điều này để PATH được cập nhật.

**Linux/macOS:** Hãy **khởi động lại Terminal** hoặc chạy `source ~/.bashrc` (hoặc `source ~/.zshrc` nếu dùng zsh).

### ⚠️ Lỗi "sudo: command not found" hoặc không có quyền sudo (Linux)

Nếu script yêu cầu sudo để cài đặt nhưng bạn không có quyền:

**Cách 1:** Liên hệ admin hệ thống để cài đặt Python3, pip và Git
**Cách 2:** Cài đặt Python trong user space (không cần sudo):
```bash
# Dùng pyenv để cài Python không cần sudo
curl https://pyenv.run | bash
pyenv install 3.12.0
pyenv global 3.12.0
```

### 🍎 Lỗi trên macOS: "xcrun: error: invalid active developer path"

Chạy lệnh này để cài đặt Xcode Command Line Tools:
```bash
xcode-select --install
```

Sau đó chạy lại script cài đặt.
