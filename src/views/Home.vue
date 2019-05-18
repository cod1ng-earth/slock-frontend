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
        <v-select :items="dates"
                  @change="dateChanged"
                  item-text="label"
                  item-value="date"
                  box
                  label="Date"
        ></v-select>
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
    selectedDate: null,
    dates: [
      {
        label: "heute",
        date: '2019-05-18'
      },
      {
        label:"morgen",
        date: '2019-05-19'
      }
      ,
      {
        label:"übermorgen",
        date: '2019-05-20'
      }
    ],
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
      this.searchTrucks();
    },
    dateChanged(date) {
      this.selectedDate = date;
      this.searchTrucks();
    },
    async searchTrucks() {
      if (!this.selectedLocation || !this.selectedDate) {
        return;
      }

      const result = await this.$apollo.query({
        query: QUERY_BOOKINGS,
        variables: {
            latitude: parseFloat(this.selectedLocation.location.latitude),
            longitude: parseFloat(this.selectedLocation.location.longitude),
            distance: 10000,
            date: this.selectedDate
        }
      });

      this.bookings = result.data.bookings.edges.map(e => e.node);
    }
  }
};
</script>

<style></style>
