<script setup lang="ts">

import { useTranslator } from '@/locales/translator'



const { t } = useTranslator()



</script>

<template>
    <div>
        <p class="text-body-emphasis mb-2">{{ t('action.take_survey.explanation') }}</p>
        <p class="btn btn-primary w-100" :href="receiptHref" download @click="downloaded()">
            {{ t('action.take_survey.to_survey') }}
        </p>

    </div>
</template>
