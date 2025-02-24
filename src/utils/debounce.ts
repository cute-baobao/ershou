// 防抖函数：用于限制函数的执行频率，在一定时间内多次触发只会执行最后一次
function debounce<T extends (...args: any[]) => any>(fn: T, delay: number) {
    let timer:number | null = null;
    
    return function(this: any, ...args: Parameters<T>) {
        if (timer) {
            clearTimeout(timer);
        }
        
        const context = this;
        
        timer = window.setTimeout(() => {
            fn.apply(context, args);
            timer = null;
        }, delay);
    }
}

export default debounce;