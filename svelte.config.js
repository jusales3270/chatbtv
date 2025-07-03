// svelte.config.js
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';
import adapter from '@sveltejs/adapter-vercel';

/** @type {import('@sveltejs/kit').Config} */
const config = {
    preprocess: vitePreprocess(),

    kit: {
        adapter: adapter({
            // REGRA 1: Exclui os arquivos .wasm do pacote final da Vercel.
            exclude: [
                '**/node_modules/@huggingface/transformers/dist/*.wasm',
                '**/node_modules/onnxruntime-web/dist/*.wasm'
            ]
        })
    },

    // REGRA 2: Fica aqui, no nível principal, e não dentro de 'kit'.
    // Diz ao Vite para não incluir essas bibliotecas no build do servidor.
    vite: {
        ssr: {
            external: ['@huggingface/transformers', 'onnxruntime-web', 'kokoro-js']
        }
    }
};

export default config;