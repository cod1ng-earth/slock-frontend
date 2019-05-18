import Vue from "vue";
import "./plugins/vuetify";
import App from "./App.vue";
import router from "./router";
import store from "./store";
import "./registerServiceWorker";

import axios from "axios";
import VueAxios from "vue-axios";

import ApolloClient from "apollo-boost";
import VueApollo from "vue-apollo";

const apolloClient = new ApolloClient({
  // You should use an absolute URL here
  uri: `${process.env.VUE_APP_API_ENDPOINT}/graphql` //hope that this convention stands :D
});
const apolloProvider = new VueApollo({
  defaultClient: apolloClient
});

Vue.use(VueAxios, axios);
Vue.use(VueApollo);

Vue.config.productionTip = false;

new Vue({
  router,
  store,
  apolloProvider,
  render: h => h(App)
}).$mount("#app");
