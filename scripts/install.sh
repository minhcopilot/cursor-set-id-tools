#!/bin/bash

# Cursor Set ID Tools - Auto Install Script for Linux/macOS
# Author: minhcopilot
# Repository: https://github.com/minhcopilot/cursor-set-id-tools

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Symbols
SUCCESS="[+]"
ERROR="[X]"
INFO="[i]"
INSTALL="[*]"
WARNING="[!]"

# Function to print colored output
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
    echo -e "${YELLOW}${WARNING} $1${NC}"
}

print_install() {
    echo -e "${CYAN}${INSTALL} $1${NC}"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            OS=$ID
        else
            OS="linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    else
        OS="unknown"
    fi
}

# Function to install Python on Linux
install_python_linux() {
    print_warning "Python3 chua duoc cai dat. Dang tien hanh cai dat tu dong..."
    
    case $OS in
        ubuntu|debian)
            print_install "Dang cai dat Python3 qua apt..."
            sudo apt update -qq
            sudo apt install -y python3 python3-pip python3-venv
            ;;
        fedora)
            print_install "Dang cai dat Python3 qua dnf..."
            sudo dnf install -y python3 python3-pip
            ;;
        centos|rhel)
            print_install "Dang cai dat Python3 qua yum..."
            sudo yum install -y python3 python3-pip
            ;;
        arch|manjaro)
            print_install "Dang cai dat Python3 qua pacman..."
            sudo pacman -S --noconfirm python python-pip
            ;;
        *)
            print_error "Khong ho tro tu dong cai dat tren $OS"
            print_info "Vui long cai dat Python3 thu cong:"
            echo "  Ubuntu/Debian: sudo apt install python3 python3-pip"
            echo "  Fedora: sudo dnf install python3 python3-pip"
            echo "  CentOS/RHEL: sudo yum install python3 python3-pip"
            echo "  Arch: sudo pacman -S python python-pip"
            exit 1
            ;;
    esac
    
    print_success "Python3 da duoc cai dat thanh cong!"
}

# Function to install Python on macOS
install_python_macos() {
    print_warning "Python3 chua duoc cai dat. Dang tien hanh cai dat tu dong..."
    
    # Check if Homebrew is installed
    if ! command_exists brew; then
        print_install "Dang cai dat Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH
        if [[ $(uname -m) == 'arm64' ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi
    
    print_install "Dang cai dat Python3 qua Homebrew..."
    brew install python3
    
    print_success "Python3 da duoc cai dat thanh cong!"
}

# Function to install Git on Linux
install_git_linux() {
    print_warning "Git chua duoc cai dat. Dang tien hanh cai dat tu dong..."
    
    case $OS in
        ubuntu|debian)
            print_install "Dang cai dat Git qua apt..."
            sudo apt update -qq
            sudo apt install -y git
            ;;
        fedora)
            print_install "Dang cai dat Git qua dnf..."
            sudo dnf install -y git
            ;;
        centos|rhel)
            print_install "Dang cai dat Git qua yum..."
            sudo yum install -y git
            ;;
        arch|manjaro)
            print_install "Dang cai dat Git qua pacman..."
            sudo pacman -S --noconfirm git
            ;;
        *)
            print_error "Khong ho tro tu dong cai dat tren $OS"
            print_info "Vui long cai dat Git thu cong"
            exit 1
            ;;
    esac
    
    print_success "Git da duoc cai dat thanh cong!"
}

