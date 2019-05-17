<template>
  <div>
    <v-layout>
      <v-flex xs6 d-flex>
        <v-select :items="locations" box label="Location"></v-select>
      </v-flex>
      <v-flex xs6 d-flex>
        <v-select :items="dates" box label="Date"></v-select>
      </v-flex>
    </v-layout>

    <MglMap
      :accessToken="accessToken"
      :zoom="12"
      :center="center"
      :mapStyle.sync="mapStyle"
      style="height:50vh;"
    >
      <MglMarker :coordinates="coordinates" color="blue" @click="gotoFoodTruck"></MglMarker>
    </MglMap>

    <v-container>
      <v-layout wrap>content</v-layout>
    </v-container>
  </div>
</template>

<script>
import Mapbox from "mapbox-gl";
import { MglMap, MglMarker, MglPopup } from "vue-mapbox";

export default {
  components: {
    MglMap,
    MglMarker,
    MglPopup
  },
  data: () => ({
    locations: ["Büro 1", "Karlsruhe"],
    dates: ["heute", "morgen", "übermorgen"],
    center: [13, 52],
    coordinates: [13, 52],
    mapStyle: "mapbox://styles/mapbox/light-v9",
    accessToken:
      "pk.eyJ1Ijoic3RhZG9sZiIsImEiOiJjanZza3JhOTUwaDBmM3ltazltaWtwemhzIn0.AJqLRwBrJNWDrbB7Uw9I1w"
  }),
  created() {
    this.mapbox = Mapbox; // We need to set mapbox-gl library here in order to use it in template
  },
  methods: {
    gotoFoodTruck() {
      this.$router.push({ name: "truck", params: { id: "stefan" } });
    }
  }
};
</script>

<style></style>
