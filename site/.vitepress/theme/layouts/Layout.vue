<script setup>
import DefaultTheme from 'vitepress/theme'
import PageStats from '../components/PageStats.vue'
import { onMounted } from 'vue'

const { Layout } = DefaultTheme

// 强制暗色模式（终端美学）
onMounted(() => {
  if (typeof document !== 'undefined') {
    document.documentElement.classList.add('dark')
    // 同时移除 light 类（如果存在）
    document.documentElement.classList.remove('light')
    // 持久化到 localStorage
    try {
      localStorage.setItem('vitepress-theme-preference', 'dark')
    } catch (e) {}
  }
})
</script>

<template>
  <Layout>
    <!-- 文档页底部（在 VPDocFooter 之前）插入统计 -->
    <template #doc-footer-before>
      <PageStats />
    </template>

    <!-- 首页底部（在 Features 之后）插入统计 -->
    <template #home-features-after>
      <PageStats />
    </template>
  </Layout>
</template>

<style>
/* Layout 自身不需要样式 */
</style>