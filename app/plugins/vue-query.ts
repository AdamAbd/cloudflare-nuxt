import { VueQueryPlugin, QueryClient, dehydrate, hydrate } from '@tanstack/vue-query'
import { defineNuxtPlugin, useState } from '#app'

export default defineNuxtPlugin((nuxtApp) => {
  const queryClient = new QueryClient({
    defaultOptions: {
      queries: {
        staleTime: 5000,
      },
    },
  })
  const vueQueryPluginOptions = {
    queryClient,
  }

  nuxtApp.vueApp.use(VueQueryPlugin, vueQueryPluginOptions)

  if (import.meta.server) {
    nuxtApp.hooks.hook('app:rendered', () => {
      nuxtApp.payload.vueQueryState = dehydrate(queryClient)
    })
  }

  if (import.meta.client) {
    hydrate(queryClient, nuxtApp.payload.vueQueryState)
  }
})
