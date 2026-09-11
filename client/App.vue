<script setup lang="ts">
import Header from './components/layout/FixedHeader.vue'
import Footer from './components/layout/Footer.vue';
</script>

<template>
  <div class="d-flex flex-column min-vh-100">
    <Header />
    <main class="flex-shrink-0">
      <div class="container mw-100em">
        <div class="my-5">
          <router-view></router-view>
        </div>
      </div>
    </main>
    <footer class="footer mt-auto p-3">
      <Footer />
    </footer>
  </div>
</template>

<style scoped>
.mw-100em {
  max-width: 35em;
}
</style>
<style>
body {
  /* add padding for fixed header */
  padding-top: 60px;

}

footer {
  background-color: #404040;
}
</style>
