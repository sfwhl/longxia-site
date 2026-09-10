---
lesson: 1
title: Go 基础语法（C++ 程序员视角）
duration: 30 分钟
phase: 1.1
---

# 📘 第 1 课：Go 基础语法（C++ 程序员视角）

## 🎯 目标

- 30 分钟读完后能写简单的 Go 程序
- 重点：**和 C++ 对比**，不重复讲编程基础

## 1. 第一个 Go 程序

```go
// 文件：hello.go
package main

import "fmt"

func main() {
    fmt.Println("Hello, 小龙!")
}
```

**运行**：`go run hello.go`

**对比 C++**：
- 没有 `.h` / `.cpp` 分离
- `package main` = "这是可执行程序的入口"
- 没有 `using namespace std;` —— 简洁，但需要明确 import

## 2. 变量声明（4 种方式）

```go
// 方式 1：完整声明
var name string = "小龙"

// 方式 2：类型推导（最常用）
var name = "小龙"

// 方式 3：函数内短变量（最最常用）
name := "小龙"

// 方式 4：批量声明
var (
    a int = 1
    b string = "hi"
    c bool = true
)
```

**对比 C++**：
- `:=` 是 C++ 没有的——**自动类型推导 + 声明 + 赋值** 一行搞定
- 没有 `int*` 这种指针类型混乱
- 没有引用 `&` —— Go 默认就是值传递，**指针要显式说**

## 3. 基础类型

| Go | C++ | 区别 |
|---|---|------|
| `int` | `int` (32/64) | Go 的 int 在不同平台不同（**int 不是 int32**）|
| `int32`, `int64` | `int32_t`, `int64_t` | Go 必须显式说明位数 |
| `float64` | `double` | Go 默认是 float64（不是 float32）|
| `string` | `std::string` | Go 字符串**不可变** |
| `bool` | `bool` | 一致 |
| `byte` | `uint8_t` | 别名 |
| `rune` | `char` (但 Go 是 int32) | 别名，处理 Unicode |

```go
var (
    i   int     = 42
    f   float64 = 3.14
    s   string  = "终端安全"
    b   bool    = true
    by  byte    = 'A'      // = 65
    r   rune    = '中'      // = 20013
)
```

**实战注意**：终端安全场景里**几乎只用 `int` 和 `string`**——位精确需求用 `int32/uint32`。

## 4. 控制流

```go
// if-else（和 C++ 类似但不用括号）
if x > 0 {
    fmt.Println("positive")
} else if x < 0 {
    fmt.Println("negative")
} else {
    fmt.Println("zero")
}

// if 初始化（很常用）
if err := doSomething(); err != nil {
    fmt.Println("error:", err)
}

// for（Go 只有 for，没有 while/do-while）
for i := 0; i < 10; i++ {
    fmt.Println(i)
}

// while 风格
i := 0
for i < 10 {
    fmt.Println(i)
    i++
}

// 无限循环
for {
    // ...
    break  // 退出
}

// range（遍历）
for i, v := range []int{1, 2, 3} {
    fmt.Println(i, v)  // 索引 + 值
}

// switch（不用 break，Go 自动 break）
switch day {
case "Monday":
    fmt.Println("周一")
case "Friday":
    fmt.Println("周五")
default:
    fmt.Println("其他")
}
```

**对比 C++**：
- `if`/`for` **不用括号**（Go 的设计哲学）
- `for range` 是 C++ 的 range-for 增强版
- `switch` **自动 break**——不会 fall through（C++ 要 `break` 否则会 fall through！）

## 5. 函数

```go
// 基本函数
func add(a, b int) int {
    return a + b
}

// 多返回值（Go 标志性特性）
func div(a, b int) (int, error) {
    if b == 0 {
        return 0, errors.New("除数不能为 0")
    }
    return a / b, nil
}

// 调用
result, err := div(10, 2)
if err != nil {
    fmt.Println("错误:", err)
    return
}
fmt.Println(result)
```

**对比 C++**：
- C++ 用 `std::pair<int, std::optional<int>>` 或异常
- Go 直接 `(int, error)` —— **错误处理是 Go 设计的核心**

## 6. 数组 vs Slice（重要！）

```go
// 数组（固定大小）
var arr [5]int           // [0, 0, 0, 0, 0]
arr := [3]string{"a", "b", "c"}

// slice（动态数组，**最常用**）
s := []int{1, 2, 3}     // 创建
s = append(s, 4)          // 追加
fmt.Println(s[1:3])      // 切片 [2, 3]
fmt.Println(len(s))      // 长度 4
```

