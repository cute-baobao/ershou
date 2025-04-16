<template>
	<div class="bg-slate-100 dark:bg-slate-900 min-h-[90vh]">
		<div class="container mx-auto p-4 max-w-4xl dark:*:text-white">
			<h1 class="text-2xl font-bold mb-6 text-gray-800 dark:text-white">
				确认订单
			</h1>
			<div v-if="dataIsLoading" class="grid grid-cols-1 md:grid-cols-3 gap-6">
				<!-- 骨架加载效果 -->
				<div class="md:col-span-2 space-y-6">
					<Card>
						<CardHeader>
							<Skeleton class="h-6 w-32" />
						</CardHeader>
						<CardContent>
							<Skeleton class="h-10 w-full mb-4" />
							<div class="space-y-2">
								<Skeleton class="h-4 w-full" />
								<Skeleton class="h-4 w-3/4" />
							</div>
						</CardContent>
					</Card>

					<Card>
						<CardHeader>
							<Skeleton class="h-6 w-32" />
						</CardHeader>
						<CardContent>
							<Skeleton class="h-4 w-1/2 mb-2" />
							<div class="flex items-center space-x-4">
								<Skeleton class="w-24 h-24 rounded-md" />
								<div class="space-y-2">
									<Skeleton class="h-4 w-40" />
									<Skeleton class="h-4 w-24" />
								</div>
							</div>
						</CardContent>
						<CardFooter>
							<Skeleton class="h-10 w-full" />
						</CardFooter>
					</Card>
				</div>

				<div>
					<Card>
						<CardHeader>
							<Skeleton class="h-6 w-32" />
						</CardHeader>
						<CardContent>
							<div class="space-y-2">
								<div class="flex justify-between">
									<Skeleton class="h-4 w-20" />
									<Skeleton class="h-4 w-16" />
								</div>
								<div class="flex justify-between">
									<Skeleton class="h-4 w-20" />
									<Skeleton class="h-4 w-16" />
								</div>
								<Separator class="my-2" />
								<div class="flex justify-between">
									<Skeleton class="h-6 w-24" />
									<Skeleton class="h-6 w-20" />
								</div>
							</div>
						</CardContent>
						<CardFooter>
							<Skeleton class="h-10 w-full" />
						</CardFooter>
					</Card>
				</div>
			</div>

			<div v-else class="grid grid-cols-1 md:grid-cols-3 gap-6">
				<!-- 原有的内容 -->
				<div class="md:col-span-2 space-y-6">
					<Card>
						<CardHeader class="flex flex-row items-center justify-between">
							<CardTitle
								class="text-lg font-semibold text-gray-700 dark:text-slate-100"
								>收货地址</CardTitle
							>
							<addressAdd @update="getAddressList">
								<Button>添加地址</Button>
							</addressAdd>
						</CardHeader>
						<CardContent>
							<selectItem v-model="address" :holder="'选择收货地址'">
								<template #item>
									<SelectItem
										v-for="address in addresses"
										:key="address.id"
										:value="String(address.id)"
									>
										<div class="flex items-start">
											<MapPin
												class="mr-2 h-4 w-4 mt-1 flex-shrink-0 text-gray-500"
											/>
											<div>
												<div class="font-medium">{{ address.address }}</div>
												<div class="text-sm text-gray-500">
													<span class="mr-2">
														<User class="inline-block mr-1 h-3 w-3" />
														{{ address.consignee }}
													</span>
													<span>
														<Phone class="inline-block mr-1 h-3 w-3" />
														{{ address.phone }}
													</span>
												</div>
											</div>
										</div>
									</SelectItem>
								</template>
							</selectItem>
						</CardContent>
					</Card>

					<Card>
						<CardHeader>
							<CardTitle
								class="text-lg font-semibold text-gray-700 dark:text-slate-100"
								>订单信息</CardTitle
							>
						</CardHeader>
						<CardContent>
							<h1 class="text-md font-semibold mb-2">
								卖家：<span class="text-orange-500">{{
									product.username
								}}</span>
							</h1>
							<div class="flex items-center space-x-4">
								<img
									:src="product.image[0]"
									:alt="product.title"
									class="w-24 h-24 object-cover rounded-md shadow-sm"
								/>
								<div>
									<h3 class="font-medium text-gray-800 dark:text-slate-100">
										{{ product.title }}
									</h3>
									<p class="text-sm text-gray-500 mt-1">
										价格: ¥{{ product.price }}
									</p>
								</div>
							</div>
						</CardContent>
						<CardFooter>
							<Input
								v-model="orderNote"
								placeholder="订单备注（选填）"
								class="w-full text-black"
							/>
						</CardFooter>
					</Card>
				</div>

				<div>
					<Card>
						<CardHeader>
							<CardTitle
								class="text-lg font-semibold text-gray-700 dark:text-slate-100"
								>付款详情</CardTitle
							>
						</CardHeader>
						<CardContent>
							<div class="space-y-2">
								<div class="flex justify-between text-sm">
									<span class="text-gray-600 dark:text-slate-50">总价</span>
									<span class="font-medium">¥{{ product.price }}</span>
								</div>
								<div class="flex justify-between text-sm">
									<span class="text-gray-600 dark:text-slate-100">运费</span>
									<span class="font-medium">¥{{ product.freight }}</span>
								</div>
								<Separator class="my-2" />
								<div class="flex justify-between text-base font-bold">
									<span>实付款</span>
									<span class="text-red-500"
										>¥{{ product.price + product.freight }}</span
									>
								</div>
							</div>
						</CardContent>
						<CardFooter>
							<Dialog :open="openDialog">
								<DialogTrigger class="w-full">
									<Button
										class="w-full bg-orange-500 hover:bg-orange-600 text-white"
										@click="orderSubmit"
									>
										<span v-if="!isloading">购买</span>
										<span v-else class="flex items-center">
											<Loader2 class="w-4 h-4 mr-2 animate-spin" />
											等待服务器处理中...
										</span>
									</Button>
								</DialogTrigger>
								<DialogContent>
									<DialogHeader>
										<DialogTitle>订单生成成功</DialogTitle>
									</DialogHeader>
									<div>
										<div class="text-center space-y-2">
											<p class="text-lg font-bold">订单提交成功！</p>
											<p class="text-orange-500 text-xl font-semibold">
												¥{{ product.price + product.freight }}
											</p>
											<p class="text-gray-600 dark:text-slate-100">
												是否立即支付
											</p>
										</div>
									</div>
									<template #close>
										<DialogClose
											class="absolute right-4 top-4 rounded-sm opacity-70 ring-offset-background transition-opacity hover:opacity-100 focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:pointer-events-none data-[state=open]:bg-accent data-[state=open]:text-muted-foreground"
											@click="openDialog = false"
										>
											<X class="w-4 h-4" />
											<span class="sr-only">Close</span>
										</DialogClose>
									</template>
									<DialogFooter>
										<Button
											class="bg-orange-500 hover:bg-orange-600 text-black"
											@click="pay"
										>
											<span v-if="!isloading"> 支付 </span>
											<span v-else class="flex gap-2 items-center">
												<Loader2 class="w-4 h-4 mr-2 animate-spin" />
												等待服务器处理中...
											</span>
										</Button>
										<Button
											variant="outline"
											class="text-black dark:text-white"
											@click="openDialog = false"
										>
											暂不支付
										</Button>
									</DialogFooter>
								</DialogContent>
							</Dialog>
						</CardFooter>
					</Card>
				</div>
			</div>
		</div>
	</div>
