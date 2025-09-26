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

> **Lưu ý:** Bạn cần cài đặt Python 3.7+, pip và Git trước khi chạy auto script.

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

## 🌍 Ngôn ngữ hỗ trợ

Tool hỗ trợ đa ngôn ngữ với hệ thống translation tự động:
- 🇺🇸 English
- 🇻🇳 Tiếng Việt  
- 🇨🇳 中文 (简体)
- 🇹🇼 中文 (繁體)
- 🇯🇵 日本語
- 🇩🇪 Deutsch
- 🇫🇷 Français
- 🇪🇸 Español
- 🇮🇹 Italiano
- 🇷🇺 Русский
- 🇸🇦 العربية
- 🇹🇷 Türkçe
- 🇳🇱 Nederlands
- 🇧🇬 Български
- 🇵🇹 Português

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

### Lỗi "Permission Denied"
- Chạy với quyền Administrator (Windows) hoặc sudo (Linux/macOS)

### Lỗi "Cursor not found"
- Kiểm tra xem Cursor đã được cài đặt chưa
- Cập nhật đường dẫn trong config file nếu cần

### Lỗi Dependencies
```bash
pip install --upgrade pip
pip install -r requirements.txt
```

## 📄 License

Dựa trên dự án Cursor Free VIP gốc. 