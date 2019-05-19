<template>
  <div v-if="$apollo.loading">Loading...</div>
  <v-card v-else>
    <v-img v-if="truck.imageUrl" :src="truck.imageUrl" aspect-ratio="1.75"></v-img>

    <v-card-title primary-title>
      <div>
        <h3 class="headline mb-0">{{ truck.name }}</h3>
        <div>{{ truck.description }}</div>
      </div>
    </v-card-title>

    <v-list three-line>
      <v-subheader>Lunch Trains on {{ booking.date }}</v-subheader>
      <v-list-tile v-for="train in lunchTrainNodes"
                   :key="train.id">
        <v-list-tile-avatar>
          <img :src="train.operator.avatarUrl" />
        </v-list-tile-avatar>
        <v-list-tile-content>
          <v-list-tile-title v-html="train.operator.userName"></v-list-tile-title>
          <v-list-tile-sub-title v-html="train.leavesAt"></v-list-tile-sub-title>
          <v-list-tile-sub-title>
            <v-avatar v-for="edge in train.riders.edges"
                      :key="edge.node.id"
                      :tile="false"
                      :size="20">
              <img :src="edge.node.avatarUrl" :alt="edge.node.userName" />
            </v-avatar>
          </v-list-tile-sub-title>
        </v-list-tile-content>
        <v-list-tile-action>
          <v-btn flat color="orange" @click="joinLunchTrain(train)">Join</v-btn>
        </v-list-tile-action>
      </v-list-tile>
    </v-list>
    <v-card-actions>
      <v-btn flat color="orange" @click="createLunchTrain">Create a lunch train</v-btn>
    </v-card-actions>
  </v-card>
</template>

<script>
import QUERY_LUNCHTRAINS from "../gql/lunchtrains.gql";

export default {
  props: {
    booking: Object
  },
  data() {
    return {
      lunchTrains: null
    };
  },
  methods: {
    async joinLunchTrain(train) {
      const url =
        process.env.VUE_APP_API_ENDPOINT +
        `${train.id}/rider/${this.$store.state.user._id}`;
      await this.axios.post(url, {});
      this.$apollo.queries.lunchTrains.refetch();
    },
    createLunchTrain() {}
  },
  computed: {
    lunchTrainNodes() {
      return this.lunchTrains.edges.map(e => e.node);
    },
    truck() {
      return this.booking.foodTruck;
    }
  },
  apollo: {
    lunchTrains: {
      query: QUERY_LUNCHTRAINS,
      variables() {
        return {
          booking: this.booking.id
        };
      }
    }
  }
};
</script>