</template>

<script setup>
import {
	Card,
	CardContent,
	CardFooter,
	CardHeader,
	CardTitle,
} from '@/components/ui/card';
import {
	Select,
	SelectContent,
	SelectItem,
	SelectTrigger,
	SelectValue,
} from '@/components/ui/select';
import {
	Dialog,
	DialogClose,
	DialogContent,
	DialogDescription,
	DialogFooter,
	DialogHeader,
	DialogTitle,
	DialogTrigger,
} from '@/components/ui/dialog';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';
import { Separator } from '@/components/ui/separator';
import { MapPin, Phone, User, X } from 'lucide-vue-next';
import selectItem from '@/components/selectItem.vue';
import addressAdd from '../components/addressAdd.vue';
import { Skeleton } from '@/components/ui/skeleton';

import { ref, onMounted, watch } from 'vue';
import api from '@/utils/api';
import { useRoute, useRouter } from 'vue-router';
import { useUser } from '@/utils/pinia';
import { success, info, warning } from '@/utils/message';
import { Loader2 } from 'lucide-vue-next';
import { number } from 'echarts';

//页面加载
const dataIsLoading = ref(false);
const isloading = ref(false);
//路由管理
const openDialog = ref(false);
const route = useRoute();
const router = useRouter();
// 页面数据
const address = ref('');
const orderNote = ref(null);
const addresses = ref([]);
const id = ref();
const user = useUser();
const order = ref({
	id: 0,
	number: 0,
});
const product = ref({
	categoryId: Number,
	price: Number,
	title: String,
	desc: String,
	freight: Number,
	image: Array,
	createTime: String, //创建时间--发布时间
	collectionNum: Number, //收藏量
	username: String, //用户名
	avatar: String, //用户头像
	rate: Number, //卖家评分
	collectionStatus: Number,
	userId: Number,
});

const emits = defineEmits(['close']);

onMounted(() => {
	window.scrollTo(0, 0);
	if (!route.query.id) {
		router.push({ path: '/404' });
	} else {
		id.value = Number(route.query.id);
		loadProduct();
	}
	getAddressList();
});

const getAddressList = async () => {
	await api({
		url: '/user/addressBook/getAll',
		method: 'GET',
	}).then((res) => {
		addresses.value = res.data;
	});
};

const loadProduct = async () => {
	dataIsLoading.value = true;
	if (id.value === -1) router.push({ path: '/' });
	await api({
		url: '/user/product/detail',
		method: 'GET',
		params: {
			productId: id.value,
			userId: user.getUser().id,
		},
	})
		.then((res) => {
			product.value = { ...res.data };
			////console.log(product.value)
		})
		.finally(() => {
			dataIsLoading.value = false;
		});
};

const orderSubmit = async () => {
	if (address.value === '') {
		info('请选择地址');
		return;
	}
	isloading.value = true;
	await api({
		method: 'POST',
		url: '/user/order/add',
		data: {
			addressBookId: Number(address.value),
			productId: id.value,
			sellerId: product.value.userId,
			remark: orderNote.value,
		},
	})
		.then((res) => {
			if (res.code === 1) {
				order.value = res.data;
				openDialog.value = true;
			}
		})
		.finally(() => {
			isloading.value = false;
		});
};
const pay = async () => {
	console.log(order.value, product.value);
	const res = confirm('即将跳转到支付页面');
	res
		? window.open(
				`${import.meta.env.VITE_APP_URL}/alipay/pay?subject=${
					product.value.title
				}&traceNo=${order.value.number}&totalAmount=${product.value.price}`,
				'_blank'
		  )
		: info('支付已取消,订单将保留15分钟');
	router.push({ path: '/orderCenter' });
};

watch(
	() => openDialog.value,
	(newValue, oldValue) => {
		if (newValue === false) {
			info('支付已取消,订单将保留15分钟');
			router.push('/orderCenter');
		}
	}
);
</script>
