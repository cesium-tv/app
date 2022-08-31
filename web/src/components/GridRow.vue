<template>
  <div ref="row">
    <p
      class="title channel-name is-3 has-text-light"
    >{{ channel.name }}</p>
    <div class="row">
      <GridItem
        v-for="(video, i) in videos"
        :key="i"
        :video="video"
      />
      <div
        v-if="videos && videos.length > 5"
        class="card has-background-dark errokees-selectable return"
        data-ek-activate-event-name="errokees:activate"
        @errokees:activate="onReturn"
      >
        <div class="card-image">
          <figure class="image is-centered is-vcentered">
            <b-icon
              style="margin-top: 176px"
              icon="arrow-u-left-bottom"
              size="is-large"
              type="is-light"
            >
            </b-icon>
          </figure>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import GridItem from '@/components/GridItem';

export default {
  name: 'GridRow',

  components: {
    GridItem,
  },

  props: {
    channel: {
      type: Object,
      default: null
    }
  },

  data() {
    return {
      videos: null,
    };
  },

  mounted() {
    this.$store.dispatch('updateVideos', { channel_uid: this.channel.uid })
      .then(() => {
        this.videos = this.$store.getters.videos[this.channel.uid];
      })
      .catch(e => console.error);
  },

  methods: {
    onReturn() {
      const div = this.$refs.row.children[1].firstChild;
      this.$errokees.select(div);
    },
  }
}
</script>

<style scoped>
.channel-name {
  padding-top: 10px;
  margin-bottom: 10px
}

.return {
  min-width: 72px;
  max-width: 72px;
  height: 400px;
  margin: 4px;
}

.row {
  display: flex;
  overflow-x: hidden;
  overflow-y: hidden;
  height: 404;
}

.errokees-selectable {
  border: 2px solid transparent;
}

.errokees-selected {
  border: 2px solid var(--act-color);
}
</style>
