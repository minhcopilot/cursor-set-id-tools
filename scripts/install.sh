#!/bin/bash

# Cursor Set ID Tools - Script Cài Đặt Tự Động cho Linux/macOS
# Tác giả: minhcopilot
# Repository: https://github.com/minhcopilot/cursor-set-id-tools

set -e  # Thoát khi có lỗi

# Màu sắc cho output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Không màu

# Biểu tượng
SUCCESS="✅"
ERROR="❌"
INFO="ℹ️"
INSTALL="📦"
ROCKET="🚀"

# Hàm in output có màu
print_info() {
    echo -e "${BLUE}${INFO} $1${NC}"
}

print_success() {
    echo -e "${GREEN}${SUCCESS} $1${NC}"
}

print_error() {
    echo -e "${RED}${ERROR} $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_install() {
    echo -e "${YELLOW}${INSTALL} $1${NC}"
}

# Hàm kiểm tra lệnh có tồn tại không
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Hàm cài đặt chính
main() {
    print_info "Bắt đầu cài đặt Cursor Set ID Tools..."

    # Kiểm tra Python 3 đã được cài đặt chưa
    if ! command_exists python3; then
        print_error "Python 3 chưa được cài đặt. Vui lòng cài đặt Python 3 trước."
        echo "Ubuntu/Debian: sudo apt update && sudo apt install python3 python3-pip"
        echo "CentOS/RHEL/Fedora: sudo yum install python3 python3-pip"
        echo "macOS: brew install python3"
        exit 1
    fi

    # Kiểm tra pip đã được cài đặt chưa
    if ! command_exists pip3; then
        print_error "pip3 chưa được cài đặt. Vui lòng cài đặt pip3 trước."
        echo "Ubuntu/Debian: sudo apt install python3-pip"
        echo "CentOS/RHEL/Fedora: sudo yum install python3-pip"
        echo "macOS: python3 -m ensurepip --upgrade"
        exit 1
    fi

    # Kiểm tra git đã được cài đặt chưa
    if ! command_exists git; then
        print_error "Git chưa được cài đặt. Vui lòng cài đặt Git trước."
        echo "Ubuntu/Debian: sudo apt install git"
        echo "CentOS/RHEL/Fedora: sudo yum install git"
        echo "macOS: brew install git"
        exit 1
    fi

    # Thiết lập thư mục cài đặt
    INSTALL_DIR="$HOME/cursor-set-id-tools"

    # Xóa thư mục hiện có nếu tồn tại
    if [ -d "$INSTALL_DIR" ]; then
        rm -rf "$INSTALL_DIR"
    fi

    # Clone repository
    print_install "Đang tải xuống..."
    if git clone https://github.com/minhcopilot/cursor-set-id-tools.git "$INSTALL_DIR" &>/dev/null; then
        :
    else
        print_error "Không thể tải xuống. Vui lòng kiểm tra kết nối internet."
        exit 1
    fi

    # Chuyển đến thư mục cài đặt
    cd "$INSTALL_DIR"

    # Cài đặt Python dependencies
    print_install "Đang cài đặt..."
    if pip3 install -r requirements.txt --quiet; then
        :
    else
        if pip3 install --user -r requirements.txt --quiet; then
            :
        else
            print_error "Không thể cài đặt dependencies."
            exit 1
        fi
    fi

    print_success "Cài đặt hoàn tất!"
    
    # Tự động chạy tool
    print_install "Đang khởi động tool..."
    if cd "$INSTALL_DIR" && python3 main.py; then
        :
    else
        print_warning "Không thể tự động chạy. Hãy vào thư mục $INSTALL_DIR và chạy 'python3 main.py'"
    fi
}

# Chạy cài đặt
main 