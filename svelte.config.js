// svelte.config.js
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';
import adapter from '@sveltejs/adapter-vercel';

/** @type {import('@sveltejs/kit').Config} */
const config = {
    preprocess: vitePreprocess(),

    kit: {
        // Configuração do Adaptador da Vercel
        adapter: adapter({
            // REGRA 1: Força a exclusão dos arquivos .wasm do pacote final da Vercel.
            // Esta é a nossa "marreta" para o problema de tamanho.
            exclude: [
                '**/node_modules/@huggingface/transformers/dist/*.wasm',
                '**/node_modules/onnxruntime-web/dist/*.wasm'
            ]
        }),
		
		// Configuração do Vite dentro do SvelteKit
		vite: {
			ssr: {
				// REGRA 2: Diz ao Vite para não tentar incluir essas bibliotecas no build do servidor.
				// Este é o nosso "bisturi".
				external: ['@huggingface/transformers', 'onnxruntime-web', 'kokoro-js']
			}
		}
    }
};

export default config;