<template>
    <div class="min-h-screen bg-gray-100 dark:bg-slate-950 text-gray-900 dark:text-gray-100 p-4 sm:p-6 lg:p-8">
        <div class="max-w-7xl mx-auto">
            <h1 class="text-3xl font-bold mb-2 text-center flex items-center justify-center">
                <LeafIcon class="w-8 h-8 mr-2 text-green-500" />
                个人年度碳排放计算器
            </h1>
            <a class="text-md mb-2 text-center flex items-center justify-center hover:underline" href="https://cute-baobao.github.io/computed.html">查看计算公式</a>
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
                <!-- 第一行：输入区域和结果显示区域 -->
                <div class="space-y-6">
                    <Card>
                        <CardHeader>
                            <CardTitle class="flex items-center">
                                <ClipboardListIcon class="w-5 h-5 mr-2 text-blue-500" />
                                输入您的日常/月度数据
                            </CardTitle>
                        </CardHeader>
                        <CardContent>
                            <form @submit.prevent="calculateEmissions" class="space-y-4">
                                <div class="space-y-2">
                                    <Label for="travel-distance" class="flex items-center">
                                        <CarIcon class="w-4 h-4 mr-2 text-gray-500 dark:text-gray-400" />
                                        每日出行距离
                                    </Label>
                                    <div class="relative">
                                        <Input id="travel-distance" v-model="travelDistance" type="number"
                                            placeholder="输入每日公里数" class="pr-16" />
                                        <span
                                            class="absolute inset-y-0 right-0 flex items-center pr-3 text-sm text-gray-500 dark:text-gray-400">
                                            公里/天
                                        </span>
                                    </div>
                                </div>

                                <div class="space-y-2">
                                    <Label for="travel-mode" class="flex items-center">
                                        <MapIcon class="w-4 h-4 mr-2 text-gray-500 dark:text-gray-400" />
                                        主要出行方式
                                    </Label>
                                    <Select v-model="travelMode">
                                        <SelectTrigger id="travel-mode">
                                            <SelectValue placeholder="选择主要出行方式" />
                                        </SelectTrigger>
                                        <SelectContent>
                                            <SelectItem value="car">
                                                <span class="flex items-center">
                                                    <CarIcon class="w-4 h-4 mr-2" />
                                                    私家车
                                                </span>
                                            </SelectItem>
                                            <SelectItem value="bus">
                                                <span class="flex items-center">
                                                    <BusIcon class="w-4 h-4 mr-2" />
                                                    公交车
                                                </span>
                                            </SelectItem>
                                            <SelectItem value="train">
                                                <span class="flex items-center">
                                                    <TrainIcon class="w-4 h-4 mr-2" />
                                                    火车
                                                </span>
                                            </SelectItem>
                                            <SelectItem value="plane">
                                                <span class="flex items-center">
                                                    <PlaneIcon class="w-4 h-4 mr-2" />
                                                    飞机
                                                </span>
                                            </SelectItem>
                                        </SelectContent>
                                    </Select>
                                </div>

                                <div class="space-y-2">
                                    <Label for="electricity-usage" class="flex items-center">
                                        <ZapIcon class="w-4 h-4 mr-2 text-gray-500 dark:text-gray-400" />
                                        月用电量
                                    </Label>
                                    <div class="relative">
                                        <Input id="electricity-usage" v-model="electricityUsage" type="number"
                                            placeholder="输入月用电量" class="pr-16" />
                                        <span
                                            class="absolute inset-y-0 right-0 flex items-center pr-3 text-sm text-gray-500 dark:text-gray-400">
                                            度/月
                                        </span>
                                    </div>
                                </div>

                                <div class="space-y-2">
                                    <Label for="water-usage" class="flex items-center">
                                        <DropletIcon class="w-4 h-4 mr-2 text-gray-500 dark:text-gray-400" />
                                        月用水量
                                    </Label>
                                    <div class="relative">
                                        <Input id="water-usage" v-model="waterUsage" type="number" placeholder="输入月用水量"
                                            class="pr-16" />
                                        <span
                                            class="absolute inset-y-0 right-0 flex items-center pr-3 text-sm text-gray-500 dark:text-gray-400">
                                            吨/月
                                        </span>
                                    </div>
                                </div>

                                <div class="space-y-2">
                                    <Label for="meat-consumption" class="flex items-center">
                                        <UtensilsIcon class="w-4 h-4 mr-2 text-gray-500 dark:text-gray-400" />
                                        每日肉类消耗量
                                    </Label>
                                    <div class="relative">
                                        <Input id="meat-consumption" v-model="meatConsumption" type="number"
                                            placeholder="输入每日肉类消耗量" class="pr-16" />
                                        <span
                                            class="absolute inset-y-0 right-0 flex items-center pr-3 text-sm text-gray-500 dark:text-gray-400">
                                            克/天
                                        </span>
                                    </div>
                                </div>

                                <Button type="submit" class="w-full flex items-center justify-center">
                                    <CalculatorIcon class="w-4 h-4 mr-2" />
                                    计算年度碳排放
                                </Button>
                            </form>
                        </CardContent>
                    </Card>
                </div>

                <div class="space-y-6">
                    <Card>
                        <CardHeader>
                            <CardTitle class="flex items-center">
                                <BarChartIcon class="w-5 h-5 mr-2 text-blue-500" />
                                年度碳排放结果
                            </CardTitle>
                        </CardHeader>
                        <CardContent>
                            <div v-if="totalEmissions !== null" class="space-y-4">
                                <div
                                    class="text-4xl font-bold text-center text-green-600 dark:text-green-400 flex items-center justify-center">
                                    <Co2Icon class="w-8 h-8 mr-2" />
                                    {{ totalEmissions.toFixed(2) }} kg CO₂
                                </div>
                                <p class="text-center">这是您的估计年度碳排放量占比图</p>
                                <div ref="chartRef" style="width: 100%; height: 300px;"></div>
                            </div>
                            <div v-else class="text-center text-gray-500 dark:text-gray-400">
                                请输入您的数据并点击计算按钮
                            </div>
                        </CardContent>
                    </Card>
                </div>

                <!-- 第二行：改善建议区域 -->
                <div class="lg:col-span-2">
                    <Card v-if="totalEmissions !== null">
                        <CardHeader>
                            <CardTitle class="flex items-center">
                                <LightbulbIcon class="w-5 h-5 mr-2 text-yellow-500" />
                                改善建议
                            </CardTitle>
                        </CardHeader>
                        <CardContent>
                            <ul class="list-none space-y-2">
                                <!-- 出行排放量超过1000千克CO2时，给出建议 -->
                                <li v-if="travelEmissions > 1000" class="flex items-start">
                                    <BikeIcon class="w-5 h-5 mr-2 text-green-500 flex-shrink-0 mt-1" />
                                    <span>考虑使用更环保的交通方式，如公共交通或自行车，可以显著减少您的碳排放。</span>
                                </li>

                                <!-- 用电排放量超过2000千克CO2时，给出建议 -->
                                <li v-if="electricityEmissions > 2000" class="flex items-start">
                                    <LightbulbIcon class="w-5 h-5 mr-2 text-yellow-500 flex-shrink-0 mt-1" />
                                    <span>尝试使用节能电器和LED灯泡，并在不使用时关闭电器，可以减少用电量。</span>
                                </li>

                                <!-- 用水排放量超过500千克CO2时，给出建议 -->
                                <li v-if="waterEmissions > 500" class="flex items-start">
                                    <DropletIcon class="w-5 h-5 mr-2 text-blue-500 flex-shrink-0 mt-1" />
                                    <span>安装节水装置和养成节水习惯可以帮助减少水资源浪费和相关的碳排放。</span>
                                </li>

                                <!-- 肉类消费量超过0.2千克CO2/天时，给出建议 -->
                                <li v-if="meatConsumption > 0.2" class="flex items-start">
                                    <LeafIcon class="w-5 h-5 mr-2 text-green-500 flex-shrink-0 mt-1" />
                                    <span>适当减少肉类消费，增加植物性食物的比例，可以降低您的碳足迹。</span>
                                </li>

                                <!-- 不论排放量多少，都建议使用可再生能源 -->
                                <li class="flex items-start">
                                    <SunIcon class="w-5 h-5 mr-2 text-yellow-500 flex-shrink-0 mt-1" />
                                    <span>考虑使用可再生能源，如安装太阳能板，可以进一步减少您的碳排放。</span>
                                </li>
                            </ul>
                        </CardContent>
                    </Card>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted, watch, nextTick } from 'vue'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { Button } from '@/components/ui/button'
