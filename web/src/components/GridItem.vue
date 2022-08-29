<template>
  <div
    ref="video"
    class="card has-background-dark errokees-selectable video"
    data-ek-activate-event-name="errokees:activate"
    @errokees:activate="$bus.$emit('video:play', video)"
    @errokees:selected="scrollTop()"
  >
    <div class="card-image">
      <figure>
        <img
          class="poster"
          :src="video.poster"
        />
      </figure>
    </div>
    <div class="card-content">
      <div class="content">
        <p
          class="title is-4 has-text-light"
        >{{ video.title }}</p>
        <p
          class="duration"
        >{{ duration }}</p>
        <p
          class="published"
        >{{ published }}</p>
      </div>
    </div>
  </div>
</template>

<script>
import moment from 'moment';

export default {
  name: "GridItem",
  
  props: {
    video: {
      type: Object,
      default: {
        name: null,
        previewPath: null,
      },
    },
  },

  computed: {
    duration() {
      return moment.duration(this.video.duration, 'seconds').humanize();
    },

    published() {
      return moment(this.video.published).fromNow();
    }
  },

  methods: {
    scrollTop() {
      /*
      NOTE: scrollIntoView() is broken on webOS. Also, it is not quite what we
      want since we want the row top vs. the video left.
      */
      const $vid = this.$refs.video;
      const row = $vid.parentNode.parentNode;
      const top = row.offsetTop, rowWidth = row.offsetWidth;
      const left = $vid.offsetLeft, vidWidth = $vid.offsetWidth;
      row.parentNode.scrollTo({
        behavior: 'smooth',
        top,
      });
      $vid.parentNode.scrollTo({
        behavior: 'smooth',
        left: (left + (vidWidth / 4)) - (rowWidth / 2),
      });
    },
  }
}
</script>

<style scoped>
.video {
  min-width: 480px;
  max-width: 480px;
  height: 400px;
  margin: 4px;
}

.title {
  max-height: 128px;
  text-overflow: ellipsis;
}

.duration {
  float: right;
}

.poster {
  width: 320px;
  min-width: 476;
}

.errokees-selectable {
  border: 2px solid transparent;
}

.errokees-selected {
  border: 2px solid hsl(204, 86%, 53%);;
}
</style>
