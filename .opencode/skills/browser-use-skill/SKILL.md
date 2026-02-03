---
name: browser-use
description: Automates browser interactions for web testing, form filling, screenshots, and data extraction. Use when the user needs to navigate websites, interact with web pages, fill forms, take screenshots, or extract information from web pages.
allowed-tools: Bash(browser-use:*)
---

# Browser Automation with browser-use CLI

The `browser-use` command provides fast, persistent browser automation. It maintains browser sessions across commands, enabling complex multi-step workflows.

## Quick Start

```bash
browser-use open https://example.com           # Navigate to URL
browser-use state                              # Get page elements with indices
browser-use click 5                            # Click element by index
browser-use type "Hello World"                 # Type text
browser-use screenshot                         # Take screenshot
browser-use close                              # Close browser
```

## Core Workflow

1. **Navigate**: `browser-use open <url>` - Opens URL (starts browser if needed)
2. **Inspect**: `browser-use state` - Returns clickable elements with indices
3. **Interact**: Use indices from state to interact (`browser-use click 5`, `browser-use input 3 "text"`)
4. **Verify**: `browser-use state` or `browser-use screenshot` to confirm actions
5. **Repeat**: Browser stays open between commands

## Browser Modes

```bash
browser-use --browser chromium open <url>      # Default: headless Chromium
browser-use --browser chromium --headed open <url>  # Visible Chromium window
browser-use --browser real open <url>          # User's Chrome with login sessions
browser-use --browser remote open <url>        # Cloud browser (requires API key)
```

- **chromium**: Fast, isolated, headless by default
- **real**: Uses your Chrome with cookies, extensions, logged-in sessions
- **remote**: Cloud-hosted browser with proxy support (requires BROWSER_USE_API_KEY)

## Commands

### Navigation
```bash
browser-use open <url>                    # Navigate to URL
browser-use back                          # Go back in history
browser-use scroll down                   # Scroll down
browser-use scroll up                     # Scroll up
```

### Page State
```bash
browser-use state                         # Get URL, title, and clickable elements
browser-use screenshot                    # Take screenshot (outputs base64)
browser-use screenshot path.png           # Save screenshot to file
browser-use screenshot --full path.png    # Full page screenshot
```

### Interactions (use indices from `browser-use state`)
```bash
browser-use click <index>                 # Click element
browser-use type "text"                   # Type text into focused element
browser-use input <index> "text"          # Click element, then type text
browser-use keys "Enter"                  # Send keyboard keys
browser-use keys "Control+a"              # Send key combination
browser-use select <index> "option"       # Select dropdown option
```

### Tab Management
```bash
browser-use switch <tab>                  # Switch to tab by index
browser-use close-tab                     # Close current tab
browser-use close-tab <tab>               # Close specific tab
```

### JavaScript & Data
```bash
browser-use eval "document.title"         # Execute JavaScript, return result
browser-use extract "all product prices"  # Extract data using LLM (requires API key)
```

### Python Execution (Persistent Session)
```bash
browser-use python "x = 42"               # Set variable
browser-use python "print(x)"             # Access variable (outputs: 42)
browser-use python "print(browser.url)"   # Access browser object
browser-use python --vars                 # Show defined variables
browser-use python --reset                # Clear Python namespace
browser-use python --file script.py       # Execute Python file
```

The Python session maintains state across commands. The `browser` object provides:
- `browser.url` - Current page URL
- `browser.title` - Page title
- `browser.goto(url)` - Navigate
- `browser.click(index)` - Click element
- `browser.type(text)` - Type text
- `browser.screenshot(path)` - Take screenshot
- `browser.scroll()` - Scroll page
- `browser.html` - Get page HTML

### Agent Tasks (Requires API Key)
```bash
browser-use run "Fill the contact form with test data"    # Run AI agent
browser-use run "Extract all product prices" --max-steps 50
```

Agent tasks use an LLM to autonomously complete complex browser tasks. Requires `BROWSER_USE_API_KEY` or configured LLM API key (OPENAI_API_KEY, ANTHROPIC_API_KEY, etc).

### Session Management
```bash
browser-use sessions                      # List active sessions
browser-use close                         # Close current session
browser-use close --all                   # Close all sessions
```

### Server Control
```bash
browser-use server status                 # Check if server is running
browser-use server stop                   # Stop server
browser-use server logs                   # View server logs
```

## Global Options

| Option | Description |
|--------|-------------|
| `--session NAME` | Use named session (default: "default") |
| `--browser MODE` | Browser mode: chromium, real, remote |
| `--headed` | Show browser window (chromium mode) |
| `--profile NAME` | Chrome profile (real mode only) |
| `--json` | Output as JSON |
| `--api-key KEY` | Override API key |

**Session behavior**: All commands without `--session` use the same "default" session. The browser stays open and is reused across commands. Use `--session NAME` to run multiple browsers in parallel.

## Examples

### Form Submission
```bash
browser-use open https://example.com/contact
browser-use state
# Shows: [0] input "Name", [1] input "Email", [2] textarea "Message", [3] button "Submit"
browser-use input 0 "John Doe"
browser-use input 1 "john@example.com"
browser-use input 2 "Hello, this is a test message."
browser-use click 3
browser-use state  # Verify success
```

