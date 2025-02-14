<script setup lang="ts">
import type { HTMLAttributes } from 'vue'
import { cn } from '@/lib/utils'

const props = defineProps<{
  class?: HTMLAttributes['class']
}>()
</script>

<template>
  <div
    :class="
      cn(
        'rounded-lg border-[1.5px] border-main/40 border-solid bg-card text-card-foreground shadow-sm dark:bg-slate-800 dark:border-slate-700',
        props.class,
      )
    "
  >
    <slot />
  </div>
</template>
