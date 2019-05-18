<template>
  <MglMap
    :accessToken="accessToken"
    :zoom="12"
    :center="center"
    :mapStyle.sync="mapStyle"
    style="height:50vh;"
  >
    <MglNavigationControl position="top-right"/>
    <MglMarker v-if="geoposition" :coordinates="geoposition" color="blue">
      <v-icon slot="marker">location_on</v-icon>
    </MglMarker>
    <MglMarker
      v-for="location in userLocations"
      :coordinates="[location.geo.lon, location.geo.lat]"
      color="red"
    >
      <v-icon
        slot="marker"
        :color="selectedLocation ? (location.name == selectedLocation.name ? 'red' : 'blue') : 'blue'"
      >home</v-icon>
    </MglMarker>
    <MglMarker
      v-for="truck in trucks"
      :coordinates="truck.slot.wgsLocation"
      color="green"
      @click="$emit('truckSelected', truck)"
    >
      <v-icon slot="marker">commute</v-icon>
    </MglMarker>

    <v-btn fab dark small color="pink" @click.stop="getGeoposition">
      <v-icon dark>explore</v-icon>
    </v-btn>
  </MglMap>
</template>

<script>
import Mapbox from "mapbox-gl";
import { MglMap, MglMarker, MglPopup, MglNavigationControl } from "vue-mapbox";

const MAP_STYLE = "mapbox://styles/mapbox/light-v9";
const MAPBOX_TOKEN =
  "pk.eyJ1Ijoic3RhZG9sZiIsImEiOiJjanZza3JhOTUwaDBmM3ltazltaWtwemhzIn0.AJqLRwBrJNWDrbB7Uw9I1w";

export default {
  components: {
    MglMap,
    MglMarker,
    MglPopup,
    MglNavigationControl
  },
  props: {
    userLocations: Array,
    selectedLocation: Object,
    trucks: Array
  },
  data() {
    return {
      geoposition: null,
      center: [13, 52],
      mapStyle: MAP_STYLE,
      accessToken: MAPBOX_TOKEN
    };
  },
  async created() {
    this.mapbox = Mapbox; // We need to set mapbox-gl library here in order to use it in template
  },
  methods: {
    getGeoposition() {
      navigator.geolocation.getCurrentPosition(position => {
        this.geoposition = [
          position.coords.longitude,
          position.coords.latitude
        ];
        this.center = this.geoposition;
        this.$emit("locationChange", {
          lat: position.coords.latitude,
          lon: position.coords.longitude
        });
      });
    }
  },
  watch: {
    selectedLocation: function(newVal, oldVal) {
      // watch it
      //console.log("Prop changed: ", newVal, " | was: ", oldVal);
      this.center = [newVal.geo.lon, newVal.geo.lat];
    }
  }
};
</script>