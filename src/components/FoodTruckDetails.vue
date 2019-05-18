<template>
  <v-card>
    <v-img :src="truck.image" aspect-ratio="1.75"></v-img>

    <v-card-title primary-title>
      <div>
        <h3 class="headline mb-0">{{truck.name}}</h3>
        <div>{{ truck.description }}</div>
      </div>
    </v-card-title>

    <v-card-actions>
      <v-btn flat color="orange">Follow</v-btn>
    </v-card-actions>
  </v-card>
</template>

<script>
export default {
  props: { truck: Object }
};
</script>
