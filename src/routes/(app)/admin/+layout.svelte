<script lang="ts">
	import { page } from '$app/stores';
	import { getContext } from 'svelte';
	import type { Writable } from 'svelte/store';
	import type { I18n } from 'i18next';

	import AdminPanel from '$lib/components/admin/AdminPanel.svelte';

	const i18n = getContext<Writable<I18n>>('i18n');

	const tabs = [
		{
			id: 'users',
			name: 'Users',
			href: '/admin'
		},
		{
			id: 'evaluations',
			name: 'Evaluations',
			href: '/admin/evaluations'
		},
		{
			id: 'functions',
			name: 'Functions',
			href: '/admin/functions'
		},
		{
			id: 'settings',
			name: 'Settings',
			href: '/admin/settings'
		}
	];
</script>

<svelte:head>
	<title>{$i18n.t('Admin')} • {$WEBUI_NAME}</title>
</svelte:head>

<AdminPanel>
	<div class="flex-1 flex flex-col overflow-y-auto">
		<div class="p-4 space-y-2">
			{#each tabs as tab}
				<a
					class="flex items-center space-x-2 px-3 py-2 rounded-lg {$page.url.pathname === tab.href
						? 'bg-gray-200 dark:bg-gray-700'
						: 'text-gray-500 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-800'}"
					href={tab.href}
				>
					<span>{$i18n.t(tab.name)}</span>
				</a>
			{/each}
		</div>
	</div>

	<div class="flex-1 p-4">
		<slot />
	</div>
</AdminPanel>
