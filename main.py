#!/usr/bin/env python3
# Cursor Standalone Tools - Chỉ chứa 3 chức năng chính
# 1. ❌ Close Cursor Application
# 2. 🔄 Reset Machine ID  
# 3. ❌ Exit Program

import os
import sys
import json
from logo import print_logo
from colorama import Fore, Style, init
import locale
import platform
from config import get_config, force_update_config
import shutil
from utils import get_user_documents_path

# Add these imports for Arabic support
try:
    import arabic_reshaper
    from bidi.algorithm import get_display
except ImportError:
    arabic_reshaper = None
    get_display = None

# Initialize colorama
init()

# Define emoji and color constants
EMOJI = {
    "SUCCESS": "✅",
    "ERROR": "❌",
    "INFO": "ℹ️",
    "RESET": "🔄",
    "MENU": "📋",
    "ARROW": "➜",
    "ADMIN": "🔐",
}

class Translator:
    def __init__(self):
        self.translations = {}
        self.config = get_config()
        
        # Create language cache directory if it doesn't exist
        if self.config and self.config.has_section('Language'):
            self.language_cache_dir = self.config.get('Language', 'language_cache_dir')
            os.makedirs(self.language_cache_dir, exist_ok=True)
        else:
            self.language_cache_dir = None
        
        # Set fallback language from config if available
        self.fallback_language = 'vi'  # Changed to Vietnamese
        if self.config and self.config.has_section('Language') and self.config.has_option('Language', 'fallback_language'):
            self.fallback_language = self.config.get('Language', 'fallback_language')
        
        # Load saved language from config if available, otherwise detect system language
        if self.config and self.config.has_section('Language') and self.config.has_option('Language', 'current_language'):
            saved_language = self.config.get('Language', 'current_language')
            if saved_language and saved_language.strip():
                self.current_language = saved_language
            else:
                self.current_language = self.detect_system_language()
                # Save detected language to config
                if self.config.has_section('Language'):
                    self.config.set('Language', 'current_language', self.current_language)
                    config_dir = os.path.join(get_user_documents_path(), ".cursor-free-vip")
                    config_file = os.path.join(config_dir, "config.ini")
                    with open(config_file, 'w', encoding='utf-8') as f:
                        self.config.write(f)
        else:
            self.current_language = self.detect_system_language()
        
        self.load_translations()
    
    def detect_system_language(self):
        """Always return Vietnamese as default language"""
        # Force Vietnamese as default language
        return 'vi'
            
    def load_translations(self):
        """Load all available translations from the integrated package"""
        try:
            locales_dir = os.path.join(os.path.dirname(__file__), 'locales')
            if os.path.exists(locales_dir):
                for filename in os.listdir(locales_dir):
                    if filename.endswith('.json'):
                        lang_code = filename[:-5]  # Remove .json extension
                        filepath = os.path.join(locales_dir, filename)
                        try:
                            with open(filepath, 'r', encoding='utf-8') as f:
                                self.translations[lang_code] = json.load(f)
                        except Exception:
                            continue
            
            # Create at least minimal Vietnamese translations for basic functionality
            if 'vi' not in self.translations:
                self.translations['vi'] = {
                    "menu": {
                        "title": "Cursor Standalone Tools",
                        "exit": "Thoát Chương Trình",
                        "quit": "Đóng Ứng Dụng Cursor", 
                        "reset": "Đặt Lại ID Máy",
                        "input_choice": "Vui lòng nhập lựa chọn của bạn ({choices})",
                        "invalid_choice": "Lựa chọn không hợp lệ. Vui lòng nhập một số từ {choices}",
                        "program_terminated": "Chương trình đã bị người dùng chấm dứt"
                    }
                }
        except Exception:
            # Create at least minimal Vietnamese translations for basic functionality
            self.translations['vi'] = {"menu": {"title": "Menu", "exit": "Thoát", "invalid_choice": "Lựa chọn không hợp lệ"}}
    
    def fix_arabic(self, text):
        if self.current_language == 'ar' and arabic_reshaper and get_display:
            try:
                reshaped_text = arabic_reshaper.reshape(text)
                bidi_text = get_display(reshaped_text)
                return bidi_text
            except Exception:
                return text
        return text

    def get(self, key, **kwargs):
        """Get translated text with fallback support"""
        try:
            # Try current language
            result = self._get_translation(self.current_language, key)
            if result == key and self.current_language != self.fallback_language:
                # Try fallback language if translation not found
                result = self._get_translation(self.fallback_language, key)
            formatted = result.format(**kwargs) if kwargs else result
            return self.fix_arabic(formatted)
        except Exception:
            return key
    
    def _get_translation(self, lang_code, key):
        """Get translation for a specific language"""
        try:
            keys = key.split('.')
            value = self.translations.get(lang_code, {})
            for k in keys:
                if isinstance(value, dict):
                    value = value.get(k, key)
                else:
                    return key
            return value
        except Exception:
            return key

