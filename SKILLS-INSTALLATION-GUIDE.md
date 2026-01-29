# OpenCode 远程 Skill 安装指南

本指南将介绍如何使用 `skills` CLI 工具来安装和管理远程 OpenCode skills，类似于 npm 包的管理方式。

## 📦 前置条件

确保您已安装 Node.js 和 npm。如果没有，请访问 [Node.js 官网](https://nodejs.org/) 下载并安装。

## 🚀 快速开始

### 1. 安装 skills CLI 工具

`skills` CLI 工具是一个通用的 agent skills 管理工具，支持多个 AI 助手，包括 OpenCode。

```bash
# 直接使用 npx 运行（推荐）
npx skills --help
```

### 2. 安装 agent-browser 执行器

`agent-browser` skill 需要安装实际的浏览器执行器才能工作：

```bash
# 全局安装 agent-browser CLI 工具
npm install -g agent-browser

# 或使用 npx 运行（无需安装）
npx agent-browser --help
```

**注意**：虽然可以通过 `npx` 运行，但全局安装可以提高执行速度并避免每次下载。

### 2. 搜索可用的远程 skills

```bash
# 交互式搜索
npx skills find

# 按关键词搜索
npx skills find "web design"

# 搜索特定仓库中的 skills
npx skills add vercel-labs/agent-skills --agent opencode --list
```

### 3. 安装远程 skill

```bash
# 安装特定 skill 到 OpenCode 项目
npx skills add vercel-labs/agent-skills --agent opencode --skill web-design-guidelines

# 安装多个 skills
npx skills add vercel-labs/agent-skills --agent opencode --skill web-design-guidelines vercel-react-best-practices

# 安装所有 skills
npx skills add vercel-labs/agent-skills --agent opencode --all
```

## 📁 项目结构

安装的 skills 会自动放置在以下目录中：

```
.opencode/
└── skills/
    ├── agent-browser/              # 本地 skill
    ├── browser-automation/         # 本地 skill
    └── web-design-guidelines/      # 远程安装的 skill (符号链接)
```

## 🎯 常用命令

### 搜索和发现

```bash
# 交互式搜索
npx skills find

# 搜索特定关键词
npx skills find "react"

# 列出仓库中的所有 skills（不安装）
npx skills add vercel-labs/agent-skills --agent opencode --list
```

### 安装和管理

```bash
# 安装特定 skill
npx skills add vercel-labs/agent-skills --agent opencode --skill skill-name

# 更新所有 skills
npx skills update

# 检查可用更新
npx skills check

# 生成锁文件
npx skills generate-lock
```

### 项目初始化

```bash
# 初始化新的 skill 项目
npx skills init my-new-skill
```

## 🌟 推荐的远程 Skill 仓库

### 1. Vercel Labs Agent Skills
```bash
# 安装 Vercel 的 Web 设计指南 skill
npx skills add vercel-labs/agent-skills --agent opencode --skill web-design-guidelines

# 安装 React 最佳实践 skill
npx skills add vercel-labs/agent-skills --agent opencode --skill vercel-react-best-practices

# 安装强大的浏览器自动化 skill
npx skills add vercel-labs/agent-browser --agent opencode --skill agent-browser
```

### 2. 其他推荐仓库
- `vercel-labs/skills` - 包含 find-skills 等基础工具
- `quuu/agent-skills` - 社区维护的 skills 集合

## ⚙️ 高级配置

### 全局安装
```bash
# 全局安装 skill（用户级别）
npx skills add vercel-labs/agent-skills --global --skill web-design-guidelines
```

### 自定义安装选项
```bash
# 跳过确认提示
npx skills add vercel-labs/agent-skills --agent opencode --skill web-design-guidelines --yes

# 预览安装（不实际执行）
npx skills add vercel-labs/agent-skills --agent opencode --skill web-design-guidelines --dry-run
```

## 🛠️ 故障排除

### 1. Skill 未被识别

确保 skill 安装在 `.opencode/skills/` 目录下，并且包含正确的 `SKILL.md` 文件。

### 2. 权限问题

如果遇到权限问题，请确保项目目录有正确的读写权限。

### 3. 网络问题

如果无法克隆远程仓库，请检查网络连接或尝试使用 HTTPS 代理。

## 📚 相关资源

- [Skills CLI GitHub 仓库](https://github.com/vercel-labs/skills)
- [OpenCode 官方文档](https://opencode.ai/docs/)
- [Vercel Agent Skills 仓库](https://github.com/vercel-labs/agent-skills)

## 🤝 贡献

如果您创建了新的 skills，可以通过以下方式分享：

1. 将 skill 发布到 GitHub 仓库
2. 确保包含 `SKILL.md` 文件
3. 提交到 skills 生态系统注册表

## 📄 许可证

本指南基于 MIT 许可证发布。