# Agent Browser Skill 使用指南

`agent-browser` 是一个功能强大的浏览器自动化 skill，来自 Vercel Labs 官方仓库。它提供了一套完整的浏览器交互命令，用于网页测试、表单填写、截图和数据提取。

## 📦 安装

```bash
npx skills add vercel-labs/agent-browser --agent opencode --skill agent-browser
```

## 🚀 快速开始

### 基本工作流程

```bash
# 1. 打开网页
agent-browser open https://example.com

# 2. 获取页面元素（返回可交互元素及其引用 @e1, @e2 等）
agent-browser snapshot -i

# 3. 使用引用与元素交互
agent-browser click @e1
agent-browser fill @e2 "text"

# 4. 关闭浏览器
agent-browser close
```

## 📚 命令详解

### 1. 导航命令

```bash
# 打开网页
agent-browser open <url>              # 支持 https://, http://, file://, about:, data://
agent-browser goto <url>              # 别名
agent-browser navigate <url>          # 别名

# 浏览器导航
agent-browser back                    # 后退
agent-browser forward                 # 前进
agent-browser reload                  # 刷新

# 连接和关闭
agent-browser connect 9222            # 通过 CDP 端口连接到浏览器
agent-browser close                   # 关闭浏览器（别名：quit, exit）
```

### 2. 页面分析（Snapshot）

```bash
# 获取完整的可访问性树
agent-browser snapshot

# 仅获取可交互元素（推荐）
agent-browser snapshot -i

# 紧凑输出
agent-browser snapshot -c

# 限制深度
agent-browser snapshot -d 3

# 限定范围到特定 CSS 选择器
agent-browser snapshot -s "#main"
```

**重要提示**：
- `snapshot -i` 会返回元素引用（如 `@e1`, `@e2`），用于后续交互
- 每次页面导航或 DOM 重大变化后都应重新获取 snapshot

### 3. 元素交互

使用 snapshot 返回的 `@ref` 引用与元素交互：

```bash
# 点击操作
agent-browser click @e1               # 单击
agent-browser dblclick @e1            # 双击

# 输入操作
agent-browser fill @e2 "text"         # 清空后输入
agent-browser type @e2 "text"         # 直接输入（不清空）

# 焦点和悬停
agent-browser focus @e1               # 聚焦元素
agent-browser hover @e1               # 鼠标悬停

# 复选框操作
agent-browser check @e1               # 勾选
agent-browser uncheck @e1             # 取消勾选

# 下拉选择
agent-browser select @e1 "value"      # 选择单个选项
agent-browser select @e1 "a" "b"      # 选择多个选项

# 键盘操作
agent-browser press Enter             # 按键（别名：key）
agent-browser press Control+a         # 组合键
agent-browser keydown Shift           # 按下键
agent-browser keyup Shift             # 释放键

# 滚动操作
agent-browser scroll down 500         # 滚动页面（默认：向下 300px）
agent-browser scrollintoview @e1      # 滚动元素到可见区域（别名：scrollinto）

# 拖拽操作
agent-browser drag @e1 @e2            # 拖拽元素

# 文件上传
agent-browser upload @e1 file.pdf     # 上传文件
```

### 4. 获取信息

```bash
# 元素信息
agent-browser get text @e1            # 获取元素文本
agent-browser get html @e1            # 获取 innerHTML
agent-browser get value @e1           # 获取输入框的值
agent-browser get attr @e1 href       # 获取属性值
agent-browser get box @e1             # 获取边界框
agent-browser get styles @e1          # 获取计算样式（字体、颜色、背景等）

# 页面信息
agent-browser get title               # 获取页面标题
agent-browser get url                 # 获取当前 URL
agent-browser get count ".item"       # 统计匹配元素数量
```

### 5. 状态检查

```bash
agent-browser is visible @e1          # 检查是否可见
agent-browser is enabled @e1          # 检查是否可用
agent-browser is checked @e1          # 检查是否被选中
```

