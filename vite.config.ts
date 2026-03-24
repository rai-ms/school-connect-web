import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import path from 'path';
import prerender from '@prerenderer/rollup-plugin';

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    react(),
    prerender({
      routes: ['/'],
      renderer: '@prerenderer/renderer-puppeteer',
      rendererOptions: {
        renderAfterTime: 3000,
      },
      postProcess(renderedRoute) {
        // Add prerendered flag so hydration works correctly
        renderedRoute.html = renderedRoute.html.replace(
          '<div id="root">',
          '<div id="root" data-server-rendered="true">'
        );
        return renderedRoute;
      },
    }),
  ],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
  server: {
    proxy: {
      '/api': {
        target: 'https://school-connect-6qt9.onrender.com',
        changeOrigin: true,
        secure: true,
        headers: {
          Origin: 'https://school-connect-6qt9.onrender.com',
        },
      },
    },
  },
  optimizeDeps: {
    exclude: ['lucide-react'],
  },
});
