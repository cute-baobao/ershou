<template>
	<div
		class="min-h-screen bg-gray-100 dark:bg-slate-950 text-gray-900 dark:text-gray-100"
	>
		<div class="container px-[10%] py-6">
			<h1
				class="text-2xl font-bold text-center text-green-600 dark:text-green-400 mb-6"
			>
				订单中心
			</h1>

			<!-- Order Status Tabs -->
			<div
				class="flex items-center justify-center mb-6 bg-white dark:bg-slate-800 rounded-lg shadow-md p-1"
			>
				<button
					v-for="(item, index) in status"
					:key="item"
					@click="active = index"
					class="px-4 py-2 text-sm font-medium rounded-md transition-colors duration-200 ease-in-out"
					:class="[
						active === index
							? 'bg-green-500 text-white'
							: 'text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-slate-700',
					]"
				>
					{{ item }}
				</button>
			</div>
			<!-- skeleton loading -->
			<div v-if="dataIsLoading" class="space-y-3">
				<div
					v-for="i in 6"
					:key="i"
					class="bg-white dark:bg-slate-800 rounded-lg overflow-hidden shadow-md"
				>
					<!-- Skeleton Order Header -->
					<div
						class="bg-gray-50 dark:bg-slate-700 px-4 py-2 flex justify-between items-center"
					>
						<div class="flex items-center space-x-2">
							<Skeleton class="h-6 w-6 rounded-full" />
							<Skeleton class="h-4 w-24" />
						</div>
						<Skeleton class="h-4 w-32" />
					</div>

					<!-- Skeleton Order Content -->
					<div class="p-3 flex items-center space-x-3">
						<Skeleton class="h-16 w-16 rounded-md" />
						<div class="flex-grow">
							<Skeleton class="h-4 w-3/4 mb-1" />
							<Skeleton class="h-4 w-1/2" />
						</div>
						<Skeleton class="h-8 w-20 rounded-md" />
					</div>
				</div>
			</div>

			<!-- Order List -->
			<div v-if="orderList.total > 0" class="space-y-3">
				<div
					v-for="item in orderList.records"
					:key="item.id"
					class="bg-white dark:bg-slate-800 rounded-lg overflow-hidden shadow-md transition-all duration-300 hover:shadow-lg"
				>
					<!-- Order Header -->
					<div
						class="bg-gray-50 dark:bg-slate-700 px-4 py-2 flex justify-between items-center text-sm"
					>
						<div
							@click="
								router.push({ path: '/userDetail', query: { id: item.userId } })
							"
							class="flex items-center space-x-2 cursor-pointer"
						>
							<Avatar
								class="h-6 w-6 border border-green-400 dark:border-green-600"
							>
								<AvatarImage :src="item.avatar" alt="User Avatar" />
								<AvatarFallback>{{ item.username.charAt(0) }}</AvatarFallback>
							</Avatar>
							<span class="font-medium text-green-600 dark:text-green-400">{{
								item.username
							}}</span>
						</div>
						<div class="text-gray-500 dark:text-gray-400">
							订单号：{{ item.number }}
						</div>
					</div>

					<!-- Order Content -->
					<div class="p-3 flex items-center space-x-3">
						<el-image
							class="h-16 w-16 rounded-md object-cover"
							:src="item.image"
							alt="商品图片"
							fit="cover"
						/>
						<div class="flex-grow cursor-pointer" @click="orderDetail(item.id)">
							<h3 class="text-sm font-medium mb-1 line-clamp-1">
								{{ item.title }}
							</h3>
							<p class="text-green-600 dark:text-green-400 text-sm font-medium">
								实付款：￥{{ item.amount }}
							</p>
						</div>
						<div class="flex items-center space-x-2">
							<Button
								v-if="item.status === '待发货'"
								@click="cancel(item.id)"
								class="bg-red-500 hover:bg-red-600 text-white text-xs"
							>
								取消订单
							</Button>
							<template v-else-if="item.status === '待支付'">
								<Button
									@click="pay(item.number, item.amount, item.title)"
									class="bg-yellow-500 hover:bg-yellow-600 text-black font-medium text-xs"
								>
									点击付款
								</Button>
								<Button
									@click="cancel(item.id)"
									class="bg-red-500 hover:bg-red-600 text-white text-xs"
								>
									取消订单
								</Button>
							</template>
							<Button
								v-else-if="item.status === '待收货'"
								@click="receive(item.id)"
								class="bg-blue-500 hover:bg-blue-600 text-white text-xs"
							>
								确认收货
							</Button>
							<rateItem
								@update="getAllOrder"
								:userId="item.userId"
								:orderId="item.id"
								v-else-if="item.status === '待评价'"
							/>
							<Button
								v-else-if="item.status === '已完成'"
								disabled
								class="bg-gray-300 dark:bg-gray-600 text-gray-500 dark:text-gray-400 cursor-not-allowed text-xs"
							>
								订单已完成
							</Button>
							<Button
								v-else
								disabled
								class="bg-gray-300 dark:bg-gray-600 text-gray-500 dark:text-gray-400 cursor-not-allowed text-xs"
							>
								已取消
							</Button>
						</div>
					</div>
				</div>
			</div>

			<!-- Empty State -->
			<div
				v-if="orderList.total === 0 && dataIsLoading != true"
				class="flex justify-center items-center h-48 bg-white dark:bg-slate-800 rounded-lg shadow-sm"
			>
				<p class="text-xl font-medium text-gray-500 dark:text-gray-400">
					暂无订单数据
				</p>
			</div>

			<!-- Pagination -->
			<div class="mt-6 flex justify-center">
				<el-pagination
					background
					hide-on-single-page
					layout="prev, pager, next"
					:total="orderList.total"
					:current-page="currentPage"
					:page-size="10"
					@current-change="currentPageChange"
					class="bg-white dark:bg-slate-800 rounded-full px-2 py-1 shadow-sm"
				/>
			</div>
		</div>
	</div>
