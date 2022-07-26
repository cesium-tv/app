<template>
  <div class="sidebar-page">
    <section class="sidebar-layout">
      <Sidebar/>
      <router-view/>
    </section>
    <Video
      v-model="video"
      v-if="video"
      @play="$errokees.pause()"
      @stop="$errokees.resume()"
    />
    <Loading/>
  </div>
</template>

<script>
import Sidebar from '@/components/Sidebar';
import Grid from '@/components/Grid';
import Video from '@/components/player/Video';
import Loading from '@/components/Loading';

export default {
  name: 'App',

  components: {
    Sidebar,
    Grid,
    Video,
    Loading,
  },

  data() {
    return {
      video: null,
    };
  },

  mounted() {
    this.$bus.$on('video:play', video => {
      this.$bus.$emit('busy');
      this.video = video;
    });
  },

  unmounted() {
    this.$errokees.disable();
    this.$errokees = null;
  },
}
</script>

<style>
body {
  background-color: black;
}
</style>
