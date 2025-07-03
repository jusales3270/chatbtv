// svelte.config.js
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';
import adapter from '@sveltejs/adapter-vercel';

/** @type {import('@sveltejs/kit').Config} */
const config = {
    preprocess: vitePreprocess(),

    kit: {
        adapter: adapter({
            // Exclui os arquivos .wasm do pacote final da Vercel.
            exclude: [
                '**/node_modules/@huggingface/transformers/dist/*.wasm',
                '**/node_modules/onnxruntime-web/dist/*.wasm'
            ]
        })
    }
};

export default config;