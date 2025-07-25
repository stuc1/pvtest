# pvtest - OpenWrt Firmware Build Automation

## Project Overview

`stuc1/pvtest` is an automated OpenWrt firmware building system powered by GitHub Actions. This project specializes in building customized OpenWrt router firmware for various ARM and x86 devices, featuring rich third-party package integration and multiple firmware variants.

## Key Features

### 🚀 Automated CI/CD Pipeline
- Fully automated firmware compilation using GitHub Actions
- Multi-platform support (ARM64, ARMv7, x86)
- On-demand builds with customizable parameters

### 📱 Supported Devices
- **NanoPi Series**: R1S, R1S-H3, R2S, R2C, R4S, R4SE, R5S, R5C, R6S, R6C
- **x86/x64 Systems**: Desktop and server platforms
- **Other Devices**: D2, E20C, E25 series

### 📦 Firmware Variants
- **Slim Version**: Lightweight firmware with essential features
- **Standard Version**: Full-featured firmware with complete LuCI applications
- **Docker Version**: Standard firmware with Docker support

## 🛠 Technical Architecture

### Build Workflow
```
Trigger → Environment Setup → Code Checkout → Package Updates → Patch Application → Configuration → Compilation → Release
```

### Configuration Management
- `common.seed`: Shared configuration for all devices
- `{device}.config.seed`: Device-specific configurations
- `extra_packages.seed`: Additional package configurations
- Custom scripts for package merging and patching

## 📋 Integrated Software Packages

### Network & Security
- **SSR-Plus**: Proxy solution with multiple protocol support
- **AdGuard Home**: DNS filtering and ad blocking
- **SmartDNS**: Intelligent DNS service
- **OpenClash**: Clash client for OpenWrt
- **Passwall**: Transparent proxy tool

### System Management
- **DDNS**: Dynamic DNS services
- **UPnP**: Universal Plug and Play
- **TTYD**: Web-based terminal access
- **Samba/CIFS**: Network file sharing
- **FTP/SFTP**: File transfer services

### Storage & Downloads
- **Aria2**: Multi-threaded download manager
- **qBittorrent**: BitTorrent client
- **USB Printer Support**: USB printer functionality
- **Disk Management**: Partition and storage management tools

### Monitoring & Analytics
- **Netdata**: Real-time system monitoring
- **VNSTAT**: Network traffic statistics
- **SNMP**: Network management protocol
- **System Statistics**: Comprehensive system status monitoring

## 🔧 Advanced Features

### Intelligent Caching
- BTRFS compression for efficient storage
- Build cache save/restore functionality
- Significantly reduced rebuild times

### Multi-Environment Support
- GitHub Actions (ubuntu-22.04)
- Self-hosted runners
- Third-party cloud build platforms (depot, ubicloud, buildjet, warp)

### Debug & Monitoring
- **SSH Debugging**: Remote debugging via tmate on build failures
- **Telegram Notifications**: Real-time build status notifications
- **Detailed Logging**: Comprehensive build process logs

## 🚀 Getting Started

### Manual Build Trigger
1. Go to the "Actions" tab in the repository
2. Select "Repo Dispatcher" workflow
3. Click "Run workflow"
4. Configure build parameters:
   - Device model (e.g., r2s, r4s, x86)
   - Branch selection
   - Debug mode
   - Cache options
   - Runner environment

### Build Parameters
- **device**: Target device model
- **branch**: OpenWrt source branch (default: master)
- **debug**: Enable debug mode (true/false)
- **expand**: Expand disk image (true/false)
- **cache_save**: Save build cache (true/false)
- **package_clean**: Clean package cache (true/false)
- **runner**: Build environment selection

## 📋 System Requirements

### Build Environment
- Ubuntu 18.04/22.04 or compatible
- Minimum 30GB available disk space
- Multi-core CPU (16+ cores recommended)
- 16GB+ RAM

### Dependencies
- Git, Make, GCC toolchain
- Python 3.x development environment
- QEMU emulator
- Various build tools and libraries

## 🎯 Use Cases

### Individual Users
- Custom router firmware requirements
- Latest software packages and features
- Specific networking functionality needs

### Developers
- OpenWrt development and testing
- Firmware customization and optimization
- New device adaptation and validation

### Enterprise Users
- Bulk device firmware management
- Customized networking solutions
- Security and monitoring requirements

## 🔄 Workflow Details

### Main Workflows
- **dispatch.yml**: Central build dispatcher with parameter handling
- **lo-test.yml**: Complete firmware build process with multi-variant generation
- **mi-test.yml**: Test builds based on ImmortalWrt 18.06 branch
- **tn.yml**: Additional testing workflow

### Scripts
- **merge_packages.sh**: Third-party package integration
- **merge_files.sh**: Configuration file merging
- **patches.sh**: System patch application

## 📈 Project Advantages

1. **High Automation**: Fully automated build and release process
2. **Multi-Device Support**: Covers mainstream ARM and x86 devices
3. **Rich Functionality**: Integrated useful third-party applications
4. **Continuous Updates**: Based on latest OpenWrt source code
5. **Easy to Use**: Simple web interface for build triggering
6. **Community Support**: Open source with community contributions

## 📝 License

This project is open source. Please refer to the original OpenWrt license terms and the licenses of integrated third-party packages.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests to improve this project.

## 📞 Support

For detailed project analysis in Chinese, please refer to `项目分析报告.md`.

---

*This project provides an automated solution for OpenWrt firmware building, making custom router firmware accessible to users without deep technical knowledge of the OpenWrt build process.*