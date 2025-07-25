#!/bin/bash

# Configuration Validation Script for pvtest
# 配置文件验证脚本

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=== pvtest 项目配置验证 ==="
echo "=== pvtest Project Configuration Validation ==="
echo

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    local status=$1
    local message=$2
    case $status in
        "OK")
            echo -e "${GREEN}[✓] $message${NC}"
            ;;
        "WARN")
            echo -e "${YELLOW}[!] $message${NC}"
            ;;
        "ERROR")
            echo -e "${RED}[✗] $message${NC}"
            ;;
        "INFO")
            echo -e "${BLUE}[i] $message${NC}"
            ;;
    esac
}

# Check if running in project root
if [[ ! -f "$PROJECT_ROOT/common.seed" ]]; then
    print_status "ERROR" "请在项目根目录运行此脚本 / Please run this script from project root"
    exit 1
fi

print_status "INFO" "项目根目录: $PROJECT_ROOT"
print_status "INFO" "Project root: $PROJECT_ROOT"
echo

# 1. Check GitHub Actions workflow files
print_status "INFO" "检查 GitHub Actions 工作流文件..."
print_status "INFO" "Checking GitHub Actions workflow files..."

workflow_files=(
    ".github/workflows/dispatch.yml"
    ".github/workflows/lo-test.yml"  
    ".github/workflows/mi-test.yml"
    ".github/workflows/tn.yml"
)

for file in "${workflow_files[@]}"; do
    if [[ -f "$PROJECT_ROOT/$file" ]]; then
        if python3 -c "import yaml; yaml.safe_load(open('$PROJECT_ROOT/$file'))" 2>/dev/null; then
            print_status "OK" "$file YAML 语法正确"
        else
            print_status "ERROR" "$file YAML 语法错误"
        fi
    else
        print_status "WARN" "$file 文件不存在"
    fi
done

echo

# 2. Check configuration seed files
print_status "INFO" "检查设备配置文件..."
print_status "INFO" "Checking device configuration files..."

# Get list of all .config.seed files
config_files=($(find "$PROJECT_ROOT" -maxdepth 1 -name "*.config.seed" -type f))

if [[ ${#config_files[@]} -eq 0 ]]; then
    print_status "WARN" "未找到设备配置文件 (.config.seed)"
else
    for config_file in "${config_files[@]}"; do
        filename=$(basename "$config_file")
        device_name="${filename%.config.seed}"
        
        # Basic syntax check
        if grep -q "CONFIG_TARGET" "$config_file" 2>/dev/null; then
            print_status "OK" "$filename - 包含 TARGET 配置"
        else
            print_status "WARN" "$filename - 缺少 TARGET 配置"
        fi
        
        # Check for device-specific settings
        if grep -q "CONFIG_TARGET.*DEVICE" "$config_file" 2>/dev/null; then
            print_status "OK" "$filename - 包含设备特定配置"
        else
            print_status "WARN" "$filename - 可能缺少设备特定配置"
        fi
    done
fi

echo

# 3. Check common configuration
print_status "INFO" "检查公共配置文件..."
print_status "INFO" "Checking common configuration..."

if [[ -f "$PROJECT_ROOT/common.seed" ]]; then
    luci_apps=$(grep -c "CONFIG_PACKAGE_luci-app" "$PROJECT_ROOT/common.seed" 2>/dev/null || echo "0")
    total_packages=$(grep -c "CONFIG_PACKAGE" "$PROJECT_ROOT/common.seed" 2>/dev/null || echo "0")
    
    print_status "OK" "common.seed 存在"
    print_status "INFO" "LuCI 应用数量: $luci_apps"
    print_status "INFO" "总软件包数量: $total_packages"
    
    if [[ $luci_apps -gt 0 ]]; then
        print_status "OK" "包含 LuCI 应用配置"
    else
        print_status "WARN" "未找到 LuCI 应用配置"
    fi
else
    print_status "ERROR" "common.seed 文件不存在"
fi

echo

# 4. Check script files
print_status "INFO" "检查脚本文件..."
print_status "INFO" "Checking script files..."

script_files=(
    "scripts/merge_packages.sh"
    "scripts/merge_files.sh"
    "scripts/patches.sh"
    "scripts/autoupdate-bash.sh"
)

for script in "${script_files[@]}"; do
    if [[ -f "$PROJECT_ROOT/$script" ]]; then
        if bash -n "$PROJECT_ROOT/$script" 2>/dev/null; then
            print_status "OK" "$script 语法正确"
        else
            print_status "ERROR" "$script 语法错误"
        fi
        
        # Check if executable
        if [[ -x "$PROJECT_ROOT/$script" ]]; then
            print_status "OK" "$script 可执行"
        else
            print_status "WARN" "$script 不可执行"
        fi
    else
        print_status "WARN" "$script 文件不存在"
    fi
done

echo

# 5. Check files directory
print_status "INFO" "检查文件目录..."
print_status "INFO" "Checking files directory..."

if [[ -d "$PROJECT_ROOT/files" ]]; then
    print_status "OK" "files 目录存在"
    
    # Check for common configuration files
    if [[ -d "$PROJECT_ROOT/files/etc" ]]; then
        print_status "OK" "etc 配置目录存在"
        
        if [[ -d "$PROJECT_ROOT/files/etc/opkg" ]]; then
            print_status "OK" "opkg 配置目录存在"
        fi
        
        if [[ -d "$PROJECT_ROOT/files/etc/dropbear" ]]; then
            print_status "OK" "dropbear 配置目录存在"
        fi
    else
        print_status "WARN" "files/etc 目录不存在"
    fi
else
    print_status "WARN" "files 目录不存在"
fi

echo

# 6. Summary and recommendations
print_status "INFO" "验证摘要和建议..."
print_status "INFO" "Validation summary and recommendations..."

echo
echo "=== 建议 / Recommendations ==="
echo

if [[ ! -f "$PROJECT_ROOT/README.md" ]]; then
    print_status "WARN" "建议添加 README.md 文件 / Consider adding README.md"
fi

if [[ ! -f "$PROJECT_ROOT/.gitignore" ]]; then
    print_status "WARN" "建议添加 .gitignore 文件 / Consider adding .gitignore"
fi

# Check for large files that might need to be excluded
large_files=$(find "$PROJECT_ROOT" -type f -size +1M 2>/dev/null | grep -v ".git" | head -5)
if [[ -n "$large_files" ]]; then
    print_status "WARN" "发现大文件，可能需要添加到 .gitignore:"
    echo "$large_files"
fi

print_status "INFO" "验证完成 / Validation completed"

# Show device support
echo
echo "=== 支持的设备 / Supported Devices ==="
for config_file in "${config_files[@]}"; do
    filename=$(basename "$config_file")
    device_name="${filename%.config.seed}"
    echo "  - $device_name"
done

# Show key features
echo
echo "=== 主要功能 / Key Features ==="
echo "  - 自动化 OpenWrt 固件构建 / Automated OpenWrt firmware building"
echo "  - 多设备支持 / Multi-device support"
echo "  - GitHub Actions CI/CD"
echo "  - 自定义软件包集成 / Custom package integration"
echo "  - 多版本固件生成 / Multiple firmware variants"
echo

print_status "OK" "配置验证完成！/ Configuration validation completed!"