<script setup lang="ts">
import { useTranslator } from '@/locales/translator'

const { t } = useTranslator()
</script>

<template>
  <h1 style="text-align: center;">{{ t('layout.header_jumbotron.title') }}</h1>
  <!--<p class="lead">{{ t('layout.header_jumbotron.description') }}</p>-->
</template>
<style></style>