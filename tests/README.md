# 测试文档

## 概述

本项目使用 TDD（测试驱动开发）方法，所有脚本和功能都有对应的测试用例。

## 测试套件

### 1. KernelSU 注入测试
- **文件**: `.github/scripts/test-ksu-inject.sh`
- **测试内容**:
  - 脚本存在性和可执行性
  - 默认 fork（tiann）处理
  - 各 fork 选择（next, resukisu 等）
  - 未知 fork 的回退机制

### 2. Re:Kernel 补丁测试
- **文件**: `.github/scripts/test-rekernel-helper.sh`
- **测试内容**:
  - 脚本存在性
  - Shebang 行正确性
  - 仓库引用正确性
  - 错误处理机制

### 3. 打包脚本测试
- **文件**: `Bin/test-package-anykernel3.sh`
- **测试内容**:
  - 脚本存在性
  - 参数验证（缺失参数）
  - 文件存在性验证
  - 脚本结构完整性

### 4. 工作流语法测试
- **文件**: `tests/test-workflow-syntax.sh`
- **测试内容**:
  - YAML 文件存在性
  - YAML 语法验证
  - 必需字段检查（name, on, jobs）
  - Shell 脚本语法验证

## 运行测试

### 方法 1：运行所有测试
```bash
bash tests/run-tests.sh
```

### 方法 2：运行单个测试
```bash
# 测试 KernelSU 注入脚本
bash .github/scripts/test-ksu-inject.sh

# 测试 Re:Kernel 补丁脚本
bash .github/scripts/test-rekernel-helper.sh

# 测试打包脚本
bash Bin/test-package-anykernel3.sh

# 测试工作流语法
bash tests/test-workflow-syntax.sh
```

## 测试结果

所有测试均通过！✅

```
Total:  4
Passed: 4
Failed: 0
```

## 持续集成

建议将测试添加到 GitHub Actions 工作流中，每次提交时自动运行。
# Test
