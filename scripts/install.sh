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
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║              Trình Cài Đặt Cursor Set ID Tools               ║${NC}"
    echo -e "${BLUE}║            Script Cài Đặt Tự Động cho Linux/macOS           ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo

    # Kiểm tra Python 3 đã được cài đặt chưa
    if ! command_exists python3; then
        print_error "Python 3 chưa được cài đặt. Vui lòng cài đặt Python 3 trước."
        echo "Ubuntu/Debian: sudo apt update && sudo apt install python3 python3-pip"
        echo "CentOS/RHEL/Fedora: sudo yum install python3 python3-pip"
        echo "macOS: brew install python3"
        exit 1
    fi

    print_success "Đã tìm thấy Python 3: $(python3 --version)"

    # Kiểm tra pip đã được cài đặt chưa
    if ! command_exists pip3; then
        print_error "pip3 chưa được cài đặt. Vui lòng cài đặt pip3 trước."
        echo "Ubuntu/Debian: sudo apt install python3-pip"
        echo "CentOS/RHEL/Fedora: sudo yum install python3-pip"
        echo "macOS: python3 -m ensurepip --upgrade"
        exit 1
    fi

    print_success "Đã tìm thấy pip3: $(pip3 --version)"

    # Kiểm tra git đã được cài đặt chưa
    if ! command_exists git; then
        print_error "Git chưa được cài đặt. Vui lòng cài đặt Git trước."
        echo "Ubuntu/Debian: sudo apt install git"
        echo "CentOS/RHEL/Fedora: sudo yum install git"
        echo "macOS: brew install git"
        exit 1
    fi

    print_success "Đã tìm thấy Git: $(git --version)"

    # Thiết lập thư mục cài đặt
    INSTALL_DIR="$HOME/cursor-set-id-tools"
    
    print_info "Thư mục cài đặt: $INSTALL_DIR"

    # Xóa thư mục hiện có nếu tồn tại
    if [ -d "$INSTALL_DIR" ]; then
        print_warning "Thư mục $INSTALL_DIR đã tồn tại. Đang xóa..."
        rm -rf "$INSTALL_DIR"
    fi

    # Clone repository
    print_install "Đang clone repository cursor-set-id-tools..."
    if git clone https://github.com/minhcopilot/cursor-set-id-tools.git "$INSTALL_DIR"; then
        print_success "Clone repository thành công!"
    else
        print_error "Không thể clone repository. Vui lòng kiểm tra kết nối internet."
        exit 1
    fi

    # Chuyển đến thư mục cài đặt
    cd "$INSTALL_DIR"

    # Cài đặt Python dependencies
    print_install "Đang cài đặt Python dependencies..."
    if pip3 install -r requirements.txt; then
        print_success "Cài đặt dependencies thành công!"
    else
        print_error "Không thể cài đặt dependencies. Thử với user flag..."
        if pip3 install --user -r requirements.txt; then
            print_success "Cài đặt dependencies thành công với user flag!"
        else
            print_error "Không thể cài đặt dependencies ngay cả với user flag."
            exit 1
        fi
    fi

    # Tạo launcher script đơn giản
    LAUNCHER_SCRIPT="$HOME/.local/bin/cursor-set-id-tools"
    
    # Tạo thư mục .local/bin nếu chưa tồn tại
    mkdir -p "$HOME/.local/bin"
    
    print_install "Đang tạo launcher script..."
    cat > "$LAUNCHER_SCRIPT" << EOF
#!/bin/bash
cd "$INSTALL_DIR"
python3 main.py "\$@"
EOF

    chmod +x "$LAUNCHER_SCRIPT"
    print_success "Launcher script đã được tạo tại $LAUNCHER_SCRIPT"

    # Thêm vào PATH nếu chưa có
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
        print_info "Đã thêm $HOME/.local/bin vào PATH trong .bashrc"
        print_warning "Vui lòng chạy 'source ~/.bashrc' hoặc khởi động lại terminal để sử dụng lệnh 'cursor-set-id-tools'"
    fi

    echo
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                    Cài Đặt Hoàn Tất!                        ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo
    print_success "Cursor Set ID Tools đã được cài đặt thành công!"
    echo
    print_info "Cách chạy:"
    echo "  Cách 1: cursor-set-id-tools (nếu PATH đã được cập nhật)"
    echo "  Cách 2: cd $INSTALL_DIR && python3 main.py"
    echo
    print_info "Vị trí: $INSTALL_DIR"
    echo
    print_warning "Quan trọng: Hãy đảm bảo đóng ứng dụng Cursor trước khi sử dụng chức năng reset!"
    echo
    echo -e "${ROCKET} ${GREEN}Sẵn sàng sử dụng! Hãy chạy tool và thưởng thức!${NC}"
}

# Chạy hàm main
main "$@" 