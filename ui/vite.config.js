import { defineConfig } from 'vite'
import { svelte } from '@sveltejs/vite-plugin-svelte'
import postcss from './postcss.config.js';

// https://vitejs.dev/config/
export default defineConfig({
  css: {
    postcss,
  },
  plugins: [svelte({
    /* plugin options */
  })],
  optimizeDeps: {
    exclude: ['totalist', 'sirv', 'local-access']
  },
  base: './', // fivem nui needs to have local dir reference
  build: {
    emptyOutDir: true,
    outDir: '../html',
    assetsDir: './',
    rollupOptions: {
      output: {
        // By not having hashes in the name, you don't have to update the manifest, yay!
        entryFileNames: `[name].js`,
        chunkFileNames: `[name].js`,
        assetFileNames: `[name].[ext]`
      }
    }
  }
  
})
