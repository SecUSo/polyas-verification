<script setup>
import { useTranslator } from '@/locales/translator'
import { ref, defineExpose } from 'vue'
const { t } = useTranslator()

const visible = ref(false)

const show = () => {
    visible.value = true
}

const close = () => {
    visible.value = false
}

defineExpose({ show })
</script>

<template>
    <div v-if="visible" class="alert-overlay">
        <div class="modal-dialog modal-dialog-centered mx-auto" style="max-width: 35em;">
            <div class="modal-content bg-white shadow-sm rounded-3">
                <div class="d-flex justify-content-end p-3">
                    <button class="btn-close" @click="close"></button>
                </div>
                <div class="modal-body px-4 pb-4">
                    <p class="mb-4">{{ t('layout.checkbox_modal.text') }}</p>
                    <div class="text-center">
                        <button class="btn btn-primary px-4" @click="close">
                            {{ t('layout.checkbox_modal.button') }}
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>


<style scoped>
.alert-overlay {
    position: fixed;
    inset: 0;
    background: rgba(0, 0, 0, 0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1050;
}
</style>