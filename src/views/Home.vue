<template>
  <div>
    <v-bottom-sheet v-model="sheet" v-if="chosenTruck">
      <FoodTruckDetails :truck="chosenTruck"/>
    </v-bottom-sheet>
    <v-layout>
      <v-flex xs6 d-flex>
        <v-select
          :items="userLocations"
          @change="locationSelected"
          item-text="location.name"
          return-object
          box
          label="Location"
        ></v-select>
      </v-flex>
      <v-flex xs6 d-flex>
        <v-select :items="dates" @change="dateChanged" box label="Date"></v-select>
      </v-flex>
    </v-layout>

    <TruckMap
      :bookings="bookings"
      :userLocations="userLocations"
      :selectedLocation="selectedLocation"
      v-on:truckSelected="showTruckDetails"
      v-on:locationChanged="searchTrucks"
    />
  </div>
</template>

<script>
import FoodTruckDetails from "@/components/FoodTruckDetails.vue";
import TruckMap from "@/components/TruckMap.vue";

import QUERY_BOOKINGS from "../gql/bookings.gql";

export default {
  components: {
    FoodTruckDetails,
    TruckMap
  },
  data: () => ({
    sheet: false,
    chosenTruck: null,
    selectedLocation: null,
    dates: ["heute", "morgen", "übermorgen"],
    customerLocations: null,
    bookings: []
  }),
  computed: {
    userLocations() {
      if (!this.$store.state.user.userName) return [];

      const locations = this.$store.state.user.customerLocations.edges.map(
        e => ({
          id: e.node.id,
          location: e.node.location
        })
      );
      return locations;
    }
  },

  methods: {
    showTruckDetails(truck) {
      this.sheet = true;
      this.chosenTruck = truck;
    },
    locationSelected(location) {
      this.selectedLocation = location;
      this.searchTrucks(location.location);
    },
    dateChanged(date) {
      console.log(date);
    },
    async searchTrucks(location) {
      console.log(location);
      const result = await this.$apollo.query({
        query: QUERY_BOOKINGS
      });

      this.bookings = result.data.bookings.edges.map(e => e.node);
    }
  }
};
</script>

<style></style>
