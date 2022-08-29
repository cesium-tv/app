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
import GridRow from '@/components/GridRow';

export default {
  name: 'Grid',

  components: {
    GridRow,
  },

  data () {
    return {
    }
  },

  computed: {
    channels() {
      const channels = this.$store.getters['channels'];

      if (!channels) {
        return;
      }

      return channels.filter(c => c.videos);
    }
  },

  mounted() {
    this.$store.dispatch('updateChannels')
      .catch(e => console.error);
    // Select the first video once our data is rendered.
    document.arrive('div.video', { onceOnly: true }, (el) => {
      this.$errokees.select(el);
    });
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
