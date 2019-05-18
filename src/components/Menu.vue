<template>
  <v-navigation-drawer v-bind:value="value" v-on:input="$emit('input', $event)" absolute temporary>
    <v-list class="pa-1">
      <v-list-tile avatar v-if="user">
        <v-list-tile-avatar>
          <img :src="user.avatarUrl"></img>
        </v-list-tile-avatar>

        <v-list-tile-content>
          <v-list-tile-title>{{ user.userName }}</v-list-tile-title>
        </v-list-tile-content>
      </v-list-tile>
      <v-list-tile v-else>
        <form @submit.prevent="login">
          <v-text-field v-model="userName" label="Login, please"></v-text-field>
        </form>
      </v-list-tile>
    </v-list>

    <v-list class="pt-0" dense>
      <v-divider></v-divider>

      <v-list-tile v-for="item in items" :key="item.title">
        <v-list-tile-action>
          <v-icon>{{ item.icon }}</v-icon>
        </v-list-tile-action>

        <v-list-tile-content>
          <v-list-tile-title>{{ item.title }}</v-list-tile-title>
        </v-list-tile-content>
      </v-list-tile>
    </v-list>
  </v-navigation-drawer>
</template>

<script>
import CUSTOMER_QUERY from "../gql/customer.gql";

export default {
  props: {
    value: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      userName: "",
      items: [
        { title: "Home", icon: "dashboard" },
        { title: "About", icon: "question_answer" }
      ]
    };
  },
  computed: {
    user() { 
      return this.$store.state.user.userName ?  this.$store.state.user : false
    }
  },
  methods: {
    async login() {
      const result = await this.$apollo.query({
        query: CUSTOMER_QUERY,
        variables: {
          userName: this.userName
        }
      });

      if (!result) {
        console.err("User not found");
        return;
      }

      const user = result.data.customers.edges[0].node;
      this.$store.commit("setUser", user);
    },

    logout() {}
  }
};
</script>
