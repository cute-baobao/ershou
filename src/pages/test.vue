<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { Button } from '@/components/ui/button';
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card';
import FooterComponent from '@/components/footerComponent.vue';
import { Icon } from '@iconify/vue/dist/iconify.js';
import lottie from 'lottie-web';
import { CountTo } from 'vue3-count-to';
import { useRouter } from 'vue-router';

const router = useRouter();
const coreData = ref([
	{
		icon: 'mdi:molecule-co2',
		value: 178.3,
		unit: '万吨',
		description: '闲置物品交易',
		detail:
			'自2015年创建至2020年年末，转转平台已通过促进闲置物品流转累计完成碳减排178.3万吨',
	},
	{
		icon: 'mdi:power-plug',
		value: 1320,
		unit: '万吨',
		description: '智能节电设备',
		detail:
			'国网能源院统计，住宅智能温控/感应照明系统普及率62%，年度节电387亿度，等效减排1320万吨（按0.341kg CO₂/度计算）',
	},
	{
		icon: 'mdi:water-opacity',
		value: 25.8,
		unit: '亿吨',
		description: '家庭节水实践',
		detail:
			'住建部2024白皮书显示，节水型器具覆盖83%城区家庭，年度节水215亿吨，对应水处理碳排减少25.8亿吨（1吨水=120g CO₂）',
	},
]);

const calculateCarbonFootprint = () => {
	router.push('/carbonComputed');
};

onMounted(() => {
	lottie.loadAnimation({
		container: document.getElementById('eco-earth-animation')!,
		renderer: 'svg',
		loop: true,
		autoplay: true,
		path: '/eco.json',
	});
});
</script>

<template>
	<div
		class="min-h-screen bg-gradient-to-r from-emerald-100 to-emerald-50 text-black"
	>
		<!-- Hero Section -->
		<section class="container mx-auto px-4 py-16 md:flex items-center">
			<div class="md:w-1/2 space-y-6">
				<h1 class="text-4xl md:text-6xl font-bold">共筑绿意未来</h1>
				<p class="text-xl">
					每件二手交易平均减少：
					<CountTo
						class="text-4xl font-bold text-emerald-600"
						:startVal="0"
						:endVal="5.6"
						:decimals="1"
						:duration="3000"
					/>kg碳排放
				</p>
				<div class="space-x-4">
					<Button @click="calculateCarbonFootprint">开始计算碳足迹</Button>
					<Button @click="router.push('/index')" class="group">
						<Icon
							icon="mdi:swap-horizontal-circle"
							class="mr-2 transition-colors group-hover:text-green-600"
						/>
						浏览闲置宝贝
					</Button>
				</div>
			</div>
			<div class="md:w-1/2 mt-8 md:mt-0">
				<div id="eco-earth-animation" class="w-full h-64 md:h-96"></div>
			</div>
		</section>

		<!-- Core Data Display -->
		<section class="container mx-auto px-4 py-16 grid md:grid-cols-3 gap-8">
			<Card
				v-for="(item, index) in coreData"
				:key="index"
				class="p-6 hover:scale-105 transition-transform bg-white/20 bg-emerald-200"
			>
				<CardHeader>
					<CardTitle class="flex items-center">
						<Icon :icon="item.icon" class="text-4xl mr-2" />
						{{ item.description }}
					</CardTitle>
				</CardHeader>
				<CardContent>
					<CountTo
						class="text-3xl font-bold"
						:startVal="0"
						:endVal="item.value"
						:duration="3000"
					/>
					<span class="text-xl ml-1">{{ item.unit }}</span>
					<p class="mt-2 text-sm">{{ item.detail }}</p>
				</CardContent>
			</Card>
		</section>

		<!-- Footer -->
		<FooterComponent />
	</div>
</template>
