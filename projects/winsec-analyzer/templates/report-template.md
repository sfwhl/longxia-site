# 安全事件分析报告

> **报告 ID**: {{REPORT_ID}}
> **生成时间**: {{GENERATED_AT}}
> **分析师**: {{ANALYST}}
> **事件分类**: {{EVENT_CATEGORY}}

---

## 1. 事件概述

{{EVENT_SUMMARY}}

**事件严重性**: {{SEVERITY}} ⭐
**影响范围**: {{IMPACT_SCOPE}}
**首次发现**: {{FIRST_DETECTED}}
**当前状态**: {{CURRENT_STATUS}}

---

## 2. 时间线

{{TIMELINE}}

---

## 3. 关键证据

### 3.1 文件系统行为

{{FS_EVIDENCE}}

### 3.2 进程行为

{{PROCESS_EVIDENCE}}

### 3.3 注册表行为

{{REGISTRY_EVIDENCE}}

### 3.4 网络行为

{{NETWORK_EVIDENCE}}

### 3.5 系统破坏行为

{{DESTRUCTION_EVIDENCE}}

---

## 4. ATT&CK 映射

| 阶段 | Tactic | Technique ID | Technique 名称 | 证据 |
|------|--------|-------------|---------------|------|
{{ATTACK_MAPPING}}

---

## 5. 可能原因分析

### 5.1 最可能原因（置信度: {{TOP_CAUSE_CONFIDENCE}}）

{{TOP_CAUSE}}

### 5.2 次可能原因

{{SECONDARY_CAUSES}}

---

## 6. 验证命令

⚠️ **人工执行前确认环境，误操作可能导致业务影响**

```bash
{{VERIFICATION_COMMANDS}}
```

---

## 7. 处置建议

### 7.1 紧急处置（30 分钟内）

{{EMERGENCY_RESPONSE}}

### 7.2 短期加固（一周内）

{{SHORT_TERM_HARDENING}}

### 7.3 长期改进

{{LONG_TERM_IMPROVEMENT}}

---

## 8. 加固建议

{{HARDENING_RECOMMENDATIONS}}

---

## 9. 经验沉淀

| 项 | 内容 |
|----|------|
| **威胁家族** | {{THREAT_FAMILY}} |
| **复用价值** | {{REUSE_VALUE}} |
| **可入 YARA** | {{YARA_FEASIBLE}} |
| **可入 EDR 检测** | {{EDR_DETECTION_FEASIBLE}} |

---

## 10. 附件清单

{{ATTACHMENTS}}

---

**报告结束** · 本报告由 **AI 辅助生成 + 人工审核**，最终签字: _______________

> 工具版本: winsec-analyzer v0.1.0
> 方法论: APCDR v2.0 (Analysis → Probe → Correlate → Design → Response)
> 生成时间: {{GENERATED_AT}}
