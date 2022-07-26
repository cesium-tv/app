<template>
  <div
    id="overlay"
    v-if="visible"
  >
    <slot></slot>
    <div
      id="controls"
      class="closed"
    >
      <b-slider
        rounded
        size="is-large"
        type="is-info"
        :value="progress"
      >
      </b-slider>
      <p class="time time-curr">
        {{ state.time | hms }}
        <span class="time time-duration">{{ state.duration | hms }}</span>
      </p>      
    </div>
  </div>
</template>

<script>
export default {
  name: 'Controls',

  data() {
    return {
      timeout: null,
      visible: false,
    }
  },

  props: {
    value: {
      type: Boolean,
      default: false,
    },

    hideDelay: {
      type: Number,
      default: 3000,
    },

    state: {
      type: Object,
      default: {
        time: null,
        duration: null,
        playing: false,
      }
    },
  },

  computed: {
    progress() {
      return (100 / this.state.duration) * this.state.time;
    }
  },

  filters: {
    hms(value) {
      const hours = Math.floor(value / 3600).toString().padStart(2, '0');
      const minutes = Math.floor(value % 3600 / 60).toString().padStart(2, '0');
      const seconds = Math.floor(value % 3600 % 60).toString().padStart(2, '0');
      return `${hours}:${minutes}:${seconds}`;
    },
  },

  watch: {
    value() {
      this.visible = true;
      clearTimeout(this.timeout);

      this.timeout = setTimeout(() => {
        if (this.state.status === 2) {
          // paused.
          return;
        }
        this.visible = false;
        this.$emit('input', false);
      }, this.hideDelay);
    },
  },
}
</script>

<style scoped>
.time {
  font-weight: bold;
  font-size: 22px;
  color: white;
}

.time-curr {
  text-align: left;
}

.time-duration {
  float: right;
}

#overlay {
  position: absolute;
  top: 0;
  left: 0;
  bottom: 0;
  right: 0;
  background-color: rgba(0,0,0,0.5);
}

#controls {
	position: absolute;
	bottom: 0;
	left: 0;
	right: 0;
  height: 15%;
	padding: 5px;
  padding-left: 48px;
  padding-right: 48px;
}
</style>
