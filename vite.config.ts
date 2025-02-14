import tailwind from "tailwindcss";
import autoprefixer from "autoprefixer";
import { defineConfig, loadEnv } from "vite";
import vue from "@vitejs/plugin-vue";
import path from "path";
export default defineConfig(({ mode }) => {
    const env = loadEnv(mode, process.cwd(), "");
    console.log(env.VITE_APP_URL);
    return {
        // vite 配置
        plugins: [vue()],
        resolve: {
            alias: {
                "@": path.resolve(__dirname, "./src"),
            },
        },
        css: {
            postcss: {
                plugins: [tailwind(), autoprefixer()],
            },
        },
        preview: {
            port: 5174,
        },
        server: {
            port: 5174,
            proxy: {
                "/api": {
                    target: env.VITE_APP_URL,
                    changeOrigin: true,
                    rewrite: (path) => path.replace(/^\/api/, ""),
                },
                "/img": {
                    target: "https://jj-tlias.oss-cn-hangzhou.aliyuncs.com",
                    changeOrigin: true,
                    rewrite: (path) => path.replace(/^\/img/, ""),
                },
            },
            base: "./",
        },
    };
});
