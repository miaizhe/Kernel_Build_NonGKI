# NonGKI Kernel Build - 项目总结

## 📊 项目信息

- **项目名称**: NonGKI Kernel Build with KernelSU & SuSFS
- **版本**: 2.0.0
- **许可证**: GPLv3
- **仓库**: https://github.com/miaizhe/Kernel_Build_NonGKI

## 🎯 项目目标

提供一个模块化、可参数化的 GitHub Actions 工作流，用于编译 Non-GKI Android 内核，支持 KernelSU、SuSFS 和其他增强功能。

## ✨ 核心特性

### 1. 模块化架构
- 统一的工作流文件 (`build-kernel.yml`)
- 可复用的辅助脚本库
- 清晰的目录结构

### 2. 灵活的配置
- 20+ 可配置参数
- 支持多种 KernelSU 分支
- 可选功能开关

### 3. 完善的测试
- TDD 测试套件
- 自动化 CI/CD 验证
- 所有测试通过 ✅

### 4. 完整文档
- 中英文 README
- 迁移指南
- 使用示例

## 📁 项目结构

```
Kernel_Build_NonGKI/
├── .github/
│   ├── workflows/
│   │   ├── build-kernel.yml      # 主工作流
│   │   └── test.yml              # 测试工作流
│   ├── scripts/                  # 辅助脚本
│   │   ├── ksu-inject.sh
│   │   ├── rekernel-helper.sh
│   │   ├── syscall-hook.sh
│   │   └── susfs-helper.sh
│   ├── ISSUE_TEMPLATE/           # Issue 模板
│   └── dependabot.yml            # 依赖更新配置
├── Bin/                          # 打包和工具链脚本
│   ├── prepare-compiler.sh
│   ├── package-anykernel3.sh
│   └── pack-boot-image.sh
├── tests/                        # 测试套件
│   ├── run-tests.sh
│   └── README.md
├── README.md                     # 英文文档
├── README_cn.md                  # 中文文档
├── MIGRATION.md                  # 迁移指南
└── LICENSE                       # GPLv3 许可证
```

## 🚀 快速开始

### 1. Fork 仓库
```bash
# 在 GitHub 网页上 Fork 此仓库
```

### 2. 配置参数
在 Actions 界面或通过编辑 `build-kernel.yml` 配置：
- `KERNEL_SOURCE`: 内核源码地址
- `KERNEL_BRANCH`: 内核分支
- `KERNEL_CONFIG`: defconfig 文件
- `CLANG_SOURCE`: Clang 编译器地址

### 3. 触发构建
```
Actions → Build Non-GKI Kernel with KSU & SuSFS → Run workflow
```

### 4. 下载产物
构建完成后从 Actions 页面下载 ZIP 或 IMG 文件

## 🧪 测试

运行测试套件：
```bash
bash tests/run-tests.sh
```

测试覆盖：
- ✅ KernelSU 注入脚本 (5 个测试)
- ✅ Re:Kernel 补丁脚本 (4 个测试)
- ✅ 打包脚本 (4 个测试)
- ✅ 工作流语法 (6 个测试)

## 📝 工作流

### 主工作流 (build-kernel.yml)
- 支持手动触发 (`workflow_dispatch`)
- 可被其他工作流调用 (`workflow_call`)
- 完整的参数验证

### 测试工作流 (test.yml)
- 自动运行在每次推送
- 验证脚本语法
- 检查文件完整性
- 依赖更新提醒

## 🔧 辅助脚本

### KernelSU 注入
```bash
.github/scripts/ksu-inject.sh <kernel_dir> <fork> <branch>
```

### Re:Kernel 补丁
```bash
.github/scripts/rekernel-helper.sh <kernel_dir>
```

### Syscall 钩子
```bash
.github/scripts/syscall-hook.sh <kernel_dir>
```

### SuSFS 补丁
```bash
.github/scripts/susfs-helper.sh <kernel_dir> [fixed]
```

## 📚 文档

- [README.md](README.md) - 英文完整文档
- [README_cn.md](README_cn.md) - 中文完整文档
- [MIGRATION.md](MIGRATION.md) - 版本迁移指南
- [tests/README.md](tests/README.md) - 测试文档

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

### 报告问题
使用 [Bug Report](.github/ISSUE_TEMPLATE/kernel-build-issue.md) 模板

### 功能请求
使用 [Feature Request](.github/ISSUE_TEMPLATE/feature-request.md) 模板

### 提交 PR
遵循 [PR Template](.github/PULL_REQUEST_TEMPLATE.md)

## 📄 许可证

本项目基于 [GPLv3 License](LICENSE) 许可。

## 🙏 致谢

- [JackA1ltman/NonGKI_Kernel_Build_2nd](https://github.com/JackA1ltman/NonGKI_Kernel_Build_2nd) - 原始工作流设计
- [KernelSU](https://github.com/tiann/KernelSU) - Root 解决方案
- [SuSFS](https://gitlab.com/simonpunk/susfs4ksu) - Root 隐藏
- [Re:Kernel](https://github.com/Sakion-Team/Re-Kernel) - 内核增强
- [AnyKernel3](https://github.com/osm0sis/AnyKernel3) - 打包工具

---

**最后更新**: 2026-06-20
**维护者**: miaizhe
