<template>
  <div>
    <MglMap
      :accessToken="accessToken"
      :zoom="12"
      :center="center"
      :mapStyle.sync="mapStyle"
      style="height:50vh;"
    >
      <MglMarker :coordinates="coordinates" color="blue">
        <MglPopup :onlyText="true">
          <div>Hello, I'm a popup!</div>
        </MglPopup>
      </MglMarker>
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
    center: [13, 52],
    coordinates: [13, 52],
    mapStyle: "mapbox://styles/mapbox/light-v9",
    accessToken:
      "pk.eyJ1Ijoic3RhZG9sZiIsImEiOiJjanZza3JhOTUwaDBmM3ltazltaWtwemhzIn0.AJqLRwBrJNWDrbB7Uw9I1w"
  }),
  created() {
    this.mapbox = Mapbox; // We need to set mapbox-gl library here in order to use it in template
  }
};
</script>

<style></style>
