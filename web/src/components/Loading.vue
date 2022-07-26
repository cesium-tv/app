<template>
  <div
    :class="{ overlay: true, hidden: !visible }"
  >
    <img
      :src="spinner"
      class="spinner"
    />
  </div>
</template>

<script>
import axios from 'axios';
import spinner from '@/assets/loading.gif';

export default {
  name: 'Loading',

  data() {
    return {
      spinner,
      count: 0,
    };
  },

  computed: {
    visible() {
      return this.count > 0;
    },
  },

  methods: {
    inc() {
      this.count++;
    },

    dec() {
      if (--this.count < 0) {
        this.count = 0
      }
    }
  },

  mounted() {
    this.$bus.$on('busy', () => this.inc());
    this.$bus.$on('idle', () => this.dec());
    axios.interceptors.request.use((config) => {
        this.inc();
        return config;
      }, (error) => {
        this.dec();
        return Promise.reject(error);
      });

    // Add a response interceptor
    axios.interceptors.response.use((response) => {
        this.dec();
        return response;
      }, (error) => {
        this.dec();
        return Promise.reject(error);
      });
  },

  unmounted() {

  },
}
</script>

<style scoped>
.hidden {
  display: none;
}

.overlay {
  height: 100%;
  width: 100%;
  position: absolute;
  z-index: 1000;
  left: 0;
  top: 0;
  background-color: rgb(0,0,0);
  background-color: rgba(0,0,0, 0.9);
  overflow: hidden;
}

.spinner {
  width: 96px;
  height: 96px;
  position: absolute;
  top: 50%;
  left: 50%;
  margin-top: -48px; /* Half the height */
  margin-left: -48px; /* Half the width */
}
</style>
