<template>
  <div>
    <qrcode
      :value="verifyUrl"
      :options="{ width: 200 }"
    ></qrcode>
  </div>
</template>

<script>
import axios from 'axios';
import VueQrcode from '@chenfengyuan/vue-qrcode';
import { API_URL, CLIENT_ID, CLIENT_SECRET } from '@/config';
import utils from '@/utils';

export default {
  name: 'DeviceCode',
  
  components: {
    VueQrcode,
  },

  data() {
    return {
      authInfo: null,
      handle: null,
    };
  },

  mounted() {
    const data = {
      grant_type: 'urn:ietf:params:oauth:grant-type:device_code',
      client_id: CLIENT_ID,
    };
    axios
      .post(utils.urlJoin(API_URL, '/oauth2/token/'), data)
      .then(r => {
        this.authInfo = r.json();
        this.handle = setInterval(this.onPoll.bind(this), 6000);
      })
      .catch(console.error);
  },

  unmounted() {
    if (this.handle) {
      clearTimeout(this.handle);
    }
  },

  computed: {
    verifyUrl() {
      return `${this.authInfo.verify_uri}?${this.authInfo.user_code}`;
    },
  },

  methods: {
    onPoll() {
      const data = {
        grant_type: 'urn:ietf:params:oauth:grant-type:device_code',
        client_id: CLIENT_ID,
        client_secret: CLIENT_SECRET,
        device_code: this.authInfo.device_code,
      };
      axios
        .post(utils.urlJoin(API_URL, '/oauth2/token/'), data)
        .then(r => {
          // NOTE: check http status code.
          this.onLogin(r.json());
        })
        .catch(console.error);
    },

    onLogin(token) {
      this.$store.commit('SET_AUTH', token);
      this.$router.push('/');
    }
  },
}
</script>

<style scoped>

</style>
