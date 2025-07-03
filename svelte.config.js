// svelte.config.js
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';
import adapter from '@sveltejs/adapter-vercel';

/** @type {import('@sveltejs/kit').Config} */
const config = {
    preprocess: vitePreprocess(),

    kit: {
        adapter: adapter({
            // Força a exclusão dos arquivos .wasm do pacote da função serverless
            exclude: [
                '**/node_modules/@huggingface/transformers/dist/*.wasm',
                '**/node_modules/onnxruntime-web/dist/*.wasm'
            ]
        }),
		
		// Adicionamos a configuração do Vite aqui, que é o lugar correto
		vite: {
			ssr: {
				external: ['@huggingface/transformers', 'onnxruntime-web', 'kokoro-js']
			}
		}
    }
};

export default config;