<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import { useTranslator } from '@/locales/translator'
const props = defineProps<{
    expectedOwnerId: string
    enteredOwnerId?: string
}>()

const emit = defineEmits<{
    (e: 'entered', result: { id: string, otp: string }): void
}>()

const showIDError = ref<boolean>(false)
const showPasswordError = ref<boolean>(false)

const ownerInput = ref<HTMLElement>()
const ownerInputType = computed(() => (/^\d+$/.test(props.expectedOwnerId) ? 'number' : 'text'))
const owner = ref<string | number>(props.enteredOwnerId ?? '')

const passwordInput = ref<HTMLElement>()
const password = ref<string>()
const sanitizedPassword = computed(() => password.value?.replace(/[^0-9.]/g, ''))
const invalidCharacters = computed(() => password.value && sanitizedPassword.value?.length !== password.value.length)

const confirm = function () {
    if (!owner.value) {
        showIDError.value = true
        return
    } else if (!sanitizedPassword.value) {
        showIDError.value = false
        showPasswordError.value = true
        return
    } else {
        showPasswordError.value = false
        showIDError.value = false
    }
    emit('entered', {
        id: String(owner.value), otp: sanitizedPassword.value
    })
}
onMounted(() => {
    ownerInput.value?.focus()
})

const onPaste = (event: ClipboardEvent) => {
    const data = event.clipboardData?.getData('text')
    password.value = (password.value ?? '') + data?.replace(' ', '')
}

const { t } = useTranslator()
</script>

<template>
    <div class="d-flex flex-column">
        <div>
            {{ t('action.verify_ballot_owner.ballot_owner_source') }}
        </div>
        <input ref="ownerInput" :type="ownerInputType" class="form-control form-control-lg text-center mt-3"
            :placeholder="t('action.verify_ballot_owner.set_ballot_owner')" v-model="owner"
            :class="{ 'is-invalid': enteredOwnerId && enteredOwnerId !== expectedOwnerId }" />

    </div>

    <p v-if="showIDError" class="alert alert-danger mb-0 mt-1">
        {{ t('action.verify_ballot_owner.missing') }}
    </p>
    <p v-else-if="enteredOwnerId && (enteredOwnerId !== expectedOwnerId)" class="alert alert-danger mb-0  mt-1">
        {{ t('action.verify_ballot_owner.failed') }}
    </p>
    <div class="d-flex flex-column mt-5">
        <div>
            {{ t('action.set_password.one_time_password') }}
        </div>
        <input ref="passwordInput" type="text" class="form-control form-control-lg text-center mt-3"
            :placeholder="t('action.set_password.set_password')" v-model="password" @paste.prevent="onPaste"
            :class="{ 'is-invalid': invalidCharacters }" />

    </div>
    <p v-if="showPasswordError" class="alert alert-danger mb-0 mt-1">
        {{ t('action.set_password.missing') }}
    </p>
    <button class="btn btn-primary mt-3 w-100" @click="confirm()">
        {{ t('action.set_password.verify') }}
    </button>
</template>
