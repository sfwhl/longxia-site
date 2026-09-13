# /home/ubuntu/.hermes/longxia/notes/sop/trigger-keywords.md
# 自动触发的关键词列表
# AI 在检测到小龙说这些词时，必须先发 SOP

# 开发相关触发词
TRIGGER_KEYWORDS = [
    "开发", "实现", "写个", "帮我写", "调研", "我要做",
    "做个新功能", "新模块", "添加功能", "增加",
    "写代码", "编码", "落地", "实现一下", "做个",
    "改个", "新增", "加一个", "新加",
    "develop", "implement", "code", "module",
]

# 触发后 AI 必须做的：
# 1. 第一轮回复必须包含 SOP 提示
# 2. 询问 4 个前置问题：
#    - 这个功能你之前接触过吗？
#    - 需求文档/用户场景/验收标准 是什么？
#    - 你当前对相关代码的理解深度？
#    - TL 评审过吗？
# 3. 在 AI 理解这些之前，不进入方案设计

SOP_FILE = "~/.hermes/longxia/notes/sop/dev-sop-2026-07-23.md"