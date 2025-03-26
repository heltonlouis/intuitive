<script setup lang="ts">
import { ref } from "vue";
// @ts-ignore
import Card from "./components/Card.vue";

const termoBusca = ref("");
const resultados = ref<any[]>([]);
const carregando = ref(false);

let timeout: ReturnType<typeof setTimeout>;

const buscarOperadoras = async () => {
  if (!termoBusca.value.trim()) {
    resultados.value = [];
    return;
  }

  clearTimeout(timeout);
  timeout = setTimeout(() => {
    carregando.value = true;
    fetch(
      `http://localhost:5005/api/buscar?termo=${encodeURIComponent(
        termoBusca.value
      )}&limite=20`
    )
      .then(async (response) => {
        resultados.value = await response.json();
      })
      .catch((error) => {
        console.error("Erro na busca:", error);
        resultados.value = [];
      })
      .finally(() => {
        carregando.value = false;
      });
  }, 500);
};
</script>

<template>
  <div class="app">
    <header>
      <h1>Busca de Operadoras de Saúde</h1>
      <div class="search-container">
        <input
          type="text"
          v-model="termoBusca"
          @input="buscarOperadoras"
          placeholder="Digite nome, cidade ou estado..."
        />
        <button @click="buscarOperadoras">Buscar</button>
      </div>
    </header>

    <main>
      <div v-if="carregando" class="loading">Carregando...</div>

      <div v-if="resultados.length > 0">
        <h2>Resultados ({{ resultados.length }})</h2>
        <Card
          v-for="operadora in resultados"
          :key="operadora.registro_ans"
          :operadora="operadora"
        />
      </div>

      <div v-else-if="termoBusca && !carregando" class="no-results">
        Nenhuma operadora encontrada para "{{ termoBusca }}"
      </div>

      <div v-else class="instructions">
        <p>Digite um termo de busca para encontrar operadoras de saúde.</p>
        <p>Você pode buscar por nome, cidade ou estado.</p>
      </div>
    </main>
  </div>
</template>

<style>
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

body {
  font-family: Arial, sans-serif;
  line-height: 1.6;
  background-color: #f5f5f5;
  color: #333;
}

.app {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

header {
  background-color: #3498db;
  color: white;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 20px;
  text-align: center;
}

header h1 {
  margin-bottom: 20px;
}

.search-container {
  display: flex;
  max-width: 600px;
  margin: 0 auto;
}

.search-container input {
  flex: 1;
  padding: 10px;
  font-size: 16px;
  border: none;
  border-radius: 4px 0 0 4px;
}

.search-container button {
  padding: 10px 20px;
  background-color: #2980b9;
  color: white;
  border: none;
  border-radius: 0 4px 4px 0;
  cursor: pointer;
  font-size: 16px;
}

.search-container button:hover {
  background-color: #1a6ea0;
}

main {
  background-color: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

h2 {
  margin-bottom: 16px;
  color: #2c3e50;
}

.loading,
.no-results,
.instructions {
  text-align: center;
  padding: 20px;
  color: #666;
}
</style>
