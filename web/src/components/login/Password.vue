<template>
  <div>
    <section>
      <form
        @submit="onLogin"
      >
        <b-field
          label="Username"
          type="is-success"
          message="This username is available"
        >
          <b-input
            v-model="form.username"
            maxlength="30"
          ></b-input>
        </b-field>

        <b-field label="Password">
          <b-input
            v-model="form.password"
            type="password"
            password-reveal
          ></b-input>
        </b-field>

        <b-button type="is-primary">Login</b-button>
      </form>
    </section>
  </div>
</template>

<script>
import axios from 'axios';
import { API_URL, CLIENT_ID, CLIENT_SECRET } from '@/config';
import utils from '@/utils';

export default {
  name: 'Password',

  data() {
    return {
      form: {
        username: null,
        password: null,
      }
    };
  },

  methods: {
    async onLogin() {
      const data = {
        grant_type: 'password',
        client_id: CLIENT_ID,
        client_secret: CLIENT_SECRET,
        ...this.form,
      };
      let r = await axios.post(utils.urlJoin(API_URL, '/oauth2/token/'), data);
      this.$store.commit('SET_AUTH', r.json());
      this.$router.push('/');
    }
  },
}
</script>

<style scoped>

</style>
