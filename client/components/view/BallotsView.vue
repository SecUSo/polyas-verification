<script setup lang="ts">
import { computed, ref } from 'vue'
import { api } from '@/services/api'
import type { Ballot } from '@/components/domain/POLYAS'
import BallotView from '@/components/view/Ballot/BallotView.vue'
import { useTranslator } from '@/locales/translator'
import CheckboxModal from '@/components/layout/CheckboxModal.vue';
const modal = ref(null)
const modalShown = ref<boolean>(false)
const props = defineProps<{
  choice: string
}>()

const ballots = ref<Ballot[]>()

function showModal() {
  if (!modalShown.value) {
    modal.value.show()
    modalShown.value = true
  }

}

api.getBallots().then((result) => (ballots.value = result))

const choicePerBallot = computed(() => {
  const lookup: { [index: string]: string | undefined } = {}
  let activeIndex = 0
  ballots.value?.forEach((ballot) => {
    const length = (1 + ballot.lists.reduce((previous, current) => previous + 1 + current.candidates.length, 0)) * 2
    lookup[ballot.id] = props.choice.substring(activeIndex, activeIndex + length)
    activeIndex += length
  })

  return lookup
})

const { t } = useTranslator()
</script>

<template>
  <div class="form-text position-relative">
    {{ t('view.ballot.ballot_view.change_your_vote') }}
  </div>
  <div class="mt-3 d-flex row-gap-3 flex-column">
    <BallotView v-for="ballot in ballots" :key="ballot.id" :ballot="ballot" :choice="choicePerBallot[ballot.id] ?? ''"
      @selected="showModal" />
  </div>
  <CheckboxModal ref="modal" />
</template>