import {
    Leaf as LeafIcon,
    ClipboardList as ClipboardListIcon,
    Car as CarIcon,
    Map as MapIcon,
    Bus as BusIcon,
    Train as TrainIcon,
    Plane as PlaneIcon,
    Zap as ZapIcon,
    Droplet as DropletIcon,
    Utensils as UtensilsIcon,
    Calculator as CalculatorIcon,
    BarChart as BarChartIcon,
    Component as Co2Icon,
    Lightbulb as LightbulbIcon,
    Bike as BikeIcon,
    Sun as SunIcon
} from 'lucide-vue-next'
import * as echarts from 'echarts'

const travelDistance = ref('')
const travelMode = ref('')
const electricityUsage = ref('')
const waterUsage = ref('')
const meatConsumption = ref('')

const totalEmissions = ref(null)
const travelEmissions = ref(0)
const electricityEmissions = ref(0)
const waterEmissions = ref(0)
const meatEmissions = ref(0)

const chartRef = ref(null)
let chart = null

const calculateEmissions = () => {
    const emissionFactors = {
        car: 0.2,
        bus: 0.1,
        train: 0.05,
        plane: 0.25,
        electricity: 0.785,
        water: 0.91,
        meat: 1.24
    };

    travelEmissions.value = parseFloat(travelDistance.value) * emissionFactors[travelMode.value] * 365
    electricityEmissions.value = parseFloat(electricityUsage.value) * emissionFactors.electricity * 12
    waterEmissions.value = parseFloat(waterUsage.value) * emissionFactors.water * 12
    meatEmissions.value = parseFloat(meatConsumption.value) * emissionFactors.meat * 365 / 1000
    totalEmissions.value = travelEmissions.value + electricityEmissions.value + waterEmissions.value + meatEmissions.value

    nextTick(() => {
        updateChart()
    })
}

