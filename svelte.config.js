// svelte.config.js
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';
import adapter from '@sveltejs/adapter-vercel';
// svelte.config.js

// VERIFIQUE SE O SEU CÓDIGO ESTÁ ASSIM:

import adapter from '@sveltejs/adapter-vercel'; // <-- A linha de importação mudou

/** @type {import('@sveltejs/kit').Config} */
const config = {
  kit: {
    // ... outras configurações que você tenha
    adapter: adapter() // <-- A configuração do adaptador mudou para esta!
  }
};

export default config;