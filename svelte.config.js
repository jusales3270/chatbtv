// svelte.config.js

import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';
import adapter from '@sveltejs/adapter-vercel';

/** @type {import('@sveltejs/kit').Config} */
const config = {
  // Consulte https://kit.svelte.dev/docs/integrations#preprocessors
  // para mais informações sobre preprocessors
  preprocess: vitePreprocess(),

  kit: {
    // A configuração do adapter foi atualizada para usar o adapter da Vercel.
    // Isso garante a configuração correta para o deploy na plataforma.
    adapter: adapter(),

    // Se você tiver um alias para o $lib, ele deve ficar aqui dentro de `kit`.
    // Exemplo:
    // alias: {
    //   $lib: 'src/lib'
    // }
  }
};

export default config;