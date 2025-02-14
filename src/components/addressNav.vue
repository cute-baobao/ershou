<template>
    <Dialog>
        <DialogTrigger as-child>
            <Button @click="getAddressList">
                我的收货地址
            </Button>
        </DialogTrigger>
        <DialogContent class="max-h-[90dvh] max-w-full w-[50%] overflow-x-scroll">
            <DialogHeader>
                <DialogTitle>收货地址</DialogTitle>
                <DialogDescription>
                    管理收货地址
                </DialogDescription>
            </DialogHeader>
            <div class="py-4">
                <el-table class="bg-slate-600" v-loading="loading" border stripe max-height="350" :row-class-name="tableRowClassName" :data="addressList"
                    style="width: 100%">
                    <el-table-column prop="consignee" label="收货人" width="100" />
                    <el-table-column prop="phone" label="电话" width="120" />
                    <el-table-column prop="address" show-overflow-tooltip label="详细地址" />
                    <el-table-column align="center" width="90" prop="isDefault" label="默认地址">
                        <template #default="scope">
                            <el-tag @click="updateDefault(scope.$index, scope.row)">{{ scope.row.isDefault === 0 ? "否" : "是" }}</el-tag>
                        </template>
                    </el-table-column>
                    <el-table-column fixed="right" label="操作" width="160">
                        <template #default="scope">
                            <addressAdd :id="scope.row.id" @update="getAddressList"/>
                            <el-button size="small" type="danger" @click="deleteAddress(scope.$index, scope.row)">
                                删除
                            </el-button>
                        </template>
                    </el-table-column>
                </el-table>
            </div>
            <div class="flex gap-2 items-center">
                <addressAdd @update="getAddressList">
                    <Button>添加地址</Button>
                </addressAdd>
            </div>
        </DialogContent>
    </Dialog>
</template>

<script setup>
import { Button } from '@/components/ui/button';
import {
    Dialog,
    DialogContent,
    DialogDescription,
    DialogFooter,
    DialogHeader,
    DialogTitle,
    DialogTrigger,
} from '@/components/ui/dialog'
import addressAdd from './addressAdd.vue';

import { useUser } from '@/utils/pinia'
import { onMounted, ref } from 'vue';
import api from '@/utils/api'
import { success, warning } from '@/utils/message'
import { Loader2 } from 'lucide-vue-next'
import { id } from 'element-plus/es/locales.mjs';


//加载
const loading = ref(false)

//页面数据
const addressList = ref([])
const user = useUser()
const getAddressList = async () => {
    loading.value = true
    await api({
        url: '/user/addressBook/getAll',
        method: 'GET',
    }).then(res => {
        addressList.value = res.data
    }).finally(() => { loading.value = false })
}

const tableRowClassName = ({
    row,
    rowIndex,
}) => {
    if (row.isDefault === 1) {
        return 'default-row'

    } else {
        return 'none-row'
    }
}
const updateDefault = async (index, row) => {
    await api({
        url: `/user/addressBook/default/${row.id}`,
        method: 'PUT',
    }).then(res => {
        if (res.code === 1) {
            success("设置成功")
            getAddressList()
        }
    })
}

const deleteAddress = async (index, row) => {
    await api({
        url: '/user/addressBook/delete',
        method: 'DELETE',
        params:{
            id:row.id
        }
    }).then(res => {
        if (res.code === 1) {
            success("删除成功")
            getAddressList()
        }
    })
}
</script>

<style scoped>
.el-table .default-row {
    --el-table-tr-bg-color: var(--el-color-warning-light-9);
}

.el-table .none-row {
    --el-table-tr-bg-color: var(--el-color-success-light-9);
}

</style>
