import Vue from "vue";
import Errokees from 'errokees';
import Buefy from 'buefy';
import smoothscroll from 'smoothscroll-polyfill';
import 'arrive';
import '@procot/webostv';
import '@/assets/theme.scss'
import '@mdi/font/css/materialdesignicons.css';
import App from "./App.vue";
import router from "./router";
import store from './store'

smoothscroll.polyfill();

// function handleError() {
//   const message = arguments.map(o => o.toString()).join('\r\n');

//   document.getElementsByTagName('body').innerHTML = 
//   '<div style="width: 100%; height: 100%; background-color: black;">'
//   '<pre style="color: white;">' + message + '</pre>'
//   '</div>';
// }

// window.onerror = function(msg, url, line, col, error) {
//   console.error(msg, url, line, col, error);
//   handleError(msg, line, col, error);
// }

// window.addEventListener('unhandledrejection', function(event) {
//   console.error(event);
//   handleError(event.promise, event.reason);
// });

Vue.config.productionTip = false;
Vue.prototype.$bus = new Vue();
Vue.prototype.$errokees = new Errokees(null, {
  origin: 'right',
  scroll: false,
  selectEvent: {
    name: 'errokees:selected',
  },
  deselectEvent: {
    name: 'errokees:deselected',
  },
});

Vue.use(Buefy);

new Vue({
  router,
  store,

  render(h) {
    return h(App);
  },

  beforeCreate() {
    let token = localStorage.getItem('cesium.tv-token');
    if (token) {
      token = JSON.parse(token);
    }
    this.$store.dispatch('whoami', token).catch(console.error);
  },
}).$mount("#app");
