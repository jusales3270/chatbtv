import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';
import adapter from '@sveltejs/adapter-vercel'; // 1. Importa o adaptador correto

/** @type {import('@sveltejs/kit').Config} */
const config = {
    preprocess: vitePreprocess(),

    kit: {
        // 2. Usa o adaptador da Vercel no lugar do antigo
        adapter: adapter()
    }
};

export default config;
