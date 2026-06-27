# NonGKI Kernel Build - 重构说明

## 版本历史

### v2.0 (当前版本) - 模块化重构

**发布日期**: 2026-06-19

**主要改进**:
1. **统一工作流**: 将原来的两个独立工作流合并为一个高度参数化的 `build-kernel.yml`
2. **模块化设计**: 配置与逻辑分离，便于维护和扩展
3. **辅助脚本库**: 新增 `.github/scripts/` 和 `Bin/` 目录，提供可复用的构建工具
4. **完整的参数支持**: 支持 20+ 可配置参数，覆盖所有构建选项
5. **增强的文档**: 中英文 README 全面更新，包含详细的参数参考和故障排除

**文件变更**:
- ✅ 新增: `.github/workflows/build-kernel.yml` - 统一的主工作流
- ✅ 新增: `.github/scripts/` - 辅助脚本目录
  - `rekernel-helper.sh` - Re:Kernel 补丁助手
  - `ksu-inject.sh` - KernelSU 注入助手
  - `syscall-hook.sh` - Syscall 钩子助手
  - `susfs-helper.sh` - SuSFS 补丁助手
- ✅ 新增: `Bin/` - 工具链和打包脚本
  - `prepare-compiler.sh` - 编译器下载和解压
  - `package-anykernel3.sh` - AnyKernel3 打包
  - `pack-boot-image.sh` - Boot 镜像重打包
- ✅ 新增: `Patches/Rekernel/` - 补丁引用目录
- ✅ 更新: `README.md` - 英文文档全面重构
- ✅ 更新: `README_cn.md` - 中文文档全面重构
- 📦 保留: `.github/workflows/env.yaml` - 旧版 OnePlus 8 工作流（参考）
- 📦 保留: `.github/workflows/build/build.yml` - 旧版 Reno10 Docker 工作流（参考）

---

### v1.0 - 初始版本

**基于**: [JackA1ltman/NonGKI_Kernel_Build_2nd](https://github.com/JackA1ltman/NonGKI_Kernel_Build_2nd)

**原始结构**:
- `.github/workflows/env.yaml` - OnePlus 8 系列专用工作流
- `.github/workflows/build/build.yml` - OPPO Reno10 Docker 专用工作流

**局限性**:
1. 每个设备需要独立的工作流文件
2. 参数硬编码，难以复用
3. 缺少辅助脚本和工具链管理
4. 文档不够完善

---

## 迁移指南

### 从 v1.0 迁移到 v2.0

如果您之前使用的是 `env.yaml` 或 `build/build.yml`，请按以下步骤迁移：

#### 1. 更新工作流触发

**旧方式** (v1.0):
```yaml
# env.yaml - 硬编码的设备配置
KERNEL_SOURCE: "https://github.com/xxx/xxx.git"
KERNEL_BRANCH: "upstream-latest"
DEFCONFIG_NAME: "vendor/kona-perf_defconfig"
```

**新方式** (v2.0):
```yaml
# 在 Actions 界面选择 "Run workflow"
# 然后通过表单输入参数，或编辑 YAML 文件:
inputs:
  KERNEL_SOURCE: 'https://github.com/您的仓库/内核.git'
  KERNEL_BRANCH: '您的分支'
  KERNEL_CONFIG: 'vendor/您的_defconfig'
  CLANG_SOURCE: 'https://github.com/llvm/llvm-project/releases/...'
```

#### 2. 更新 KernelSU 配置

**旧方式** (v1.0):
```yaml
KERNELSU_SOURCE: "https://raw.githubusercontent.com/tiann/KernelSU/.../setup.sh"
KERNELSU_AUTO_FORK: "resukisu"
```

**新方式** (v2.0):
```yaml
ENABLE_KERNELSU: true
KERNELSU_AUTO_FORK: "tiann"  # 或 rsuntk, next, resukisu, sukisu
KERNELSU_BRANCH: "main"
```

#### 3. 启用可选功能

**Re:Kernel**:
```yaml
REKERNEL_ENABLE: true
```

**SuSFS**:
```yaml
ENABLE_SUSFS: true
SUSFS_FIXED: true
```

**Droidspaces/Docker**:
```yaml
DROIDSPACES_ENABLE: true
```

**Syscall Hook**:
```yaml
HOOK_METHOD: "syscall"  # 或 manual, trace
```

#### 4. 使用辅助脚本（可选）

如果需要本地调试补丁应用，可以使用新的辅助脚本：

```bash
# 注入 KernelSU
.github/scripts/ksu-inject.sh <内核目录> next main

# 应用 Re:Kernel 补丁
.github/scripts/rekernel-helper.sh <内核目录>

# 应用 Syscall 钩子
.github/scripts/syscall-hook.sh <内核目录>

# 应用 SuSFS 补丁
.github/scripts/susfs-helper.sh <内核目录> true
```

---

## 兼容性说明

### 完全兼容

- ✅ GitHub Actions `workflow_dispatch` 手动触发
- ✅ GitHub Actions `workflow_call` 被其他工作流调用
- ✅ 所有 v1.0 的功能都在 v2.0 中支持
- ✅ 相同的 KernelSU、SuSFS、Re:Kernel 补丁源

### 已知差异

| 特性 | v1.0 | v2.0 | 说明 |
|------|------|------|------|
| 工作流数量 | 2 个独立文件 | 1 个统一文件 | v2.0 更简洁 |
| 参数配置 | 硬编码 | 表单/变量 | v2.0 更灵活 |
| 辅助脚本 | 无 | 完整库 | v2.0 可扩展 |
| 文档 | 基础 | 详细 | v2.0 更完善 |
| 构建摘要 | 无 | 有 | v2.0 自动报告 |

---

## 回滚指南

如果您需要回滚到 v1.0 的工作流：

1. 保留 `.github/workflows/env.yaml` 和 `.github/workflows/build/build.yml`
2. 在 Actions 界面选择对应的工作流
3. 忽略新的 `build-kernel.yml`

**注意**: v1.0 工作流不再接收功能更新和安全修复，建议尽快迁移到 v2.0。

---

## 技术支持

- 📖 完整文档: 参见 `README.md` 和 `README_cn.md`
- 🐛 问题反馈: [GitHub Issues](https://github.com/JackA1ltman/NonGKI_Kernel_Build_2nd/issues)
- 💬 社区讨论: [GitHub Discussions](https://github.com/JackA1ltman/NonGKI_Kernel_Build_2nd/discussions)

---

**最后更新**: 2026-06-19
**维护者**: JackA1ltman
