<template>
  <p v-if="!truck"></p>
  <v-layout v-else>
    <v-flex>
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

      <v-list>
        <v-subheader>Join the lunch train</v-subheader>
        <v-list-tile v-for="slot in truck.slots" :key="slot.slot.name" avatar @click>
          <v-list-tile-avatar color="grey">{{slot.day.slice(0,2) }}</v-list-tile-avatar>

          <v-list-tile-content>
            <v-list-tile-title v-html="slot.slot.name"></v-list-tile-title>
          </v-list-tile-content>

          <v-list-tile-action>
            <v-icon>train</v-icon>
          </v-list-tile-action>
        </v-list-tile>
      </v-list>
    </v-flex>
  </v-layout>
</template>

<script>
import FoodTruckMap from "../components/FoodTruckMap";
import axios from "axios";

export default {
  props: ["id"],
  components: {
    FoodTruckMap
  },
  data() {
    return {
      truck: null
    };
  },
  async created() {
    const response = await this.axios.get(
      "http://www.mocky.io/v2/5cdf3dbe3000004600430d50"
    );
    this.truck = response.data;
    this.truck.id = this.id;
  }
};
</script>
