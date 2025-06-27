import adapter from '@sveltejs/adapter-node'; // <-- MUDANÇA AQUI
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';

/** @type {import('@sveltejs/kit').Config} */
const config = {
	// Consult https://kit.svelte.dev/docs/integrations#preprocessors
	// for more information about preprocessors
	preprocess: vitePreprocess(),

	kit: {
		// adapter-auto only supports some environments, see https://kit.svelte.dev/docs/adapter-auto for a list.
		// If your environment is not supported or you settled on a specific environment, switch out the adapter.
		// See https://kit.svelte.dev/docs/adapters for more information about adapters.
		adapter: adapter(), // <-- MUDANÇA AQUI
		alias: {
			$lib: "src/lib",
			"$lib/*": "src/lib/*",
			"$components/*": "src/lib/components/*",
			"$ts/*": "src/lib/ts/*",
			"$stores/*": "src/lib/stores/*"
		}
	}
};

export default config;
