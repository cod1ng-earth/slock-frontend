<template>
  <div>
    <v-bottom-sheet v-model="sheet" v-if="chosenTruck">
      <FoodTruckDetails :truck="chosenTruck"/>
    </v-bottom-sheet>
    <v-layout>
      <v-flex xs6 d-flex>
        <v-select
          :items="userLocations"
          @change="locationChanged"
          item-text="name"
          item-value="geo"
          box
          label="Location"
        ></v-select>
      </v-flex>
      <v-flex xs6 d-flex>
        <v-select :items="dates" @change="dateChanged" box label="Date"></v-select>
      </v-flex>
    </v-layout>

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
      <MglMarker v-if="selectedLocation" :coordinates="selectedLocation" color="red">
        <v-icon slot="marker">home</v-icon>
      </MglMarker>
      <MglMarker
        v-for="truck in trucks"
        :coordinates="truck.slot.wgsLocation"
        color="green"
        @click="gotoFoodTruck(truck)"
      >
        <v-icon slot="marker">commute</v-icon>
      </MglMarker>

      <v-btn fab dark small color="pink" @click.stop="getGeoposition">
        <v-icon dark>explore</v-icon>
      </v-btn>
    </MglMap>
  </div>
</template>

<script>
import Mapbox from "mapbox-gl";
import { MglMap, MglMarker, MglPopup, MglNavigationControl } from "vue-mapbox";
import FoodTruckDetails from "@/components/FoodTruckDetails.vue";

const MAP_STYLE = "mapbox://styles/mapbox/light-v9";
const MAPBOX_TOKEN =
  "pk.eyJ1Ijoic3RhZG9sZiIsImEiOiJjanZza3JhOTUwaDBmM3ltazltaWtwemhzIn0.AJqLRwBrJNWDrbB7Uw9I1w";

export default {
  components: {
    MglMap,
    MglMarker,
    MglPopup,
    MglNavigationControl,
    FoodTruckDetails
  },
  data: () => ({
    sheet: false,
    chosenTruck: null,
    userLocations: [],
    selectedLocation: null,
    trucks: [],
    dates: ["heute", "morgen", "übermorgen"],
    geoposition: null,
    center: [13, 52],
    mapStyle: MAP_STYLE,
    accessToken: MAPBOX_TOKEN
  }),
  async created() {
    this.mapbox = Mapbox; // We need to set mapbox-gl library here in order to use it in template
    const response = await this.axios.get(
      "https://www.mocky.io/v2/5cdfc651330000ff11608b21"
    );
    this.user = response.data;
    this.userLocations = response.data.locations;
  },
  methods: {
    gotoFoodTruck(truck) {
      console.log(truck);
      this.sheet = true;
      this.chosenTruck = truck.truck;

      //this.$router.push({ name: "truck", params: { id: "stefan" } });
    },
    locationChanged(location) {
      const schummel = [location.lon, location.lat];
      this.selectedLocation = schummel;
      this.center = schummel;
      this.searchTrucks(location);
    },
    dateChanged(date) {
      console.log(date);
    },
    async searchTrucks(location) {
      const response = await this.axios.get(
        "https://www.mocky.io/v2/5cdfc184330000ff11608b1e"
      );

      const trucks = response.data.trucks.map(truck => {
        truck.slot.wgsLocation = [
          truck.slot.location.lon,
          truck.slot.location.lat
        ];
        return truck;
      });
      this.trucks = trucks;
    },
    getGeoposition() {
      navigator.geolocation.getCurrentPosition(position => {
        this.geoposition = [
          position.coords.longitude,
          position.coords.latitude
        ];
        this.center = this.geoposition;
        this.searchTrucks({
          lat: position.coords.latitude,
          lon: position.coords.longitude
        });
      });
    }
  }
};
</script>

<style></style>