### 6. 截图和 PDF

```bash
# 截图
agent-browser screenshot              # 保存到临时目录
agent-browser screenshot path.png     # 保存到指定路径
agent-browser screenshot @e1          # 截取特定元素

# 生成 PDF
agent-browser pdf                     # 保存到临时目录
agent-browser pdf output.pdf          # 保存到指定路径
```

### 7. JavaScript 执行

```bash
# 在页面上下文中执行脚本
agent-browser eval "document.title"

# 在元素上下文中执行
agent-browser eval @e1 "el => el.classList.add('active')"
```

### 8. 等待操作

```bash
# 等待元素出现
agent-browser wait ".selector"

# 等待指定时间（毫秒）
agent-browser wait 1000

# 等待页面加载
agent-browser wait load

# 等待网络空闲
agent-browser wait networkidle
```

### 9. Cookie 管理

```bash
# 获取所有 cookies
agent-browser cookies

# 设置 cookie
agent-browser cookies set name=value

# 清除所有 cookies
agent-browser cookies clear
```

## 💡 实用示例

### 示例 1：搜索百度

```bash
agent-browser open https://www.baidu.com
agent-browser snapshot -i
agent-browser fill @e1 "OpenCode"
agent-browser click @e2
agent-browser wait 2000
agent-browser screenshot baidu-search.png
agent-browser close
```

### 示例 2：登录表单填写

```bash
agent-browser open https://example.com/login
agent-browser snapshot -i
agent-browser fill @e1 "username@example.com"
agent-browser fill @e2 "password123"
agent-browser click @e3
agent-browser wait load
agent-browser get title
agent-browser close
```

### 示例 3：数据提取

```bash
agent-browser open https://news.ycombinator.com
agent-browser snapshot -i
agent-browser eval "Array.from(document.querySelectorAll('.titleline > a')).map(a => ({title: a.textContent, url: a.href}))"
agent-browser close
```

### 示例 4：截图和 PDF 生成

```bash
agent-browser open https://github.com
agent-browser wait networkidle
agent-browser screenshot github-homepage.png
agent-browser pdf github-homepage.pdf
agent-browser close
```

## 🎯 最佳实践

### 1. 始终使用 snapshot -i
在交互前总是使用 `snapshot -i` 获取元素引用，这比使用选择器更可靠。

### 2. 适时重新获取 snapshot
当页面导航或 DOM 发生重大变化后，记得重新运行 snapshot。

### 3. 使用 wait 命令
在操作前等待元素或页面加载完成，避免因元素未就绪而失败。

### 4. 处理动态内容
对于 AJAX 加载的内容，使用 `wait networkidle` 等待网络请求完成。

### 5. 保存截图以便调试
在关键步骤后截图，方便排查问题。

## ⚠️ 注意事项

1. **权限**：确保有权访问目标网站
2. **速率限制**：避免过快请求导致被封禁
3. **隐私**：不要在截图中暴露敏感信息
4. **资源**：浏览器操作消耗资源，完成后及时关闭
5. **合法性**：遵守网站的 robots.txt 和服务条款

## 🔗 相关资源

- [agent-browser GitHub 仓库](https://github.com/vercel-labs/agent-browser)
- [Vercel Agent Skills](https://github.com/vercel-labs/agent-skills)
- [Skills CLI 文档](https://skills.sh/)

## 🆚 与 browser-automation skill 的对比

| 特性 | agent-browser | browser-automation (Puppeteer) |
|------|---------------|--------------------------------|
| 命令方式 | CLI 命令 | MCP 工具调用 |
| 元素引用 | 使用 @ref | 使用 CSS 选择器 |
| 学习曲线 | 更简单直观 | 需要了解 Puppeteer API |
| 功能完整性 | 专注核心功能 | 更底层、更灵活 |
| 适用场景 | 快速自动化任务 | 复杂的浏览器控制 |

## 📄 许可证

本指南基于 MIT 许可证发布。