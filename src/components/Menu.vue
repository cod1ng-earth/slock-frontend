<template>
  <v-navigation-drawer
    v-bind:value="value"
    v-on:input="$emit('input', $event)"
    absolute
    temporary
    dark
  >
    <v-list class="pa-1">
      <v-list-tile avatar v-if="user">
        <v-list-tile-avatar>
          <img :src="user.avatarUrl">
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

    <v-list class="pt-0">
      <v-divider></v-divider>

      <v-list-tile @click.prevent="logout">
        <v-list-tile-action>
          <v-icon>logout</v-icon>
        </v-list-tile-action>
        <v-list-tile-content>
          <v-list-tile-title>Logout</v-list-tile-title>
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
      userName: ""
    };
  },
  computed: {
    user() {
      return this.$store.state.user.userName ? this.$store.state.user : false;
    }
  },
  created() {
    const userName = localStorage.getItem("userName");
    if (userName) {
      this.userName = userName;
      this.login();
    }
  },
  methods: {
    logout() {
      console.log("logout");
      this.userName = "";
      localStorage.removeItem("userName");
      this.$store.commit("setUser", {});
    },
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
      localStorage.setItem("userName", this.userName);
      this.userName = "";
      const user = result.data.customers.edges[0].node;
      this.$store.commit("setUser", user);
    }
  }
};
</script>
