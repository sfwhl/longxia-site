<template>
  <div class="page-stats">
    <span class="stat-item">
      👁️ 阅读量 <span id="busuanzi_value_page_pv">--</span>
    </span>
    <span class="stat-divider">·</span>
    <span class="stat-item">
      👤 访客数 <span id="busuanzi_value_site_uv">--</span>
    </span>
  </div>
</template>

<script setup>
</script>

<style scoped>
.page-stats {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 12px;
  padding: 16px;
  margin-top: 24px;
  font-size: 14px;
  color: var(--vp-c-text-2);
  border-top: 1px solid var(--vp-c-divider);
}

.stat-item {
  display: inline-flex;
  align-items: center;
  gap: 4px;
}

.stat-divider {
  color: var(--vp-c-divider);
}
</style>
