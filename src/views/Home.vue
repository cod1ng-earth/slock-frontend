<template>
  <div>
    <v-bottom-sheet v-model="sheet" v-if="chosenBooking">
      <BookingDetails :booking="chosenBooking" :date="selectedDate"/>
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
        <v-select
          :items="dates"
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
      :allLocations="allLocations"
      :userLocations="userLocations"
      :selectedLocation="selectedLocation"
      v-on:bookingSelected="showBookingDetails"
      v-on:locationChanged="searchTrucks"
    />
  </div>
</template>

<script>
import BookingDetails from "@/components/BookingDetails.vue";
import TruckMap from "@/components/TruckMap.vue";

import QUERY_BOOKINGS from "../gql/bookings.gql";
import QUERY_LOCATIONS from "../gql/locations.gql";

export default {
  components: {
    BookingDetails,
    TruckMap
  },
  data: () => ({
    sheet: false,
    chosenBooking: null,
    selectedLocation: null,
    selectedDate: null,
    locations: null,
    customerLocations: null,
    bookings: [],
    dates: [
      {
        label: "heute",
        date: "2019-05-18"
      },
      {
        label: "morgen",
        date: "2019-05-19"
      },
      {
        label: "übermorgen",
        date: "2019-05-20"
      }
    ]
  }),

  created() {
    this.dates = [
      {
        label: "heute",
        date: this.getDateWithOffset()
      },
      {
        label: "morgen",
        date: this.getDateWithOffset(1)
      },
      {
        label: "übermorgen",
        date: this.getDateWithOffset(2)
      }
    ];
  },

  apollo: {
    locations: {
      query: QUERY_LOCATIONS
    }
  },

  computed: {
    allLocations() {
      if (!this.locations) {
        return [];
      }

      const locations = this.locations.edges.map(
        e => ({
          id: e.node.id,
          latitude: e.node.latitude,
          longitude: e.node.longitude,
          name: e.node.name
        })
      );

      return locations;
    },

    userLocations() {
      if (!this.$store.state.user.userName) return [];

      const customerLocations = this.$store.state.user.customerLocations.edges.map(
        e => ({
          location: e.node.location
        })
      );
      return customerLocations;
    }
  },

  methods: {
    showBookingDetails(booking) {
      this.sheet = true;
      this.chosenBooking = booking;
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
    },
    getDateWithOffset(offset) {
      offset = offset || 0;
      let date = new Date();
      date.setDate(date.getDate() + offset);
      return date.toISOString().split('T').shift();
    }
  }
};
</script>

<style></style>
