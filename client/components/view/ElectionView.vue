<script setup lang="ts">
import type { Election } from '@/components/domain/Election'

import type { ElectionDetails } from '@/components/domain/POLYAS'

defineProps<{
  election: Election
  electionDetails: ElectionDetails
}>()
</script>

<template>
  <h2 style="text-align: center">{{ electionDetails.title.default }}</h2>
</template>
