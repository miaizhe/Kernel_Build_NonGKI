# NonGKI 内核编译工作流 (集成 KernelSU & SuSFS)

[English](README.md) | 中文说明

> **重构版本 2.0** - 受 [JackA1ltman/NonGKI_Kernel_Build_2nd](https://github.com/JackA1ltman/NonGKI_Kernel_Build_2nd) 启发

本项目提供了一个模块化、可参数化的 GitHub Actions 工作流，用于编译 **Non-GKI** Android 内核，支持 **KernelSU**、**SuSFS**，以及可选的 **Re:Kernel**、**Droidspaces/Docker** 和 **syscall hooks** 等功能。

## 项目架构

```
.github/workflows/
├── build-kernel.yml        # 主工作流（入口点）
├── build/                  # 遗留工作流（已弃用）
├── scripts/                # 辅助脚本
│   ├── rekernel-helper.sh      # Re:Kernel 补丁辅助
│   ├── ksu-inject.sh           # KernelSU 注入辅助
│   ├── syscall-hook.sh         # Syscall 钩子补丁辅助
│   └── susfs-helper.sh         # SuSFS 补丁辅助
Bin/                        # 打包和工具链脚本
├── prepare-compiler.sh         # Clang/GCC 下载器
├── package-anykernel3.sh       # AnyKernel3 ZIP 创建器
└── pack-boot-image.sh          # Boot 镜像重打包器
Patches/                      # 补丁引用（远程获取）
└── Rekernel/                   # Re:Kernel 补丁
```

## 功能特性

- **模块化设计**: 配置与构建逻辑分离
- **多 KernelSU 分支**: 支持 tiann、rsuntk、next、resukisu、sukisu
- **SuSFS 集成**: 可选的 Root 隐藏支持
- **Re:Kernel 补丁**: 可选的 Re:Kernel 补丁应用
- **Droidspaces/Docker**: 容器化的命名空间和 cgroup 支持
- **Syscall 钩子**: 替代的 KernelSU 钩子方法
- **灵活的工具链**: AOSP Clang、自定义 Clang、GCC 交叉编译器
- **双打包方式**: AnyKernel3 ZIP 和/或重打包 boot IMG
- **自动构建摘要**: GitHub Actions 中的详细构建报告
- **CCache 支持**: 更快的增量构建

## 快速开始

### 1. Fork 本仓库

将本仓库 Fork 到您的 GitHub 账号下。

### 2. 配置构建参数

编辑 `.github/workflows/build-kernel.yml` 并修改输入参数：

```yaml
inputs:
  KERNEL_SOURCE: 'https://github.com/您的用户名/内核仓库.git'
  KERNEL_BRANCH: '您的分支'
  KERNEL_CONFIG: 'vendor/您的_defconfig'
  CLANG_SOURCE: 'https://github.com/llvm/llvm-project/releases/...'
  DEVICE_NAME: '您的设备名'
  DEVICE_CODENAME: '您的设备代号'
```

### 3. 触发行工作流

1. 进入 **Actions** 选项卡
2. 选择 **Build Non-GKI Kernel with KSU & SuSFS**
3. 点击 **Run workflow** 按钮
4. 填写参数（或使用默认值）
5. 点击 **Run workflow**

### 4. 下载构建产物

构建完成后：
- 导航到工作流运行记录
- 从 **Summary** 页面下载产物
- 通过 Magisk 刷入 ZIP 或重打包 boot.img

## 参数参考

### 必需参数

| 参数 | 描述 | 示例 |
|------|------|------|
| `KERNEL_SOURCE` | 内核源码仓库地址 | `https://github.com/LineageOS/android_kernel_qcom_sm8250.git` |
| `KERNEL_BRANCH` | 内核源码分支 | `lineage-20.0`、`upstream-latest` |
| `KERNEL_CONFIG` | Defconfig 文件名 | `vendor/kona-perf_defconfig` |
| `CLANG_SOURCE` | Clang 编译器下载地址 | LLVM 或 AOSP Clang 压缩包 |

### 可选参数

| 参数 | 描述 | 默认值 |
|------|------|--------|
| `KERNEL_IMAGE_NAME` | 输出内核镜像名称 | `Image` |
| `DEVICE_NAME` | 设备名称 | `unknown` |
| `DEVICE_CODENAME` | 设备代号 | `unknown` |
| `CLANG_VERSION` | Clang 版本标识 | `''` |

### KernelSU 选项

| 参数 | 描述 | 默认值 |
|------|------|--------|
| `ENABLE_KERNELSU` | 向内核注入 KernelSU | `true` |
| `KERNELSU_BRANCH` | KernelSU 版本分支 | `main` |
| `KERNELSU_AUTO_FORK` | KernelSU 分支变体 | `tiann` |

**可用的 KernelSU 分支：**
- `tiann` - 原版 KernelSU
- `rsuntk` - rsuntk 的分支
- `next` - KernelSU-Next
- `resukisu` - ReSukiSU
- `sukisu` - SukiSU-Ultra

### SuSFS 选项

| 参数 | 描述 | 默认值 |
|------|------|--------|
| `ENABLE_SUSFS` | 启用 SuSFS Root 隐藏 | `false` |
| `SUSFS_FIXED` | 使用修复版 SuSFS 补丁 | `false` |

### 打包选项

| 参数 | 描述 | 默认值 |
|------|------|--------|
| `PACK_METHOD` | 打包方式 | `Anykernel3` |
| `AK3_SOURCE` | AnyKernel3 仓库地址 | `https://github.com/osm0sis/AnyKernel3.git` |
| `AK3_BRANCH` | AnyKernel3 分支 | `master` |
| `PACK_KMODULES` | 将 .ko 模块打包进 ZIP | `false` |

### 高级功能

| 参数 | 描述 | 默认值 |
|------|------|--------|
| `REKERNEL_ENABLE` | 应用 Re:Kernel 补丁 | `false` |
| `DROIDSPACES_ENABLE` | 启用 Docker/LXC 支持 | `false` |
| `HOOK_METHOD` | KernelSU 钩子方法 (`syscall`、`manual`、`trace`) | `syscall` |
| `KERNEL_PATCH` | 修补 kernel_read/kernel_write (适用于 ≤4.9 内核) | `false` |
| `BASEBAND_GUARD_ENABLE` | 启用基带保护 | `false` |
| `GENERATE_DTB` | 生成 DTB 文件 | `false` |
| `GENERATE_CHIP` | DTB 生成的芯片组 (`qcom`、`mediatek`) | `qcom` |
| `BUILD_OTHER_CONFIG` | 合并额外的配置文件 | `false` |
| `MERGE_CONFIG_FILES` | 逗号分隔的配置文件路径列表 | `''` |
| `FREE_MORE_SPACE` | 优化以获取更多构建空间 | `false` |

## 构建流程

构建过程遵循以下步骤：

```
1. 环境准备
   ├── 安装依赖 (~60 个包)
   └── 下载 Clang 工具链

2. 内核源码检出
   └── 克隆内核仓库

3. 补丁应用 (条件性)
   ├── Re:Kernel 补丁 (如果 REKERNEL_ENABLE)
   ├── 基带保护 (如果 BASEBAND_GUARD_ENABLE)
   ├── KernelSU 注入 (如果 ENABLE_KERNELSU)
   ├── SuSFS 补丁 (如果 ENABLE_SUSFS)
   ├── Syscall 钩子 (如果 HOOK_METHOD=syscall)
   └── Droidspaces 补丁 (如果 DROIDSPACES_ENABLE)

4. 内核配置
   ├── 应用 defconfig
   ├── 合并额外配置 (如果 BUILD_OTHER_CONFIG)
   └── 调整内核选项

5. 内核编译
   └── 使用 Clang + LLVM 编译

6. 打包
   ├── AnyKernel3 ZIP (如果 PACK_METHOD=Anykernel3)
   └── Boot 镜像重打包 (可选)

7. 上传产物
   └── GitHub Actions 产物 + Release
```

## 辅助脚本

### Re:Kernel 补丁

```bash
# 应用 Re:Kernel 补丁
.github/scripts/rekernel-helper.sh <内核目录>
```

### KernelSU 注入

```bash
# 使用指定分支注入 KernelSU
.github/scripts/ksu-inject.sh <内核目录> <分支> <版本>
# 示例:
.github/scripts/ksu-inject.sh . next main
```

### Syscall 钩子

```bash
# 应用 syscall 钩子
.github/scripts/syscall-hook.sh <内核目录>
```

### SuSFS 补丁

```bash
# 应用 SuSFS 补丁
.github/scripts/susfs-helper.sh <内核目录> [fixed]
```

### 编译器准备

```bash
# 下载并解压 Clang 工具链
Bin/prepare-compiler.sh <编译器目录> <clang_url> [gcc64_url] [gcc32_url]
```

### AnyKernel3 打包

```bash
# 创建可刷入的 ZIP
Bin/package-anykernel3.sh <内核镜像> <内核源码目录> <输出目录> [ak3源] [ak3分支] [打包模块] [自定义消息]
```

### Boot 镜像重打包

```bash
# 使用新内核重打包 boot 镜像
Bin/pack-boot-image.sh <内核镜像> <boot镜像> <输出镜像> [magiskboot_url]
```

## 注意事项

### 内核兼容性

- **仅支持 Non-GKI 内核**: 此工作流专为 Android 12 GKI (通用内核镜像) 之前的内核设计。对于 GKI 内核，请使用其他构建系统。
- **内核版本 4.14 - 5.10**: 与此工作流的兼容性最佳。

### KernelSU 要求

- KernelSU 需要您的内核中启用 `CONFIG_KPROBES`。
- 如果您的内核不支持 kprobes，您可能需要使用 `HOOK_METHOD=manual` 或应用自定义补丁。

### SuSFS 兼容性

- SuSFS 需要特定的内核版本和补丁。
- 如果自动补丁失败，您可能需要手动为您的内核源码打补丁。
- 查看 [SuSFS 文档](https://gitlab.com/simonpunk/susfs4ksu) 了解兼容的内核版本。

### Droidspaces/Docker

- 启用 `DROIDSPACES_ENABLE` 会添加 Docker/LXC 容器的命名空间和 cgroup 支持。
- 这需要额外的内核补丁，可能不适用于所有内核。

### 构建空间

- GitHub Actions 运行器磁盘空间有限。
- 如果遇到空间相关错误，请启用 `FREE_MORE_SPACE=true`。
- 考虑使用 `CCACHE` 来加速迭代构建。

## 常见问题

### 补丁阶段构建失败

1. 检查您的内核版本是否与补丁兼容
2. 尝试 `SKIP_PATCH=true` 跳过补丁错误
3. 克隆内核源码后手动应用补丁

### 刷入后 KernelSU 不工作

1. 验证您的内核配置中 `CONFIG_KPROBES=y`
2. 尝试不同的 `HOOK_METHOD` 值 (`syscall`、`manual`、`trace`)
3. 检查 KernelSU 应用的日志以获取错误信息

### 磁盘空间不足

1. 启用 `FREE_MORE_SPACE=true`
2. 清理构建环境中的不必要包
3. 使用更大的运行器（自托管）

### Clang 下载失败

1. 验证 `CLANG_SOURCE` URL 是否可访问
2. 检查 GitHub Actions 的网络连接
3. 尝试其他 Clang 源 (AOSP、LLVM 官方)

## 鸣谢

### 主要参考

- [JackA1ltman/NonGKI_Kernel_Build_2nd](https://github.com/JackA1ltman/NonGKI_Kernel_Build_2nd) - 原始工作流设计和灵感来源
- [KernelSU_Action](https://github.com/xiaoleGun/KernelSU_Action) - 构建流水线结构

### KernelSU 项目

- [KernelSU](https://github.com/tiann/KernelSU) - @tiann
- [rsuntk/KernelSU](https://github.com/rsuntk/KernelSU) - @rsuntk
- [KernelSU-Next](https://github.com/KernelSU-Next/KernelSU-Next) - @rifsxd
- [ReSukiSU](https://github.com/ReSukiSU/ReSukiSU) - @ReSukiSU
- [SukiSU-Ultra](https://github.com/SukiSU-Ultra/SukiSU-Ultra) - @ShirkNeko

### 其他项目

- [SuSFS](https://gitlab.com/simonpunk/susfs4ksu) - @simonpunk (Root 隐藏)
- [Re:Kernel](https://github.com/Sakion-Team/Re-Kernel) - @Sakion-Team
- [Baseband Guard](https://github.com/vc-teahouse/Baseband-guard) - @秋刀鱼
- [AnyKernel3](https://github.com/osm0sis/AnyKernel3) - @osm0sis
- [Droidspaces](https://github.com/ravindu644/Droidspaces-OSS) - @ravindu644

## 许可证

本项目基于 [GPLv3 License](LICENSE) 许可。

KernelSU 及相关项目保留其各自的许可证。