const updateChart = () => {
    if (!chart) {
        if (chartRef.value) {
            chart = echarts.init(chartRef.value)
        } else {
            console.error('Chart container not found')
            return
        }
    }

    const data = [
        { value: travelEmissions.value, name: '出行排放' },
        { value: electricityEmissions.value, name: '用电排放' },
        { value: waterEmissions.value, name: '用水排放' },
        { value: meatEmissions.value, name: '肉类消耗排放' }
    ]

    const option = {
        tooltip: {
            trigger: 'item',
            formatter: '{a} <br/>{b}: {c} kg CO₂ ({d}%)'
        },
        legend: {
            orient: 'vertical',
            left: 'left',
            textStyle: {
                color: 'var(--text-color)'
            }
        },
        series: [
            {
                name: '碳排放来源',
                type: 'pie',
                radius: '50%',
                data: data,
                emphasis: {
                    itemStyle: {
                        shadowBlur: 10,
                        shadowOffsetX: 0,
                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                    }
                },
                label: {
                    show: true,
                    formatter: '{b}: {d}%',
                    color: 'var(--text-color)'
                }
            }
        ]
    }

    chart.setOption(option)
}

onMounted(() => {
    nextTick(() => {
        if (chartRef.value) {
            chart = echarts.init(chartRef.value)
        }
    })
})

watch([totalEmissions], () => {
    if (totalEmissions.value !== null) {
        nextTick(() => {
            updateChart()
        })
    }
})
</script>

<style>
:root {
    --text-color: #333;
}

.dark {
    --text-color: #fff;
}
</style>