import Vue from "vue";
import Errokees from 'errokees';
import Buefy from 'buefy';
import smoothscroll from 'smoothscroll-polyfill';
import '@procot/webostv';
import '@/assets/theme.scss'
import '@mdi/font/css/materialdesignicons.css';
import App from "./App.vue";
import router from "./router";

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
  render: function(h) {
    return h(App);
  },
}).$mount("#app");
