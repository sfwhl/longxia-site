<script setup>
import DefaultTheme from 'vitepress/theme'
import PageStats from '../components/PageStats.vue'

const { Layout } = DefaultTheme
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