# Kimi Code 配额挂件 for SAO Utils 2

在 SAO Utils 2 桌面直接显示 Kimi Code 使用量配额。

## 功能特点

- 美观的深色主题界面
- 每周用量和速率限制进度条
- 颜色编码指示器（绿色/黄色/红色）
- 自动刷新（可配置间隔）
- 状态指示灯
- 使用官方 Kimi API

## 安装要求

1. SAO Utils 2
2. [Kimi CLI](https://github.com/MoonshotAI/kimi-cli) 已安装并登录

## 安装步骤

### 第一步：安装 Kimi CLI

打开Poweshell并运行：
```bash
irm https://code.kimi.com/install.ps1 | iex
kimi login
```

按提示完成登录。

### 第二步：安装挂件

1. 复制 `kimi-code-quota` 文件夹到 SAO Utils 2 的 Packages 目录：
   ```
   C:\Program Files\SAO Utils 2\Packages\
   ```
2. 重启 SAO Utils 2

### 第三步：使用挂件

1. 将挂件添加到桌面
2. 点击刷新按钮获取配额数据
3. 挂件会自动读取 Kimi CLI 的登录凭证

## 工作原理

挂件使用官方 Kimi API：
1. 从 `~/.kimi/credentials/kimi-code.json` 读取访问令牌
2. 调用 `https://api.kimi.com/coding/v1/usages` API
3. 在挂件上显示配额数据

无需浏览器自动化！

## 故障排除

### "错误: 请先运行 'kimi login'"

需要先在终端中登录 Kimi CLI：
```bash
kimi login
```

### "错误: 无数据" 或显示 0%

1. 确认 `kimi login` 已成功完成
2. 检查 `~/.kimi/credentials/kimi-code.json` 文件是否存在
3. 尝试再次点击刷新

### 数据不更新

- 检查设置中的自动刷新间隔
- 手动点击刷新强制更新

## 技术细节

- 使用 Kimi 官方 API（与 KimiQuota macOS 应用相同）
- 令牌存储位置：`%USERPROFILE%\.kimi\credentials\kimi-code.json`
- 无需外部 Python 依赖（使用标准库）
- 自动刷新间隔可在设置中配置

## 界面说明

| 图标 | 含义 |
|------|------|
| \u263d | Kimi 图标 |
| \u1f4c5 | 每周用量 |
| \u23f0 | 速率限制 |
| \u21bb | 刷新按钮 |
| 绿色指示灯 | 已连接 |
| 黄色指示灯 | 加载中 |
| 红色指示灯 | 未登录 |

## 颜色说明

- **绿色/青色**: 用量正常 (<50%)
- **黄色**: 用量中等 (50-80%)
- **红色/粉色**: 用量较高 (>80%)

## 致谢

- 灵感来源于 [KimiQuota](https://github.com/Dominic789654/KimiQuota) macOS 应用
- 使用相同的 API 方法