</template>

<script setup>
import { Button } from '@/components/ui/button';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { Skeleton } from '@/components/ui/skeleton';

import api from '@/utils/api';
import { success } from '@/utils/message';
import { useRouter } from 'vue-router';
import rateItem from '@/components/rateItem.vue';
import { ref, watch, computed, onMounted } from 'vue';
//路由管理
const router = useRouter();
// 选项
const active = ref(0);
const currentPage = ref(1);
const status = ref([
	'所有订单',
	'待付款',
	'待发货',
	'待收货',
	'已完成',
	'已取消',
	'待评价',
]);

/**
 * 加载
 */
const dataIsLoading = ref(false);
const orderList = ref({
	total: 0,
	records: [],
});

onMounted(() => {
	getAllOrder();
});

watch(
	() => active.value,
	(newValue, oldValue) => {
		currentPage.value = 1;
		getAllOrder();
	}
);

/**
 * 分页切换
 * @param val 当前页码
 */
const currentPageChange = (val) => {
	currentPage.value = val;
	getAllOrder();
};

/**
 * 获取所有订单
 */
const getAllOrder = async () => {
	dataIsLoading.value = true;
	let data = {
		page: currentPage.value,
		pageSize: 10,
		status: active.value === 0 ? null : active.value,
		title: null,
		buyOrSell: '1',
		productType: '1',
	};
	await api({
		url: '/user/order/page',
		method: 'POST',
		headers: {
			'Content-Type': 'application/json',
		},
		data: data,
	})
		.then((res) => {
			if (res.code === 1) {
				orderList.value.total = res.data.total;
				orderList.value.records = res.data.records;
				////console.log(orderList.value)
			}
		})
		.finally(() => {
			dataIsLoading.value = false;
		});
};

/**
 * 支付
 * @param id 订单id
 */
const pay = async (number, amount, title) => {
	const res = confirm('即将跳转到支付页面');
	res
		? window.open(
				`${
					import.meta.env.VITE_APP_URL
				}/alipay/pay?subject=${title}&traceNo=${number}&totalAmount=${amount}`,
				'_blank'
		  )
		: info('支付已取消');
};

/**
 * 取消订单
 * @param id 订单id
 */
const cancel = async (id) => {
	await api({
		url: '/user/order/cancel',
		method: 'PUT',
		params: {
			id: id,
		},
	}).then((res) => {
		if (res.code === 1) {
			success('订单取消成功');
			getAllOrder();
		}
	});
};
/**
 * 收货
 * @param id 订单id
 */
const receive = async (id) => {
	await api({
		url: '/user/order/receive',
		method: 'PUT',
		params: {
			id: id,
		},
	}).then((res) => {
		if (res.code === 1) {
			success('确认收货');
			getAllOrder();
		}
	});
};

/**
 * 查看订单详情
 * @param id 订单id
 */
const orderDetail = (id) => {
	router.push({
		path: '/orderDetail',
		query: {
			buyOrSell: 1,
			id: id,
		},
	});
};
</script>

<style scoped>
.active {
	color: #34d399;
	border-color: #34d399;
}
</style>
