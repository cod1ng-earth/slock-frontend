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
      v-for="loc in userLocations"
      :coordinates="[loc.location.longitude, loc.location.latitude]"
      color="red"
    >
      <div
        :style="{ width: 50 + 'px', height: 50 + 'px', backgroundSize: 50+'px', backgroundImage: `url(${img.imgBuilding})`}"
        slot="marker"
      ></div>
    </MglMarker>
    <MglMarker
      v-for="booking in bookings"
      :coordinates="[booking.slot.location.longitude, booking.slot.location.latitude]"
      @click="$emit('bookingSelected', booking)"
    >
      <div
        :style="{ width: 40 + 'px', height: 40 + 'px', backgroundSize: 40+'px', backgroundImage: `url(${img.imgTruck})`}"
        slot="marker"
      ></div>
    </MglMarker>

    <v-btn fab dark small color="pink" @click.stop="getGeoposition">
      <v-icon dark>explore</v-icon>
    </v-btn>
  </MglMap>
</template>

<script>
import Mapbox from "mapbox-gl";
import { MglMap, MglMarker, MglPopup, MglNavigationControl } from "vue-mapbox";

import imgTruck from "../assets/foodtruck.png";
import imgBuilding from "../assets/building.png";
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
    bookings: Array
  },
  data() {
    return {
      img: { imgTruck, imgBuilding },
      geoposition: null,
      center: [13, 52],
      mapStyle: process.env.VUE_APP_MAPBOX_MAP_STYLE,
      accessToken: process.env.VUE_APP_MAPBOX_TOKEN
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
      this.center = [newVal.location.longitude, newVal.location.latitude];
    }
  }
};
</script>