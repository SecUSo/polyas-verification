<template>
    <header class="app-header">
        <div class="logo-container">
            <img src="@/assets/kit-logo.svg" alt="Logo" class="logo">
        </div>
    </header>
</template>

<script setup>
</script>

<style scoped>
.logo {
    height: 40px;
    width: auto;
}




.app-header {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 60px;
    background-color: #ffffff;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 12px;

    box-sizing: border-box;
    z-index: 1000;
    transition: background-color 0.2s ease;
}

.logo-container {
    display: flex;
    align-items: center;
    margin-top: 0.5em;
}
</style>