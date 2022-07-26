<template>
  <div
    id="container"
    ref="container"
  >
    <video
      autoplay
      ref="video"
      :controls="false"
      :src="source"
    ></video>

      <Controls
        v-model="controls"
        :state="state"
      >
        <PlayPause
          v-model="playPause"
          :state="state"
        />
      </Controls>
    </div>
</template>

<script>
import screenfull from 'screenfull';
import PlayPause from '@/components/player/PlayPause';
import Controls from '@/components/player/Controls';

const KEYCODE = {
  BACK: 461,
  ESC: 27,
  PLAY: 179,
  PLAY_TV: 415,  // NOTE: different on TV vs. emu.
  PAUSE: 19,
  FFD: 228,
  RWD: 227,
  STOP: 169,
  CHANUP: 33,
  CHANDN: 34,
  RIGHT: 39,
  LEFT: 37,
  SPACE: 32,
  ENTER: 13,
};
const STATUS = {
  LOADING: 0,
  PLAYING: 1,
  PAUSED: 2,
  STOPPED: 3,
};

export default {
  name: 'Video',

  components: {
    PlayPause,
    Controls,
  },

  props: {
    value: {
      type: Object,
      default: null,
    },
  },

  data() {
    return {
      controls: false,
      playPause: false,
      state: {
        status: STATUS.LOADING,
        time: null,
        duration: null,
      },
      eventHandlers: {},
    };
  },

  mounted() {
    const $video = this.$refs.video;

    this.eventHandlers.keyDown = this.onKeyDown.bind(this);
    document.addEventListener('keydown', this.eventHandlers.keyDown);
    this.eventHandlers.fullScreen = this.onFullscreen.bind(this);
    screenfull.on('change', this.eventHandlers.fullScreen);

    $video.addEventListener("timeupdate", (ev) => {
      this.state.duration = ev.target.duration;
      this.state.time = ev.target.currentTime;
    });
    $video.addEventListener('play', () => {
      this.$bus.$emit('idle');
    });
    $video.addEventListener('stalled', () => {
      this.$bus.$emit('busy');
    });
    $video.addEventListener('playing', () => {
      const status = this.state.status;
      this.$bus.$emit('idle');
      this.state.status = STATUS.PLAYING;
      // NOTE: don't show controls when first playing, or skipping.
      if (status === STATUS.PAUSED) {
        this.controls = false;
        this.playPause = true;
      }
    });
    $video.addEventListener('pause', () => {
      this.state.status = STATUS.PAUSED;
      this.controls = true;
      this.playPause = true;
    });

    this.show();
  },

  unmounted() {
    document.removeEventListener('keydown', this.eventHandlers.keyDown);
    screenfull.off('change', this.eventHandlers.fullScreen);
  },

  computed: {
    dimension() {
      if (!this.value) {
        return;
      }

      const dimensions = [];
      Object.entries(this.value.sources).forEach(entry =>{
        const [dimension, source] = entry;
        dimensions.push([source.height, dimension]);
      });
      dimensions.sort((a, b) => (b[0] - a[0]))
      return dimensions[0][1];
    },

    source() {
      if (!this.value) {
        return;
      }

      return this.value.sources[this.dimension].url;
    },
  },

  methods: {
    show() {
      this.$emit('play');
      screenfull.request(this.$refs.container);
    },

    hide() {
      this.$emit('stop');
      this.$emit('input', null);

      if (screenfull.isFullscreen) {
        screenfull.exit();
      }
    },

    onFullscreen() {
      if (!screenfull.isFullscreen) {
        this.hide();
      }
    },

    onKeyDown(ev) {
      console.log('keyCode:', ev.keyCode);

      const $video = this.$refs.video;
      if (!$video) {
        return;
      }

      switch (ev.keyCode) {
        case KEYCODE.PAUSE:
        case KEYCODE.SPACE:
        case KEYCODE.ENTER:
          if ($video.paused) {
            $video.play();
          } else {
            $video.pause();
          }
          break;

        case KEYCODE.PLAY:
        case KEYCODE.PLAY_TV:
          if ($video.paused) {
            $video.play();
          }
          this.controls = true;
          break;

        case KEYCODE.RIGHT:
        case KEYCODE.FFD:
          $video.currentTime += 10;
          this.controls = true;
          break;

        case KEYCODE.LEFT:
        case KEYCODE.RWD:
          $video.currentTime -= 10;
          this.controls = true;
          break;

        case KEYCODE.STOP:
        case KEYCODE.BACK:
        case KEYCODE.ESC:
          this.hide();
          break;

        default:
          console.log('Unknown keyCode:', ev.keyCode);
          break;
      }
    },
  },
}
</script>

<style scoped>
#container {
  width: 100%;
  height: 100%;
  background-color: black;
  z-index: 1000;
}

video {
  width: 100%;
  height: 100%;
  object-fit: contain;
  background-color: black;
}

.hide {
  display: none;
}

.show {
  display: block;
}
</style>
