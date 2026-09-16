<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import type { Status } from '@/components/domain/Status'
import { useRoute, useRouter } from 'vue-router'
import { api } from '@/services/api'
import { VerificationErrors } from '@/components/domain/VerificationErrors'
import BallotsView from './view/BallotsView.vue'
import ResetButton from '@/components/shared/ResetButton.vue'
import VerifyBallotContent from '@/components/action/VerifyBallotContent.vue'
import { useTranslator } from '@/locales/translator'
import DownloadReceipt from '@/components/action/DownloadReceipt.vue'
import Authenticate from './action/Authenticate.vue'
import TakeSurvey from './action/TakeSurvey.vue'
import LoginView from './view/LoginView.vue'
import ErrorView from './view/library/ErrorView.vue'

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

const collectReceipt = ref<boolean>(true)

const handleEntered = ({ id, otp }: { id: string; otp: string }) => {
  ballotOwner.value = id
  if (urlPayload.value!.vid === id)
    password.value = otp
}

const { t } = useTranslator()
</script>

<template>

  <div class="mb-4">
    <!--<h3 class="mb-2">{{ t('view.verify_app.title') }}</h3>
    <p>{{ t('view.verify_app.description') }}</p>-->
  </div>

  <div class="row g-2">
    <div v-if="!urlPayload">
      <p class="mb-3">{{ t('view.home_app.no_params') }}</p>
      <p class="mb-3"><a href="https://gi.de/wahlen">{{ t('view.home_app.to_election') }} </a></p>
    </div>
    <div v-if="urlPayload && !verificationResult?.result">
      <LoginView />
      <Authenticate @entered="handleEntered" :expectedOwnerId="urlPayload.vid" :enteredOwnerId="ballotOwner" />
    </div>

    <div v-if="verificationFailed" class="alert alert-danger mb-3">
      <ErrorView prefix="domain.verification_status" :result="verificationResult" :error-order="errorOrder"
        :fallback-error="VerificationErrors.UNKNOWN" />
    </div>
    <div v-if="!!verificationResult?.result && !ballotContentVerifiedResult">
      <p class="text-body-emphasis mb-2">{{ t('action.verify_ballot_content.question') }}</p>
      <BallotsView :choice="verificationResult.result" />
      <div class="mb-2">
        <input class="form-check-input" type="checkbox" v-model="collectReceipt" /> {{
          t('view.verify_app.collect_receipt') }}
      </div>

      <VerifyBallotContent @verified="ballotContentVerifiedResult = $event" @checked="receiptChecked = $event"
        :decision="ballotContentVerifiedResult" :receipt="verificationResult.receipt"
        :collectReceipt="collectReceipt" />
    </div>
  </div>
  <p v-if="ballotContentVerifiedResult" class="fw-bold">
    {{ t('view.verify_app.verification_finished') }}
  </p>
  <div v-if="ballotContentVerifiedResult && verificationResult?.receipt">
    <DownloadReceipt :receipt="verificationResult.receipt" @downloaded="receiptDownloaded = $event" class="mb-3" />
    <TakeSurvey class="mb-5" />
  </div>
</template>
