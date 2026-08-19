<script setup lang="ts">
import BallotsView from '@/components/view/BallotsView.vue'
import { useTranslator } from '@/locales/translator'
import { api } from '@/services/api';
import type { Receipt, Status } from '@/components/domain/Status'
import { ref } from 'vue'

const props = defineProps<{
  decision?: boolean
  receipt: Receipt
  collectReceipt: boolean
}>()

const emit = defineEmits<{
  (e: 'verified', result: boolean): void
  (e: 'checked', result: boolean): void
}>()
const postReceiptResult = ref<Status>()

const verifyAndCollectReceipt = function (result: boolean) {
  if (props.collectReceipt) {
    console.log("Collecting receipt)")
    api.postReceipt(props.receipt).then((res) => {
      postReceiptResult.value = res
      if (res.status) {
        emit('checked', true)
        emit('verified', result)
      }
    })
  } else {
    emit('verified', result)
  }

}

const verify = function (result: boolean) {
  emit('verified', result)
}

const { t } = useTranslator()
</script>

<template>
  <template v-if="decision === undefined">
    <button class="btn btn-primary mb-2 w-100" @click="verifyAndCollectReceipt(true)">
      {{ t('action.verify_ballot_content.finalize') }}
    </button>
    <button class="btn btn-danger mb-2 w-100" @click="verify(false)">
      {{ t('action.verify_ballot_content.report') }}
    </button>
  </template>
  <p v-else-if="decision" class="alert alert-success mb-0">
    {{ t('action.verify_ballot_content.successful') }}
  </p>
  <p v-else class="alert alert-danger mb-0">
    {{ t('action.verify_ballot_content.failed') }}
  </p>
</template>

<style>
.mw-10em {
  width: 10em;
}
</style>
