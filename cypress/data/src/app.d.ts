// src/app.d.ts
import type { i18n as I18n } from 'i18next';
import type { Writable } from 'svelte/store';

declare global {
	var i18n: Writable<I18n>;

	namespace App {
		// interface Error {}
		// interface Locals {}
		// interface PageData {}
		// interface Platform {}
	}
}

export {};
