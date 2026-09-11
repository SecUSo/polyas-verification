<script setup lang="ts">
import { api } from '../../services/api.js'
import HeaderJumbotron from '@/components/layout/HeaderJumbotron.vue'
import { ref } from 'vue'
import ElectionView from '@/components/view/ElectionView.vue'
import type { Election } from '@/components/domain/Election'

import type { ElectionDetails } from '@/components/domain/POLYAS'
import { displayError } from '@/services/notifiers'
import { useTranslator } from '@/locales/translator'

const { t } = useTranslator()

const election = ref<Election>()
const electionDetails = ref<ElectionDetails>()

api.getElection().then((result) => (election.value = result))
api.getElectionDetails().then((result) => {
    if (!result) {
        const errorMessage = t('service.api.election_server_offline')
        displayError(errorMessage)
        return
    }

    electionDetails.value = result
})
</script>

<template>
    <HeaderJumbotron />
    <ElectionView class="my-5" v-if="election && electionDetails" :election="election"
        :election-details="electionDetails" />

</template>

<style scoped>
.mw-100em {
    max-width: 35em;
}
</style>