# Function to install Git on macOS
install_git_macos() {
    print_warning "Git chua duoc cai dat. Dang tien hanh cai dat tu dong..."
    
    # Check if Homebrew is installed
    if ! command_exists brew; then
        print_install "Dang cai dat Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH
        if [[ $(uname -m) == 'arm64' ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi
    
    print_install "Dang cai dat Git qua Homebrew..."
    brew install git
    
    print_success "Git da duoc cai dat thanh cong!"
}

# Function to install pip
install_pip() {
    print_warning "pip chua san sang, dang thu khac phuc..."
    
    if command_exists python3; then
        python3 -m ensurepip --default-pip --user 2>/dev/null || true
        python3 -m pip install --upgrade pip --user --quiet 2>/dev/null || true
        print_success "pip da duoc kich hoat!"
    else
        print_error "Khong the cai dat pip vi Python3 chua co"
        exit 1
    fi
}

# Banner
show_banner() {
    echo ""
    echo "============================================================="
    echo "                                                             "
    echo "         CURSOR SET ID TOOLS - AUTO INSTALLER                "
    echo "                                                             "
    echo "      Tool tu dong cai dat tat ca dependencies               "
    echo "           bao gom Python, Git va pip!                       "
    echo "                                                             "
    echo "============================================================="
    echo ""
}

# Main installation function
main() {
    show_banner
    
    print_info "Bat dau cai dat Cursor Set ID Tools..."
    
    # Detect OS
    detect_os
    print_info "Phat hien he dieu hanh: $OS"
    
    # Check and install Python3 if needed
    if ! command_exists python3; then
        if [ "$OS" = "macos" ]; then
            install_python_macos
        else
            install_python_linux
        fi
        
        # Check again after installation
        if ! command_exists python3; then
            print_error "Python3 van chua san sang. Vui long khoi dong lai terminal va thu lai."
            exit 1
        fi
    else
        print_success "Python3 da duoc cai dat san"
    fi
    
    # Check pip
    if ! command_exists pip3 && ! python3 -m pip --version &>/dev/null; then
        install_pip
        
        # Check again
        if ! command_exists pip3 && ! python3 -m pip --version &>/dev/null; then
            print_error "pip van chua san sang"
            exit 1
        fi
    else
        print_success "pip da duoc cai dat san"
    fi
    
    # Check and install Git if needed
    if ! command_exists git; then
        if [ "$OS" = "macos" ]; then
            install_git_macos
        else
            install_git_linux
        fi
        
        # Check again after installation
        if ! command_exists git; then
            print_error "Git van chua san sang. Vui long khoi dong lai terminal va thu lai."
            exit 1
        fi
    else
        print_success "Git da duoc cai dat san"
    fi
    
    # Setup installation directory
    INSTALL_DIR="$HOME/cursor-set-id-tools"
    
    # Remove existing directory if exists
    if [ -d "$INSTALL_DIR" ]; then
        rm -rf "$INSTALL_DIR"
    fi
    
    # Clone repository
    print_install "Dang tai xuong..."
    if git clone https://github.com/minhcopilot/cursor-set-id-tools.git "$INSTALL_DIR" 2>/dev/null; then
        print_success "Tai xuong thanh cong!"
    else
        print_error "Khong the tai xuong. Vui long kiem tra ket noi internet."
        exit 1
    fi
    
    # Change to installation directory
    cd "$INSTALL_DIR"
    
    # Install Python dependencies
    print_install "Dang cai dat cac thu vien Python can thiet..."
    
    # Try with pip3 first
    if command_exists pip3; then
        PIP_CMD="pip3"
    else
        PIP_CMD="python3 -m pip"
    fi
    
    # Try to upgrade pip
    $PIP_CMD install --upgrade pip --quiet --user 2>/dev/null || true
    
    # Install requirements with retries and better error handling
    retry_count=0
    max_retries=3
    success=false
    
    while [ $retry_count -lt $max_retries ] && [ "$success" = false ]; do
        # Remove --quiet to see actual errors
        if $PIP_CMD install -r requirements.txt --no-cache-dir 2>&1; then
            success=true
            print_success "Da cai dat tat ca thu vien thanh cong!"
        else
            retry_count=$((retry_count + 1))
            if [ $retry_count -lt $max_retries ]; then
                print_warning "Thu lai lan $retry_count..."
                sleep 2
            else
                print_warning "Gap loi khi cai dat, thu voi quyen user..."
            fi
        fi
    done
    
    if [ "$success" = false ]; then
        print_warning "Thu cai dat voi quyen user..."
        if $PIP_CMD install --user -r requirements.txt --no-cache-dir 2>&1; then
            print_success "Da cai dat tat ca thu vien thanh cong!"
            success=true
        fi
    fi
    
    if [ "$success" = false ]; then
        print_error "Khong the cai dat dependencies"
        print_info "Ban co the thu cai dat thu cong: cd $INSTALL_DIR && pip3 install -r requirements.txt"
        exit 1
    fi
    
    print_success "Cai dat hoan tat!"
    
    # Auto run tool
    print_install "Dang khoi dong tool..."
    if cd "$INSTALL_DIR" && python3 main.py; then
        :
    else
        print_warning "Khong the tu dong chay. Hay vao thu muc $INSTALL_DIR va chay 'python3 main.py'"
    fi
}

# Run installation
main
