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
          item-text="name"
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
      :trucks="trucks"
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
    userLocations: [],
    trucks: []
  }),
  async created() {
    const response = await this.axios.get(
      "https://www.mocky.io/v2/5cdfc651330000ff11608b21"
    );
    this.user = response.data;
    this.userLocations = response.data.locations;
  },
  methods: {
    showTruckDetails(truck) {
      console.log(truck);
      this.sheet = true;
      this.chosenTruck = truck.truck;
    },
    locationSelected(location) {
      this.selectedLocation = location;
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
    }
  }
};
</script>

<style></style>
