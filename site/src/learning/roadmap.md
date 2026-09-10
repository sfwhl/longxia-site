# 🎓 Go + Windows 驱动开发学习计划

> 终端安全开发工程师（C++ 背景）转型到 应用层 Go + 驱动层 C++ 路线
> 每天中午 1 篇，**等你学完再推下一篇**（不催进度）

## 📋 学员画像

| 项 | 现状 |
|---|------|
| 语言背景 | **C++ 强**（驱动开发），Go **了解但不熟练** |
| 工作场景 | 终端安全产品（EPP/EDR 类的应用层 + 驱动） |
| 工作内容 | **应用层 Go**（业务逻辑）+ **驱动 C++**（内核 hook/过滤）|
| 学习时间 | **每天中午**（约 1-2 小时）|
| 学习目标 | 保持手感 → 快速掌握 Go + Windows 驱动 + 软件逆向 |
| 实操倾向 | ✅ 喜欢贴近实战的示例 |

## 🎯 学习路径（4 个阶段）

### 阶段 1：Go 速成（C++ 程序员视角） — 2 周
**目标**：能看懂 Go 项目代码，能写简单的 CLI 工具

- 1.1 Go 基础语法（变量/函数/控制流）— 30 min
- 1.2 Go 与 C++ 的关键差异（slice/map/goroutine/interface）
- 1.3 Go 错误处理哲学（error vs C++ exception）
- 1.4 第一个完整 Go 程序：文件扫描器
- 1.5 Go module 与依赖管理
- 1.6 标准库入门：io、os、strings
- 1.7 综合练习：写一个进程查看器（仿 tasklist）

### 阶段 2：Go 进阶（贴近终端安全） — 3 周
**目标**：能用 Go 写终端安全工具，理解系统调用

- 2.1 进程与线程 API（Windows + Linux 跨平台）
- 2.2 文件系统监控（fsnotify）
- 2.3 网络编程（TCP/UDP/HTTP client）
- 2.4 Windows API 调用（syscall、golang.org/x/sys/windows）
- 2.5 ETW (Event Tracing for Windows) 消费
- 2.6 Sysmon 类似的进程行为监控
- 2.7 综合项目：写一个简易 HIDS

### 阶段 3：Windows 驱动开发（C++ 强化） — 3 周
**目标**：能维护现有驱动代码，理解 WDM/WDF 框架

- 3.1 Windows 内核架构（ring 0/3、SSDT、IDT、GDT）
- 3.2 驱动模型（WDM vs WDF vs minifilter）
- 3.3 第一个驱动：Hello World
- 3.4 IRP 处理（I/O Request Packets）
- 3.5 设备对象与符号链接
- 3.6 进程/线程回调（PsSetCreateProcessNotifyRoutine）
- 3.7 文件系统 minifilter（文件操作拦截）
- 3.8 驱动通信（DeviceIoControl）
- 3.9 综合项目：写一个文件监控 minifilter

### 阶段 4：软件逆向（实战） — 4 周
**目标**：能分析恶意软件，理解常见保护

- 4.1 x86/x64 汇编基础（与 ARM 对比）
- 4.2 PE 文件结构（节、表、导入导出）
- 4.3 静态分析工具（IDA、Ghidra、Binary Ninja）
- 4.4 动态分析工具（x64dbg、WinDbg）
- 4.5 API 监控（API Monitor、Frida）
- 4.6 反调试技术
- 4.7 常见壳（UPX、VMProtect、Themida）
- 4.8 实战：分析一个真实样本
- 4.9 实战：编写一个简单的 keygen/POC

## 🛠️ 实操环境

| 工具 | 用途 | 备注 |
|------|------|------|
| Go 1.21+ | 应用层 | 已通过 skillhub 可装 `superpowers` 辅助 |
| VS2022 + WDK | 驱动开发 | 需要 Windows 环境 |
| IDA Free / Ghidra | 静态分析 | Ghidra 免费开源 |
| x64dbg | 动态调试 | 免费开源 |
| WinDbg | 内核调试 | Windows SDK 自带 |
| WSL2 | Linux 兼容（部分 Go 工具） | 已可用？ |

## 📁 目录结构

```
~/.hermes/longxia/learning/go-driver/
├── plan/
│   └── roadmap.md            ← 本文
├── lessons/                  ← 预备好的所有课
│   ├── 01-go-basics.md
│   ├── 02-go-vs-cpp.md
│   ├── ...
│   └── 30-reverse-poc.md
├── in-progress/              ← 当前在学（软链）
│   └── 01-go-basics.md → ../lessons/01-go-basics.md
├── completed/                ← 已完成
│   ├── 01-go-basics.done
│   └── ...
└── .current                  ← 记录当前进度（文件名）
```

## ⏯️ 推送机制

- **不自动推送**：你说"学完了" → 我才推下一篇
- **手动确认**：每次推新课时，我等你回 "学完了"
- **可跳课**：你想看哪篇直接说"看 2.5"

## 📝 推送命令

```bash
# 你学完一篇后，告诉我
"学完了"

# 我会：
# 1. 把当前课移到 completed/
# 2. 检查下一课是否就绪
# 3. 提示下一课内容 + 把链接发给你
```

## 🎁 实战导向

每篇都包含：
- **概念讲解**（10-15 分钟阅读）
- **代码示例**（可运行的完整代码）
- **贴近实战的 demo**（如：写文件、读进程、调 ETW）
- **练习题**（巩固）

**绝不写"Hello World 教程"**——直接进入终端安全场景。