### Multi-Session Workflows
```bash
browser-use --session work open https://work.example.com
browser-use --session personal open https://personal.example.com
browser-use --session work state    # Check work session
browser-use --session personal state  # Check personal session
browser-use close --all             # Close both sessions
```

### Data Extraction with Python
```bash
browser-use open https://example.com/products
browser-use python "
products = []
for i in range(20):
    browser.scroll('down')
browser.screenshot('products.png')
"
browser-use python "print(f'Captured {len(products)} products')"
```

### Using Real Browser (Logged-In Sessions)
```bash
browser-use --browser real open https://gmail.com
# Uses your actual Chrome with existing login sessions
browser-use state  # Already logged in!
```

## Tips

1. **Always run `browser-use state` first** to see available elements and their indices
2. **Use `--headed` for debugging** to see what the browser is doing
3. **Sessions persist** - the browser stays open between commands
4. **Use `--json` for parsing** output programmatically
5. **Python variables persist** across `browser-use python` commands within a session
6. **Real browser mode** preserves your login sessions and extensions

## Troubleshooting

**Browser won't start?**
```bash
browser-use server stop               # Stop any stuck server
browser-use --headed open <url>       # Try with visible window
```

**Element not found?**
```bash
browser-use state                     # Check current elements
browser-use scroll down               # Element might be below fold
browser-use state                     # Check again
```

**Session issues?**
```bash
browser-use sessions                  # Check active sessions
browser-use close --all               # Clean slate
browser-use open <url>                # Fresh start
```

## Cleanup

**Always close the browser when done.** Run this after completing browser automation:

```bash
browser-use close
```

---

## Template-Based Execution (省 Token 模式)

当用户指定使用某个模版执行任务时，可以参考之前保存的执行历史，减少探索和思考的 token 消耗。

### 模版目录

```
/Users/jinyan1/Desktop/opencode-browser-automation/browser-templates/
```

### 工作流程

#### 1. 首次执行任务 - 保存模版

正常执行 browser-use 任务，完成后将执行步骤保存为模版：

```bash
# 执行任务（正常流程）
browser-use open https://example.com
browser-use state
browser-use click 5
browser-use input 3 "test"
browser-use close
```

任务完成后，如果用户要求保存模版，将执行过的命令序列保存到模版文件：

```bash
# 保存模版到文件
cat > /Users/jinyan1/Desktop/opencode-browser-automation/browser-templates/<模版名>.json << 'EOF'
{
  "name": "<模版名>",
  "task": "<任务描述>",
  "created_at": "<时间戳>",
  "steps": [
    {"command": "open", "args": ["https://example.com"], "note": "打开网站"},
    {"command": "state", "args": [], "note": "获取页面状态"},
    {"command": "click", "args": ["5"], "note": "点击搜索按钮"},
    {"command": "input", "args": ["3", "test"], "note": "输入搜索内容"},
    {"command": "close", "args": [], "note": "关闭浏览器"}
  ]
}
EOF
```

#### 2. 使用模版执行任务 - 省 Token

当用户要求使用模版执行时：

1. **读取模版文件**获取之前的执行步骤
2. **参考模版步骤**快速执行，跳过探索过程
3. **直接按步骤执行**，仅在必要时调整（如元素索引变化）

```bash
# 读取模版
cat /Users/jinyan1/Desktop/opencode-browser-automation/browser-templates/<模版名>.json

# 按模版步骤执行（跳过思考，直接执行）
browser-use open https://example.com
browser-use click 5  # 参考模版，直接点击
browser-use input 3 "test"  # 参考模版，直接输入
browser-use close
```

### 模版格式

```json
{
  "name": "login_task",
  "task": "登录网站",
  "created_at": "2026-02-02T10:00:00Z",
  "steps": [
    {
      "command": "open",
      "args": ["https://example.com/login"],
      "note": "打开登录页"
    },
    {
      "command": "state",
      "args": [],
      "note": "获取表单元素"
    },
    {
      "command": "input",
      "args": ["0", "username"],
      "note": "输入用户名到第一个输入框"
    },
    {
      "command": "input", 
      "args": ["1", "password"],
      "note": "输入密码到第二个输入框"
    },
    {
      "command": "click",
      "args": ["2"],
      "note": "点击登录按钮"
    }
  ]
}
```

### 使用模版的关键原则

1. **有模版时**：直接按模版步骤执行，不需要先 `state` 分析
2. **元素索引变化**：如果执行失败，用 `state` 检查并调整索引
3. **保存新模版**：用户要求时才保存，记录所有执行的命令

### 何时使用模版

- ✅ 用户明确要求"使用模版 xxx 执行"
- ✅ 重复性任务（每日签到、定期检查等）
- ✅ 页面结构稳定的操作
- ❌ 首次探索性任务
- ❌ 用户未指定模版时

### Token 节省原理

| 执行方式 | Token 消耗 | 原因 |
|---------|-----------|------|
| 无模版 | 高 | 需要 state 分析页面、思考决策 |
| 有模版 | **低** | 直接执行已知步骤，跳过分析 |