**对比 C++**：
- C++ `std::vector` ≈ Go `slice`
- **但** Go 的 slice 是**传引用**（共享底层数组）
- 这经常导致**隐藏的 bug**（一个 slice 修改影响另一个）

**实战陷阱**：
```go
a := []int{1, 2, 3}
b := a[:2]        // b = [1, 2]
b[0] = 999         // a 也变成 [999, 2, 3]！！！
fmt.Println(a)     // [999 2 3]
```

## 7. Map（哈希表）

```go
m := make(map[string]int)
m["进程"] = 1234
m["线程"] = 5678

if v, ok := m["进程"]; ok {
    fmt.Println("找到:", v)
}

delete(m, "线程")  // 删除
```

**对比 C++**：
- C++ `std::unordered_map` ≈ Go `map`
- Go 的 `value, ok := m[key]` 是**最 Pythonic 的写法**

## 8. 指针（Go 的简化版）

```go
x := 42
p := &x      // p 是 *int
fmt.Println(*p)  // 42
*p = 100       // x 变成 100

// 没有指针运算！
p++  // 编译错误！Go 不允许
```

**对比 C++**：
- 没有 `->`，统一用 `.`
- 没有指针运算（安全，但 C++ 程序员会想哭）
- 没有引用 `&`（除了 `&x` 取地址）
- 没有 `nullptr`，用 `nil`

## 9. defer（延迟执行）

```go
func readFile(path string) error {
    f, err := os.Open(path)
    if err != nil {
        return err
    }
    defer f.Close()  // 函数返回前自动调用

    // 读文件...
    return nil
}
```

**对比 C++**：
- C++ 用 RAII（析构函数自动释放）
- Go 用 `defer` 关键字（C++ 程序员会觉得"哦原来如此"）

## 10. 结构体（替代 C++ class）

```go
type Process struct {
    PID  int
    Name string
    Path string
}

p := Process{PID: 1234, Name: "explorer.exe", Path: "C:\\Windows\\"}
fmt.Println(p.PID)

// 方法（接收器，替代成员函数）
func (p Process) IsSystem() bool {
    return strings.HasPrefix(p.Path, "C:\\Windows\\")
}

// 指针接收器（修改原对象）
func (p *Process) Rename(newName string) {
    p.Name = newName
}
```

**对比 C++**：
- Go **没有 class**，**没有继承**，**没有构造函数**
- Go 用 **方法 + 接口** 实现面向对象
- **值接收器** vs **指针接收器**——C++ 程序员会纠结

**实战建议**：终端安全的 Process 结构体，**用指针接收器**（避免拷贝大字符串）。

## 🎯 实战练习（10 分钟）

**任务**：写一个 Go 程序 `process_scanner.go`：
1. 列出当前进程（用 `os.Args[0]` 模拟）
2. 用结构体 `Process` 存 PID + Name
3. 用 map 存多个进程
4. 用 `defer` 确保清理

**参考骨架**：
```go
package main

import "fmt"

type Process struct {
    PID  int
    Name string
}

func main() {
    procs := make(map[int]Process)

    // TODO: 模拟 3 个进程
    procs[1234] = Process{PID: 1234, Name: "svchost.exe"}
    procs[5678] = Process{PID: 5678, Name: "explorer.exe"}

    defer fmt.Println("扫描结束")

    // TODO: 遍历打印
    for pid, p := range procs {
        fmt.Printf("PID=%d Name=%s\n", pid, p.Name)
    }
}
```

**你的任务**：
1. 运行 `go run process_scanner.go` 看输出
2. 加一个新进程
3. 改成方法 `func (p Process) String() string` 让 `fmt.Println(p)` 直接打印

## 📚 关键 takeaway

| C++ 习惯 | Go 习惯 |
|---------|---------|
| `int x;` 先声明后赋值 | `x := 0` 一行搞定 |
| `std::vector<int>` | `[]int`（slice）|
| 异常 `try/catch` | 多返回值 `result, err` |
| `class` + 继承 | `struct` + 方法 + 接口 |
| 析构函数 RAII | `defer` |
| `nullptr` | `nil` |
| `printf("%d", x)` | `fmt.Printf("%d", x)` |

## ⏭️ 下一课预告

**第 2 课：Go 与 C++ 的关键差异（深度版）**
- slice 的内存模型
- interface 是什么
- goroutine vs std::thread
- channel vs C++ queue
- 错误处理的哲学差异

---

**学完这篇后说 "学完了"，我推第 2 课。**