import { fileURLToPath, URL } from 'node:url'

import legacy from '@vitejs/plugin-legacy'
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import path from 'path'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    vue(),
    legacy({
      targets: ['defaults']
    })
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./client', import.meta.url))
    }
  },

  css: {
    preprocessorOptions: {
      scss: {
        quietDeps: true
      }
    }
  },

  root: 'client',

  build: {
    // output dir for production build
    outDir: 'dist',

    // our entry
    rollupOptions: {
      input: path.resolve(__dirname, 'client/index.html')
    }
  },

  server: {
    host: '0.0.0.0',
    strictPort: true,
    port: 5173,
    proxy: {
      '/api': {
        target: 'http://app:8000',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api/, '/api')
      }
    }
  }
})
