<template>
  <div id="grid">
    <GridRow
      v-for="(channel, i) in channels"
      :key="i"
      :channel="channel"
    />
  </div>  
</template>

<script>
import axios from 'axios';
import GridRow from '@/components/GridRow';
import config from '@/config';
import utils from '@/utils';

export default {
  name: 'Grid',

  components: {
    GridRow,
  },

  data () {
    return {
      channels: null,
    }
  },

  mounted() {
    axios.get(utils.urlJoin(config.API_URL, '/channels/'))
      .then(r => this.channels = r.data.results)
      .catch(console.error);
  },
}
</script>

<style lang="scss">
#grid {
  padding-left: 60px;
  position: absolute;
  top: 0;
  bottom: 0;
  right: 0;
  left: 0;
  overflow: hidden;
}

.sidebar-page {
    display: flex;
    flex-direction: column;
    width: 100%;
    min-height: 100%;
    // min-height: 100vh;
    .sidebar-layout {
        display: flex;
        flex-direction: row;
        min-height: 100%;
        // min-height: 100vh;
    }
}
</style>