# Create translator instance
translator = Translator()

def print_menu():
    """Print menu options"""
    print(f"\n{Fore.CYAN}{EMOJI['MENU']} {translator.get('menu.title')}:{Style.RESET_ALL}")
    print(f"{Fore.YELLOW}{'─' * 50}{Style.RESET_ALL}")
    
    # Define simplified menu items
    menu_items = [
        f"{Fore.GREEN}0{Style.RESET_ALL}. {EMOJI['ERROR']} {translator.get('menu.exit')}",
        f"{Fore.GREEN}1{Style.RESET_ALL}. {EMOJI['RESET']} {translator.get('menu.reset')}",
        f"{Fore.GREEN}2{Style.RESET_ALL}. {EMOJI['ERROR']} {translator.get('menu.quit')}",
    ]
    
    # Print menu items
    for item in menu_items:
        print(f"  {item}")
    
    print(f"{Fore.YELLOW}{'─' * 50}{Style.RESET_ALL}")

def main():
    """Main function - Standalone version with 3 functions only"""
    print_logo()
    
    # Initialize configuration
    config = get_config(translator)
    if not config:
        print(f"{Fore.RED}{EMOJI['ERROR']} {translator.get('menu.config_init_failed', fallback='Không thể khởi tạo cấu hình')}{Style.RESET_ALL}")
        return
    
    print_menu()
    
    while True:
        try:
            choice_num = 2
            choice = input(f"\n{EMOJI['ARROW']} {Fore.CYAN}{translator.get('menu.input_choice', choices=f'0-{choice_num}')}: {Style.RESET_ALL}")

            match choice:
                case "0":
                    # Exit Program
                    print(f"\n{Fore.YELLOW}{EMOJI['INFO']} {translator.get('menu.exit')}...{Style.RESET_ALL}")
                    print(f"{Fore.CYAN}{'═' * 50}{Style.RESET_ALL}")
                    return
                    
                case "1":
                    # Reset Machine ID
                    import reset_machine_manual
                    reset_machine_manual.run(translator)
                    print_menu()
                    
                case "2":
                    # Close Cursor Application
                    import quit_cursor
                    quit_cursor.quit_cursor(translator)
                    print_menu()
                    
                case _:
                    print(f"{Fore.RED}{EMOJI['ERROR']} {translator.get('menu.invalid_choice', choices=f'0-{choice_num}')}{Style.RESET_ALL}")
                    print_menu()

        except KeyboardInterrupt:
            print(f"\n{Fore.YELLOW}{EMOJI['INFO']} {translator.get('menu.program_terminated')}{Style.RESET_ALL}")
            print(f"{Fore.CYAN}{'═' * 50}{Style.RESET_ALL}")
            return
        except Exception as e:
            print(f"{Fore.RED}{EMOJI['ERROR']} Đã xảy ra lỗi: {str(e)}{Style.RESET_ALL}")
            continue

if __name__ == "__main__":
    main() 