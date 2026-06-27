# NonGKI Kernel Build with KernelSU & SuSFS

English | [中文说明](README_cn.md)

> **Refactored Version 2.0** - Inspired by [JackA1ltman/NonGKI_Kernel_Build_2nd](https://github.com/JackA1ltman/NonGKI_Kernel_Build_2nd)

This project provides a modular, parameterized GitHub Actions workflow for compiling **Non-GKI** Android kernels with **KernelSU**, **SuSFS**, and optional features like **Re:Kernel**, **Droidspaces/Docker**, and **syscall hooks**.

## Architecture

```
.github/workflows/
├── build-kernel.yml        # Main workflow (entry point)
├── build/                  # Legacy workflows (deprecated)
├── scripts/                # Helper scripts
│   ├── rekernel-helper.sh      # Re:Kernel patch helper
│   ├── ksu-inject.sh           # KernelSU injection helper
│   ├── syscall-hook.sh         # Syscall hook patch helper
│   └── susfs-helper.sh         # SuSFS patch helper
Bin/                        # Packaging & toolchain scripts
├── prepare-compiler.sh         # Clang/GCC downloader
├── package-anykernel3.sh       # AnyKernel3 ZIP creator
└── pack-boot-image.sh          # Boot image repacker
Patches/                      # Patch references (fetched remotely)
└── Rekernel/                   # Re:Kernel patches
```

## Features

- **Modular Design**: Configuration separated from build logic
- **Multiple KernelSU Forks**: Support for tiann, rsuntk, next, resukisu, sukisu
- **SuSFS Integration**: Optional root-hiding support
- **Re:Kernel Patches**: Optional Re:Kernel patching
- **Droidspaces/Docker**: Namespace and cgroup support for containers
- **Syscall Hooks**: Alternative KernelSU hook method
- **Flexible Toolchains**: AOSP Clang, Custom Clang, GCC cross-compilers
- **Dual Packaging**: AnyKernel3 ZIP and/or repacked boot IMG
- **Auto Build Summary**: Detailed build report in GitHub Actions
- **CCache Support**: Faster incremental builds

## Quick Start

### 1. Fork this Repository

Fork this repository to your own GitHub account.

### 2. Configure Build Variables

Edit `.github/workflows/build-kernel.yml` and modify the input parameters:

```yaml
inputs:
  KERNEL_SOURCE: 'https://github.com/yourusername/your-kernel-repo.git'
  KERNEL_BRANCH: 'your-branch'
  KERNEL_CONFIG: 'vendor/your_defconfig'
  CLANG_SOURCE: 'https://github.com/llvm/llvm-project/releases/...'
  DEVICE_NAME: 'your_device'
  DEVICE_CODENAME: 'your_codename'
```

### 3. Trigger the Workflow

1. Go to the **Actions** tab
2. Select **Build Non-GKI Kernel with KSU & SuSFS**
3. Click **Run workflow**
4. Fill in the parameters (or use defaults)
5. Click **Run workflow**

### 4. Download Artifacts

Once the build completes:
- Navigate to the workflow run
- Download artifacts from the **Summary** page
- Flash the ZIP via Magisk or repack boot.img

## Parameters Reference

### Required Parameters

| Parameter | Description | Example |
|-----------|-------------|---------|
| `KERNEL_SOURCE` | Kernel source repository URL | `https://github.com/LineageOS/android_kernel_qcom_sm8250.git` |
| `KERNEL_BRANCH` | Kernel source branch | `lineage-20.0`, `upstream-latest` |
| `KERNEL_CONFIG` | Defconfig filename | `vendor/kona-perf_defconfig` |
| `CLANG_SOURCE` | Clang compiler download URL | LLVM or AOSP Clang tarball |

### Optional Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `KERNEL_IMAGE_NAME` | Output kernel image name | `Image` |
| `DEVICE_NAME` | Human-readable device name | `unknown` |
| `DEVICE_CODENAME` | Device codename | `unknown` |
| `CLANG_VERSION` | Clang version identifier | `''` |

### KernelSU Options

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ENABLE_KERNELSU` | Inject KernelSU into kernel | `true` |
| `KERNELSU_BRANCH` | KernelSU version branch | `main` |
| `KERNELSU_AUTO_FORK` | KernelSU fork variant | `tiann` |

**Available KernelSU forks:**
- `tiann` - Original KernelSU
- `rsuntk` - rsuntk's fork
- `next` - KernelSU-Next
- `resukisu` - ReSukiSU
- `sukisu` - SukiSU-Ultra

### SuSFS Options

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ENABLE_SUSFS` | Enable SuSFS root hiding | `false` |
| `SUSFS_FIXED` | Use fixed SuSFS patches | `false` |

### Packaging Options

| Parameter | Description | Default |
|-----------|-------------|---------|
| `PACK_METHOD` | Packaging method | `Anykernel3` |
| `AK3_SOURCE` | AnyKernel3 repository URL | `https://github.com/osm0sis/AnyKernel3.git` |
| `AK3_BRANCH` | AnyKernel3 branch | `master` |
| `PACK_KMODULES` | Pack .ko modules into ZIP | `false` |

### Advanced Features

| Parameter | Description | Default |
|-----------|-------------|---------|
| `REKERNEL_ENABLE` | Apply Re:Kernel patches | `false` |
| `DROIDSPACES_ENABLE` | Enable Docker/LXC support | `false` |
| `HOOK_METHOD` | KernelSU hook method (`syscall`, `manual`, `trace`) | `syscall` |
| `KERNEL_PATCH` | Patch kernel_read/kernel_write (kernels ≤4.9) | `false` |
| `BASEBAND_GUARD_ENABLE` | Enable baseband guard protection | `false` |
| `GENERATE_DTB` | Generate DTB file | `false` |
| `GENERATE_CHIP` | Chipset for DTB (`qcom`, `mediatek`) | `qcom` |
| `BUILD_OTHER_CONFIG` | Merge additional config files | `false` |
| `MERGE_CONFIG_FILES` | Comma-separated config fragment paths | `''` |
| `FREE_MORE_SPACE` | Optimize for more build space | `false` |

## Build Pipeline

The build process follows these steps:

```
1. Environment Setup
   ├── Install dependencies (~60 packages)
   └── Download Clang toolchain

2. Kernel Source Checkout
   └── Clone kernel repository

3. Patch Application (conditional)
   ├── Re:Kernel patches (if REKERNEL_ENABLE)
   ├── Baseband Guard (if BASEBAND_GUARD_ENABLE)
   ├── KernelSU injection (if ENABLE_KERNELSU)
   ├── SuSFS patches (if ENABLE_SUSFS)
   ├── Syscall hooks (if HOOK_METHOD=syscall)
   └── Droidspaces patches (if DROIDSPACES_ENABLE)

4. Kernel Configuration
   ├── Apply defconfig
   ├── Merge additional configs (if BUILD_OTHER_CONFIG)
   └── Adjust kernel options

5. Kernel Compilation
   └── Build with Clang + LLVM

6. Packaging
   ├── AnyKernel3 ZIP (if PACK_METHOD=Anykernel3)
   └── Boot image repack (optional)

7. Upload Artifacts
   └── GitHub Actions artifacts + Release
```

## Helper Scripts

### Re:Kernel Patches

```bash
# Apply Re:Kernel patches
.github/scripts/rekernel-helper.sh <kernel_dir>
```

### KernelSU Injection

```bash
# Inject KernelSU with specific fork
.github/scripts/ksu-inject.sh <kernel_dir> <fork> <branch>
# Example:
.github/scripts/ksu-inject.sh . next main
```

### Syscall Hooks

```bash
# Apply syscall-based hooks
.github/scripts/syscall-hook.sh <kernel_dir>
```

### SuSFS Patches

```bash
# Apply SuSFS patches
.github/scripts/susfs-helper.sh <kernel_dir> [fixed]
```

### Compiler Preparation

```bash
# Download and extract Clang toolchain
Bin/prepare-compiler.sh <compiler_dir> <clang_url> [gcc64_url] [gcc32_url]
```

### AnyKernel3 Packaging

```bash
# Create flashable ZIP
Bin/package-anykernel3.sh <kernel_image> <kernel_source_dir> <output_dir> [ak3_source] [ak3_branch] [pack_modules] [custom_message]
```

### Boot Image Repacking

```bash
# Repack boot image with new kernel
Bin/pack-boot-image.sh <kernel_image> <boot_image> <output_image> [magiskboot_url]
```

## Important Notes

### Kernel Compatibility

- **Non-GKI kernels only**: This workflow is designed for kernels prior to Android 12 GKI (Generic Kernel Image). For GKI kernels, use a different build system.
- **Kernel version 4.14 - 5.10**: Best compatibility with this workflow.

### KernelSU Requirements

- KernelSU requires `CONFIG_KPROBES` to be enabled in your kernel.
- If your kernel doesn't support kprobes, you may need to use `HOOK_METHOD=manual` or apply custom patches.

### SuSFS Compatibility

- SuSFS requires specific kernel versions and patches.
- If automated patching fails, you may need to manually patch your kernel source.
- Check the [SuSFS documentation](https://gitlab.com/simonpunk/susfs4ksu) for compatible kernel versions.

### Droidspaces/Docker

- Enabling `DROIDSPACES_ENABLE` adds namespace and cgroup support for Docker/LXC containers.
- This requires additional kernel patches that may not be compatible with all kernels.

### Build Space

- GitHub Actions runners have limited disk space.
- Enable `FREE_MORE_SPACE=true` if you encounter space-related errors.
- Consider using `CCACHE` to speed up iterative builds.

## Troubleshooting

### Build Fails at Patch Stage

1. Check if your kernel version is compatible with the patch
2. Try `SKIP_PATCH=true` to bypass patch errors
3. Manually apply patches after cloning the kernel source

### KernelSU Not Working After Flash

1. Verify `CONFIG_KPROBES=y` in your kernel config
2. Try different `HOOK_METHOD` values (`syscall`, `manual`, `trace`)
3. Check KernelSU app logs for error messages

### Out of Disk Space

1. Enable `FREE_MORE_SPACE=true`
2. Clean up unnecessary packages in the build environment
3. Use a larger runner (self-hosted)

### Clang Download Fails

1. Verify the `CLANG_SOURCE` URL is accessible
2. Check network connectivity from GitHub Actions
3. Try alternative Clang sources (AOSP, LLVM official)

## Credits & Acknowledgements

### Primary References

- [JackA1ltman/NonGKI_Kernel_Build_2nd](https://github.com/JackA1ltman/NonGKI_Kernel_Build_2nd) - Original workflow design and inspiration
- [KernelSU_Action](https://github.com/xiaoleGun/KernelSU_Action) - Build pipeline structure

### KernelSU Projects

- [KernelSU](https://github.com/tiann/KernelSU) - @tiann
- [rsuntk/KernelSU](https://github.com/rsuntk/KernelSU) - @rsuntk
- [KernelSU-Next](https://github.com/KernelSU-Next/KernelSU-Next) - @rifsxd
- [ReSukiSU](https://github.com/ReSukiSU/ReSukiSU) - @ReSukiSU
- [SukiSU-Ultra](https://github.com/SukiSU-Ultra/SukiSU-Ultra) - @ShirkNeko

### Other Projects

- [SuSFS](https://gitlab.com/simonpunk/susfs4ksu) - @simonpunk (Root hiding)
- [Re:Kernel](https://github.com/Sakion-Team/Re-Kernel) - @Sakion-Team
- [Baseband Guard](https://github.com/vc-teahouse/Baseband-guard) - @秋刀鱼
- [AnyKernel3](https://github.com/osm0sis/AnyKernel3) - @osm0sis
- [Droidspaces](https://github.com/ravindu644/Droidspaces-OSS) - @ravindu644

## License

This project is licensed under the [GPLv3 License](LICENSE).

KernelSU and related projects retain their respective licenses.
