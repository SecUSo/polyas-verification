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

const ownerError = ref<string>(null)
const showPasswordError = ref<boolean>(false)

const ownerInput = ref<HTMLElement>()
const ownerInputType = computed(() => (/^\d+$/.test(props.expectedOwnerId) ? 'number' : 'text'))
const owner = ref<string | number>(props.enteredOwnerId ?? '')

const passwordInput = ref<HTMLElement>()
const password = ref<string>()
const sanitizedPassword = computed(() => password.value?.replace(/[^0-9.]/g, ''))
const invalidCharacters = computed(() => password.value && sanitizedPassword.value?.length !== password.value.length)

const confirm = function () {
    ownerError.value = null
    showPasswordError.value = false
    if (!owner.value) {
        ownerError.value = "missing"
        return
    } else if (owner.value != props.expectedOwnerId) {
        ownerError.value = "failed"
        return
    } else if (!sanitizedPassword.value) {
        showPasswordError.value = true
        return
    }
    else {
        emit('entered', {
            id: String(owner.value), otp: sanitizedPassword.value
        })
    }

}

watch(owner, () => {
    ownerError.value = null
})
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

    <p v-if="ownerError" class="alert alert-danger mb-0 mt-1">
        {{ t(`action.verify_ballot_owner.${ownerError}`) }}
    </p>
    <div class="d-flex flex-column mt-3">
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
