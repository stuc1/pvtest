# Technical Architecture Overview

## System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                              GitHub Repository (stuc1/pvtest)                   │
├─────────────────────────────────────────────────────────────────────────────────┤
│  Configuration Files        │  Workflow Files         │  Scripts & Patches      │
│  • common.seed              │  • dispatch.yml          │  • merge_packages.sh     │
│  • device.config.seed       │  • lo-test.yml           │  • merge_files.sh        │
│  • extra_packages.seed      │  • mi-test.yml           │  • patches.sh            │
│  • files/ directory         │  • tn.yml                │  • assets/               │
└─────────────────────────────────────────────────────────────────────────────────┘
                                        │
                                        ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                            GitHub Actions Workflow Trigger                      │
├─────────────────────────────────────────────────────────────────────────────────┤
│  Manual Trigger (dispatch.yml)        │  Automated Trigger                      │
│  • Device Selection: r1s, r2s, r4s,   │  • Scheduled builds                     │
│    r5s, r6s, r6c, x86, etc.          │  • Push/PR triggers                     │
│  • Branch: master, openwrt-18.06      │  • Repository dispatch events           │
│  • Debug Mode: on/off                 │                                         │
│  • Cache Options: save/clean          │                                         │
│  • Runner Selection                   │                                         │
└─────────────────────────────────────────────────────────────────────────────────┘
                                        │
                                        ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                            Build Environment Setup                              │
├─────────────────────────────────────────────────────────────────────────────────┤
│  Runner Environment:                   │  Cache Management:                      │
│  • ubuntu-22.04 (GitHub)              │  • BTRFS compressed disk image         │
│  • self-hosted                        │  • Build cache restoration             │
│  • depot-ubuntu-22.04-32              │  • Download cache management           │
│  • buildjet-32vcpu-ubuntu-2204        │  • Parallel compression/decompression  │
│  • warp-ubuntu-2204-x64-32x           │                                         │
│                                        │                                         │
│  System Preparation:                   │  Space Optimization:                   │
│  • Install build dependencies         │  • Clean unnecessary files             │
│  • Configure swap and VM settings     │  • Mount loop devices                  │
│  • Setup development tools            │  • BTRFS filesystem optimization       │
└─────────────────────────────────────────────────────────────────────────────────┘
                                        │
                                        ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                           Source Code & Package Management                      │
├─────────────────────────────────────────────────────────────────────────────────┤
│  Base Source:                          │  Feed Management:                       │
│  • coolsnowwolf/lede (main)            │  • Update all feeds                    │
│  • immortalwrt/immortalwrt (test)      │  • Install feed packages               │
│                                        │  • Handle feed conflicts               │
│  Third-party Packages:                 │                                         │
│  • NAS packages (linkease)             │  Custom Integration:                    │
│  • HelloWorld (SSR-Plus)               │  • Merge custom packages               │
│  • OpenClash                           │  • Apply system patches                │
│  • AdGuard Home                        │  • Drop conflicting packages           │
│  • Various luci-apps                   │  • Configure package priorities        │
└─────────────────────────────────────────────────────────────────────────────────┘
                                        │
                                        ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                          Configuration Generation                               │
├─────────────────────────────────────────────────────────────────────────────────┤
│  Device-Specific Config:               │  Package Selection:                     │
│  • Target architecture                 │  • Core system packages                │
│  • Hardware-specific options           │  • LuCI applications                   │
│  • Kernel modules                      │  • Third-party applications            │
│  • Root filesystem size                │  • Language packs (Chinese)            │
│                                        │                                         │
│  Build Options:                        │  Feature Configuration:                │
│  • Optimization flags                  │  • Network protocols                   │
│  • Compression settings                │  • Filesystem support                  │
│  • Debug symbols                       │  • Hardware acceleration               │
│  • UPX compression                     │  • Security features                   │
└─────────────────────────────────────────────────────────────────────────────────┘
                                        │
                                        ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                             Compilation Process                                 │
