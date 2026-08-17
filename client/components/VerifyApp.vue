<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import type { Status } from '@/components/domain/Status'
import { useRoute, useRouter } from 'vue-router'
import { api } from '@/services/api'
import SetPassword from '@/components/action/SetPassword.vue'
import { VerificationErrors } from '@/components/domain/VerificationErrors'
import VerificationExplanation from '@/components/layout/VerificationExplanation.vue'
import ResetButton from '@/components/shared/ResetButton.vue'
import { VerificationSteps } from '@/components/domain/VerificationSteps'
import VerifyBallotContent from '@/components/action/VerifyBallotContent.vue'
import CheckReceipt from '@/components/action/CheckReceipt.vue'
import { useTranslator } from '@/locales/translator'
import VerifyBallotOwner from '@/components/action/VerifyBallotOwner.vue'
import DownloadReceipt from '@/components/action/DownloadReceipt.vue'

const route = useRoute()
const decodeUrlBase64 = (value: string) => {
  const base64 = value.replace(/-/g, '+').replace(/_/g, '/')
  return base64 + '='.repeat((4 - (base64.length % 4)) % 4)
}

const urlPayload = computed(() => {
  const c = route.query?.c
  const d = route.query?.d
  const vid = route.query?.vid
  const nonce = route.query?.nonce
  if (!c || Array.isArray(c) || !d || Array.isArray(d) || !vid || Array.isArray(vid) || !nonce || Array.isArray(nonce)) {
    return null
  }

  return { c, d, vid, nonce }
})

const router = useRouter()
const backVerify = computed(() => {
  router.currentRoute.value // need this for reactivity
  return router.options.history.state.back && router.options.history.state.back.toString().startsWith('/verify')
})

const reset = () => {
  password.value = undefined
  verificationResult.value = undefined
  ballotOwner.value = undefined
  ballotContentVerifiedResult.value = undefined
  receiptChecked.value = undefined
  if (backVerify.value) {
    router.back()
  }
}

const canReset = computed(() => {
  return password.value || backVerify.value
})

const password = ref<string>()

watch(password, () => {
  if (password.value && urlPayload.value) {
    doVerification()
  }
})

const verificationResult = ref<Status>()
const doVerification = async () => {
  if (!urlPayload.value || !password.value) {
    return
  }

  const payload = {
    ...urlPayload.value,
    c: decodeUrlBase64(urlPayload.value.c),
    d: decodeUrlBase64(urlPayload.value.d),
    password: password.value
  }
  verificationResult.value = await api.postVerification(payload)
}

const errorOrder: VerificationErrors[] = [
  VerificationErrors.LOGIN_SUCCESSFUL,
  VerificationErrors.DEVICE_PARAMETERS_MATCH,
  VerificationErrors.SIGNATURE_VALID,
  VerificationErrors.ASSOCIATION_VALID,
  VerificationErrors.QR_CODE_DECRYPTION,
  VerificationErrors.CHALLENGE_SUCCESSFUL,
  VerificationErrors.ZKP_VALID,
  VerificationErrors.BALLOT_DECODE
]

const ballotOwner = ref<string>()
const ballotContentVerifiedResult = ref<boolean>()
const receiptChecked = ref<boolean>()
const receiptDownloaded = ref<boolean>()
const verificationFailed = computed(() => {
  // ballot misattributed
  if (urlPayload.value && ballotOwner.value && ballotOwner.value !== urlPayload.value.vid) {
    return true
  }

  // ballot recovery failed
  if (verificationResult.value?.error) {
    return true
  }

  // ballot verification failed
  if (ballotContentVerifiedResult.value !== undefined && !ballotContentVerifiedResult.value) {
    return true
  }

  return false
})

const { t } = useTranslator()
</script>

<template>
  <div class="mb-4">
    <h3 class="mb-2">{{ t('view.verify_app.title') }}</h3>
    <p>{{ t('view.verify_app.description') }}</p>
  </div>

  <div class="row g-2">
    <div class="p-0" v-if="canReset">
      <ResetButton @reset="reset" />
    </div>

    <div v-if="urlPayload">
      <VerifyBallotOwner @entered="ballotOwner = $event" :expectedOwnerId="urlPayload.vid"
        :enteredOwnerId="ballotOwner" />
    </div>

    <div v-if="urlPayload && ballotOwner === urlPayload.vid">
      <SetPassword @changed="password = $event" />
    </div>

    <div v-if="!!verificationResult?.result">
      <VerifyBallotContent :choice="verificationResult.result" @verified="ballotContentVerifiedResult = $event"
        :decision="ballotContentVerifiedResult" />
    </div>

    <div v-if="!!(ballotContentVerifiedResult && verificationResult?.receipt)" prefix="domain.verification_step"
      :entry="VerificationSteps.STORE_RECEIPT" :done="receiptChecked !== undefined" :success="true">
      <CheckReceipt :receipt="verificationResult.receipt" @checked="receiptChecked = $event" />
    </div>
  </div>

  <p class="alert alert-success mt-2 mb-5" v-if="receiptChecked !== undefined">
    {{ t('view.verify_app.verification_finished') }}
  </p>

  <div v-if="receiptChecked !== undefined && verificationResult?.receipt" prefix="domain.verification_step"
    :entry="VerificationSteps.DOWNLOAD_RECEIPT" :done="receiptDownloaded !== undefined" :success="receiptDownloaded"
    :optional="true">
    <DownloadReceipt :receipt="verificationResult.receipt" @downloaded="receiptDownloaded = $event" />
  </div>

  <div class="my-5">
    <VerificationExplanation :verification-failed="verificationFailed" />
  </div>
</template>
