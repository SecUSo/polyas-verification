<script setup lang="ts">

import { useTranslator } from '@/locales/translator'



const { t } = useTranslator()



</script>

<template>
    <div>
        <p class="text-body-emphasis mb-2">{{ t('action.take_survey.explanation') }}</p>
        <a href="">{{ t('action.take_survey.to_survey') }}</a>

    </div>
</template>
