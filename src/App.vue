<template>
  <v-app>
    <v-toolbar app>
      <v-toolbar-side-icon @click.stop="drawer = !drawer"></v-toolbar-side-icon>
      <v-toolbar-title class="headline text-uppercase">
        <v-layout align-start justify-center row fill-height>
          <v-flex>
            <v-img :src="img.imgTruck" width="30"/>
          </v-flex>
          <v-flex pl-2>Truckstop</v-flex>
        </v-layout>
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
import imgTruck from "./assets/foodtruck.png";

export default {
  name: "App",
  components: { Menu },
  data() {
    return {
      img: {
        imgTruck
      },
      drawer: null
    };
  }
};
</script>
