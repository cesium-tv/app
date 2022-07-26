<template>
  <div class="sidebar-page">
    <section class="sidebar-layout">
      <Sidebar/>
      <router-view/>
    </section>
    <Player
      @video:play="onVideoPlay"
      @video:stop="onVideoStop"
    />
    <Loading/>
  </div>
</template>

<script>
import Sidebar from '@/components/Sidebar';
import Grid from '@/components/Grid';
import Player from '@/components/Player';
import Loading from '@/components/Loading';

export default {
  name: 'App',

  components: {
    Sidebar,
    Grid,
    Player,
    Loading,
  },

  unmounted() {
    this.$errokees.disable();
    this.$errokees = null;
  },

  methods: {
    onVideoStop() {
      this.$errokees.resume();
    },

    onVideoPlay(video) {
      this.$errokees.pause();
    },
  },
}
</script>

<style>
body {
  background-color: black;
}
</style>
