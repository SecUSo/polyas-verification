<script setup lang="ts">
import { useTranslator } from '@/locales/translator'
const { t } = useTranslator()
</script>

<template>
  <p class="mb-3">{{ t('view.home_app.no_params') }}</p>
  <p class="mb-3"><a href="https://gi.de/wahlen">{{ t('view.home_app.to_election') }} </a></p>
</template>
