<script setup lang="ts">
import type { Candidate } from '@/components/domain/POLYAS'

defineProps<{
  candidate: Candidate
  votes: number
}>()

defineEmits(['selected'])
</script>

<template>
  <tr>
    <td class="text-center align-middle" style="width: 2.5rem">

      <input @click="$emit('selected')" class="form-check-input" type="checkbox" :checked="votes > 0"
        :id="candidate.id" />
    </td>
    <td><label class="form-check-label" :for="candidate.id">
        {{candidate.columns.map((column) => column.value.default).join(', ')}}
      </label></td>


  </tr>
</template>