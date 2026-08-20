<script setup lang="ts">
import { computed } from 'vue'
import type { List } from '@/components/domain/POLYAS'
import CandidateView from '@/components/view/Ballot/CandidateView.vue'

const props = defineProps<{
  choice: string
  list: List
}>()

const votesPerCandidate = computed(() => {
  const lookup: { [index: string]: number | undefined } = {}
  props.list.candidates.forEach((candidate, index) => {
    lookup[candidate.id] = parseInt(props.choice.substring((index + 1) * 2, (index + 2) * 2))
  })

  return lookup
})
defineEmits(['selected'])
</script>

<template>
  <div class="table-container shadow-sm rounded-3 overflow-hidden">
    <div class="bg-primary text-white px-3 py-2">
      <h4 class="fs-5">{{ list.title.default }}</h4>
    </div>
    <table class="table  table-layout-fixed table-bordered mb-0">
      <thead v-if="list.columnHeaders.length > 0">
        <tr>
          <th></th>
          <th class="mb-0" v-if="list.columnHeaders.length > 0">
            {{list.columnHeaders.map((header) => header.default).join(', ')}}
          </th>
        </tr>
      </thead>
      <tbody>
        <CandidateView v-for="candidate in list.candidates" :key="candidate.id" :candidate="candidate"
          :votes="votesPerCandidate[candidate.id]!" @selected="$emit('selected', $event)" />
      </tbody>
    </table>
  </div>
</template>