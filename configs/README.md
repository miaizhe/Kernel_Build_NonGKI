# 内核编译配置文件

存放不同设备的内核编译配置。

## 可用配置

| 配置文件 | 设备 | 描述 |
|---------|------|------|
| `oneplus8.json` | OnePlus 8 | ColorOS 15 / Android 15 |
| `reno10_docker.json` | OPPO Reno10 | ReSukiSU + Docker 支持 |
| `xiaomi11_ultra.json` | Xiaomi 11 Ultra | LineageOS Kernel |
| `pixel6.json` | Pixel 6 | AOSP Kernel |

## 创建新配置

复制任意现有配置文件，修改相应参数即可：

```json
{
  "name": "设备名称",
  "description": "设备描述",
  "KERNEL_SOURCE": "内核源码仓库 URL",
  "KERNEL_BRANCH": "内核分支",
  "KERNEL_CONFIG": "defconfig 文件名",
  "KERNEL_IMAGE_NAME": "输出镜像名称",
  "CLANG_SOURCE": "Clang 编译器下载地址",
  "DEVICE_NAME": "设备名称",
  "DEVICE_CODENAME": "设备代号",
  "ENABLE_KERNELSU": true,
  "KERNELSU_AUTO_FORK": "tiann",
  "ENABLE_SUSFS": false,
  "PACK_METHOD": "Anykernel3"
}
```

## 字段说明

### 必需字段

| 字段 | 类型 | 说明 |
|------|------|------|
| `KERNEL_SOURCE` | string | 内核源码 Git 仓库地址 |
| `KERNEL_BRANCH` | string | 内核源码分支 |
| `KERNEL_CONFIG` | string | defconfig 文件名 |
| `CLANG_SOURCE` | string | Clang 编译器下载地址 |

### 设备信息

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `DEVICE_NAME` | string | `unknown` | 设备名称 |
| `DEVICE_CODENAME` | string | `unknown` | 设备代号 |

### KernelSU

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `ENABLE_KERNELSU` | boolean | `true` | 是否注入 KernelSU |
| `KERNELSU_BRANCH` | string | `main` | KernelSU 版本分支 |
| `KERNELSU_AUTO_FORK` | string | `tiann` | KernelSU 分支 (tiann/rsuntk/next/resukisu/sukisu) |

### SuSFS

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `ENABLE_SUSFS` | boolean | `false` | 是否启用 SuSFS |
| `SUSFS_FIXED` | boolean | `false` | 使用修复版补丁 |

### 打包配置

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `PACK_METHOD` | string | `Anykernel3` | 打包方式 |
| `AK3_SOURCE` | string | `https://github.com/osm0sis/AnyKernel3.git` | AnyKernel3 仓库 |
| `AK3_BRANCH` | string | `master` | AnyKernel3 分支 |
| `PACK_KMODULES` | boolean | `false` | 是否打包 .ko 模块 |

### 高级功能

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `REKERNEL_ENABLE` | boolean | `false` | 启用 Re:Kernel 补丁 |
| `DROIDSPACES_ENABLE` | boolean | `false` | 启用 Docker/LXC 支持 |
| `HOOK_METHOD` | string | `syscall` | KernelSU 钩子方法 |
| `KERNEL_PATCH` | boolean | `false` | 修补 kernel_read/kernel_write |
| `BASEBAND_GUARD_ENABLE` | boolean | `false` | 启用基带保护 |
| `GENERATE_DTB` | boolean | `false` | 生成 DTB 文件 |
| `GENERATE_CHIP` | string | `qcom` | DTB 芯片组 (qcom/mediatek) |
| `FREE_MORE_SPACE` | boolean | `false` | 优化构建空间 |

### 自定义脚本

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `CUSTOM_SCRIPTS` | array | `[]` | 自定义脚本列表 |

#### CUSTOM_SCRIPTS 格式

```json
"CUSTOM_SCRIPTS": [
  {
    "url": "https://raw.githubusercontent.com/user/repo/main/script.sh",
    "description": "脚本描述",
    "execute": true
  },
  {
    "url": "https://example.com/another-script.sh",
    "description": "另一个脚本",
    "execute": true
  }
]
```

- `url`: 脚本的下载地址（必须是可公开访问的 URL）
- `description`: 脚本描述（可选，用于日志输出）
- `execute`: 是否执行脚本（true/false）

#### 使用示例

在配置文件中添加自定义脚本：

```json
{
  "name": "我的设备",
  "CUSTOM_SCRIPTS": [
    {
      "url": "https://raw.githubusercontent.com/myuser/myrepo/main/apply-patches.sh",
      "description": "应用设备特定补丁",
      "execute": true
    }
  ]
}
```

脚本会在编译前下载并执行，如果执行失败不会中断整个构建流程。

---
