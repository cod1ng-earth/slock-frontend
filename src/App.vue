<template>
  <v-app>
    <v-toolbar app>
      <v-toolbar-side-icon @click.stop="drawer = !drawer"></v-toolbar-side-icon>
      <v-toolbar-title class="headline text-uppercase">
        <span>SLOCK</span>
      </v-toolbar-title>
    </v-toolbar>

    <v-content>
      <router-view></router-view>
      <Menu v-model="drawer"/>
    </v-content>
  </v-app>
</template>

<script>
import Menu from "./components/Menu";

export default {
  name: "App",
  components: { Menu },
  data() {
    return {
      drawer: null
    };
  }
};
</script>
