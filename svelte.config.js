import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';
import adapter from '@sveltejs/adapter-vercel';

/** @type {import('@sveltejs/kit').Config} */
const config = {
    preprocess: vitePreprocess(),

    kit: {
        // MODIFICAÇÃO AQUI
        adapter: adapter({
            // Esta configuração força a exclusão de arquivos do pacote final da função.
            // É a nossa ferramenta mais poderosa contra o erro de tamanho.
            exclude: [
                '**/node_modules/@huggingface/transformers/dist/*.wasm',
                '**/node_modules/onnxruntime-web/dist/*.wasm'
            ]
        })
    },

    vite: {
        ssr: {
            // A linha noExternal provavelmente não é necessária, vamos simplificar.
            // Se ocorrer um erro sobre '@internationalized/date', podemos adicioná-la de volta.
            external: ['@huggingface/transformers', 'onnxruntime-web', 'kokoro-js']
        }
    }
};

export default config;