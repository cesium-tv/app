<template>
  <div
    id="container"
    ref="container"
    :class="{ hide: !visible, show: visible }"
  >
    <video
      autoplay
      ref="video"
      :controls="false"
      :src="source"
    ></video>

    <div
      :class="{ hide: !controls, show: controls }"
      id="overlay"
    >
      <div
        id="playpause"
      >
        <b-icon
          :icon="(status.playing) ? 'pause' : 'play'"
          size="is-large"
          type="is-light"
        >
        </b-icon>
      </div>
      <div
        id="controls"
      >
        <b-slider
          rounded
          size="is-large"
          type="is-info"
          :value="progress"
        >
        </b-slider>
        <p style="text-align: left; font-weight: bold; color: white;">
          {{ status.time | hms }}
          <span style="float: right; font-weight: bold; color: white;">{{ status.duration | hms }}</span>
        </p>      
      </div>
    </div>
  </div>
</template>

<script>
// NOTE: keyCodes
const BACK = 461;
const ESC = 27;
const PLAY = 179;
const PLAY_TV = 415;  // NOTE: different on TV vs. emu.
const PAUSE = 19;
const FFD = 228;
const RWD = 227;
const STOP = 169;
const CHANUP = 33;
const CHANDN = 34;
const RIGHT = 39;
const LEFT = 37;
const SPACE = 32;

export default {
  name: 'Player',

  filters: {
    hms(value) {
      const hours = Math.floor(value / 3600).toString().padStart(2, '0');
      const minutes = Math.floor(value % 3600 / 60).toString().padStart(2, '0');
      const seconds = Math.floor(value % 3600 % 60).toString().padStart(2, '0');
      return `${hours}:${minutes}:${seconds}`;
    },
  },

  timeout: null,

  data() {
    return {
      video: null,
      visible: false,
      controls: false,
      dimension: '1280x720',
      status: {
        time: null,
        duration: null,
        playing: false,
      },
    };
  },

  mounted() {
    const $video = this.$refs.video;

    document.addEventListener('keydown', this.onKeyDown.bind(this));
    document.addEventListener('fullscreenchange', this.onFullscreen.bind(this), false);
    document.addEventListener('mozfullscreenchange', this.onFullscreen.bind(this), false);
    document.addEventListener('MSFullscreenChange', this.onFullscreen.bind(this), false);
    document.addEventListener('webkitfullscreenchange', this.onFullscreen.bind(this), false);

    $video.addEventListener("timeupdate", () => {
      this.status.duration = $video.duration;
      this.status.time = $video.currentTime;
    });
    $video.addEventListener('play', () => {
      this.$bus.$emit('idle');
      this.$emit('video:play');
    });
    $video.addEventListener('stalled', () => {
      this.$emit('busy');
    });
    $video.addEventListener('playing', () => {
      this.$emit('idle');
      this.status.playing = true;
    });
    $video.addEventListener('pause', () => {
      this.status.playing = false;
    });
    this.$bus.$on('video:play', this.play);
  },

  unmounted() {
    document.removeEventListener('keydown', this.onKeyDown.bind(this));
  },

  watch: {
    source(newValue, oldValue) {
      if (newValue && newValue !== oldValue) {
        const $video = this.$refs.video;
        $video.currentTime = 0;
        this.$bus.$emit('busy');
      }
    },
  },

  computed: {
    source() {
      return this.video && this.video.sources[this.dimension];
    },

    progress() {
      return (100 / this.status.duration) * this.status.time;
    }
  },

  methods: {
    show() {
      this.visible = true;
      const $container = this.$refs.container;
      if ($container.requestFullscreen) {
          $container.requestFullscreen();
      } else if ($container.mozRequestFullScreen) {
          $container.mozRequestFullScreen();
      } else if ($container.webkitRequestFullScreen) {
          $container.webkitRequestFullScreen();
      } else if ($container.msRequestFullscreen) {
          $container.msRequestFullscreen();
      }
    },

    showControls() {
      this.controls = true;
      clearTimeout(this.timeout);
      this.timeout = setTimeout(() => {
        if (!this.status.playing) {
          return;
        }
        this.controls = false;
      }, 5000);
    },

    hide() {
      try {
        if (document.exitFullscreen) {
            document.exitFullscreen();
        } else if (document.mozCancelFullScreen) {
            document.mozCancelFullScreen();
        } else if (document.webkitCancelFullScreen) {
            document.webkitCancelFullScreen();
        } else if (document.msExitFullscreen) {
            document.msExitFullscreen();
        }
      } catch (e) {
        console.error(e);
      }
      this.visible = false;
    },

    play(video) {
      console.log('playing', video);

      this.video = video;
      this.show();
      this.showControls();
    },

    pause() {
      const $video = this.$refs.video;

      console.log('pausing');

      $video.pause();
      this.hide();
      this.showControls();
    },

    stop() {
      console.log('stopping');

      this.pause();
      this.$emit('video:stop');
    },

    onFullscreen() {
      if (!document.webkitIsFullScreen &&
          !document.mozFullScreen &&
          !document.msFullscreenElement)
      {
        this.stop();
      }
    },

    onKeyDown(ev) {
      const $video = this.$refs.video;

      switch (ev.keyCode) {
        case PAUSE:
        case PLAY:
        case PLAY_TV:
        case SPACE:
          if ($video.paused) {
            $video.play();
          } else {
            $video.pause();
          }
          this.showControls();
          break;

        case RIGHT:
        case FFD:
          $video.currentTime += 10;
          this.showControls();
          break;

        case LEFT:
        case RWD:
          $video.currentTime -= 10;
          this.showControls();
          break;

        case STOP:
        case BACK:
        case ESC:
          this.stop();
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

#overlay {
  position: absolute;
  top: 0;
  left: 0;
  bottom: 0;
  right: 0;
  background-color: rgba(0,0,0,0.5);
}

#playpause {
	position: absolute;
  top: 50%;
	left: 50%;
  margin-top: -24;
  margin-left: -24;
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
