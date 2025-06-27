import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';
import { viteStaticCopy } from 'vite-plugin-static-copy';

export default defineConfig({
	plugins: [
		sveltekit(),
		viteStaticCopy({
			targets: [
				{
					src: 'node_modules/onnxruntime-web/dist/*.jsep.*',
					dest: 'wasm'
				},
				{
					src: 'node_modules/onnxruntime-web/dist/*.wasm',
					dest: 'wasm'
				}
			]
		})
	],
	define: {
		APP_VERSION: JSON.stringify(process.env.npm_package_version),
		APP_BUILD_HASH: JSON.stringify(process.env.APP_BUILD_HASH || 'dev-build')
	},
	build: {
		sourcemap: true,
		rollupOptions: {
			external: [],
			output: {
				manualChunks: {
					'onnxruntime-web': ['onnxruntime-web']
				}
			}
		}
	},
	worker: {
		format: 'es'
	},
	optimizeDeps: {
		exclude: ['onnxruntime-web']
	},
	ssr: {
		noExternal: ['onnxruntime-web']
	}
});
