<template>
    <Select>
        <SelectTrigger>
            <SelectValue :placeholder="holder" />
        </SelectTrigger>
        <SelectContent position="popper" class="max-h-[30svh]">
            <SelectGroup>
                <SelectLabel>{{holder}}</SelectLabel>
                <slot name="item">
                    
                </slot>
            </SelectGroup>
        </SelectContent>
    </Select>
</template>

<script setup>
import {
    Select,
    SelectContent,
    SelectGroup,
    SelectItem,
    SelectLabel,
    SelectTrigger,
    SelectValue,
} from '@/components/ui/select'
const props =  defineProps(['val','holder'])
</script>
