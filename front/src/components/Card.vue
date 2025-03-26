<script setup lang="ts">
defineProps<{
  operadora: any;
}>();
</script>

<template>
  <div class="operadora-card">
    <h3>{{ operadora.Nome_Fantasia || operadora.Razao_Social }}</h3>
    <div class="details">
      <p><strong>Razão Social:</strong> {{ operadora.Razao_Social }}</p>
      <p><strong>Modalidade:</strong> {{ operadora.Modalidade }}</p>
      <p>
        <strong>Localização:</strong> {{ operadora.Cidade }}/{{ operadora.UF }}
      </p>
      <p>
        <strong>Telefone:</strong> {{ operadora.Telefone || "Não informado" }}
      </p>
      <p><strong>Registro ANS:</strong> {{ operadora.Registro_ANS }}</p>
    </div>
  </div>
</template>

<style scoped>
.operadora-card {
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 16px;
  margin-bottom: 16px;
  background-color: #fff;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.operadora-card h3 {
  margin-top: 0;
  color: #2c3e50;
}

.details p {
  margin: 8px 0;
}

strong {
  color: #555;
}
</style>