├─────────────────────────────────────────────────────────────────────────────────┤
│  Parallel Build Stages:                │  Output Generation:                     │
│  1. Tools compilation                  │  • Kernel image                        │
│  2. Toolchain compilation              │  • Root filesystem                     │
│  3. Target compilation                 │  • Package repositories                │
│  4. Package compilation                │  • Build information                   │
│  5. Target installation                │  • Manifests and checksums             │
│  6. Package installation               │                                         │
│                                        │  ImageBuilder:                          │
│  Build Optimization:                   │  • Standalone image builder            │
│  • Multi-core compilation             │  • Package installation capability     │
│  • Download parallelization           │  • Custom image generation             │
│  • Incremental builds                 │                                         │
└─────────────────────────────────────────────────────────────────────────────────┘
                                        │
                                        ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                            Firmware Image Generation                            │
├─────────────────────────────────────────────────────────────────────────────────┤
│  Slim Firmware:                       │  Standard Firmware:                     │
│  • Basic system + essential apps      │  • Full LuCI application suite         │
│  • Minimal package set                │  • All configured packages             │
│  • Local package feed                 │  • Complete functionality              │
│  • Chinese language support           │  • Network feed access                 │
│                                        │                                         │
│  Docker Firmware (for supported):     │  Image Processing:                      │
│  • Standard + Docker support          │  • GZIP compression                    │
│  • Container runtime                  │  • MD5 checksum generation             │
│  • Additional storage optimization    │  • Size optimization                   │
└─────────────────────────────────────────────────────────────────────────────────┘
                                        │
                                        ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                          Distribution & Release Management                      │
├─────────────────────────────────────────────────────────────────────────────────┤
│  GitHub Releases:                     │  Cache Management:                      │
│  • Automatic release creation         │  • Disk image compression (zstd)       │
│  • Date-based tagging                 │  • Multi-part upload                   │
│  • Multiple firmware variants         │  • Cache validation                    │
│  • MD5 checksums                      │  • Space optimization                  │
│                                        │                                         │
│  Artifacts:                           │  Notifications:                         │
│  • Firmware images (.img.gz)          │  • Telegram build status               │
│  • Build information                  │  • Success/failure alerts              │
│  • Package repositories               │  • Debug session access                │
│  • Configuration files                │                                         │
└─────────────────────────────────────────────────────────────────────────────────┘
```

## Data Flow Architecture

```
Configuration Files → Build Parameters → Environment Setup → Source Management
       ↓                    ↓                 ↓                    ↓
Device Profiles → Workflow Selection → Cache Restoration → Package Integration
       ↓                    ↓                 ↓                    ↓
Build Config → Parallel Compilation → Quality Assurance → Image Generation
       ↓                    ↓                 ↓                    ↓
Testing → Artifact Creation → Release Publishing → Cache Update
```

## Key Components Interaction

### 1. Configuration Layer
- **Device Profiles**: Hardware-specific configurations
- **Package Selection**: Software component choices
- **Build Options**: Compilation and optimization settings

### 2. Build Orchestration
- **Workflow Dispatcher**: Central build coordination
- **Environment Manager**: Resource allocation and setup
- **Cache System**: Build acceleration and storage optimization

### 3. Source Management
- **Base Repository**: OpenWrt source code management
- **Package Integration**: Third-party software inclusion
- **Patch System**: Bug fixes and feature additions

### 4. Compilation Engine
- **Parallel Processing**: Multi-core build utilization
- **Dependency Resolution**: Package dependency management
- **Quality Control**: Build verification and testing

### 5. Distribution System
- **Image Generation**: Multiple firmware variant creation
- **Release Automation**: Automated publishing and versioning
- **Notification System**: Status reporting and alerts

This architecture enables scalable, reliable, and efficient OpenWrt firmware building with minimal manual intervention while maintaining high customization capabilities.