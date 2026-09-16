<script setup lang="ts" generic="T extends string">

import type { Status } from '@/components/domain/Status'
import { useTranslator } from '@/locales/translator'

const props = defineProps<{
    result?: Status
    errorOrder: T[]
    fallbackError: T
    prefix: string
}>()

const errorKnown = props.result && props.errorOrder.includes(props.result.error as T)
const { t } = useTranslator()
const entry = errorKnown ? props.result?.error : props.fallbackError
const entryPrefix = `${props.prefix}.${entry}`
</script>

<template>
    <p class="mb-0">
        <b>{{ t(`${entryPrefix}.failed`) }}</b>
        {{ t(`${entryPrefix}.impact`) }}
    </p>
</template>
