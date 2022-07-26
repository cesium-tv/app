<template>
  <div
    id="container"
    ref="container"
    :class="{ hide: !display.player, show: display.player }"
  >
    <video
      autoplay
      ref="video"
      :controls="false"
      :src="source"
    ></video>

    <div
      id="overlay"
      :class="{ hide: !display.controls, show: display.controls }"
    >
      <div
        id="playpause"
        :class="{ hide: !display.playPause, show: display.playPause }"
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
        <p class="time time-curr">
          {{ status.time | hms }}
          <span class="time time-duration">{{ status.duration | hms }}</span>
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
const ENTER = 13;

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

  data() {
    return {
      video: null,
      display: {
        player: false,
        controls: false,
        playPause: false,
      },
      status: {
        time: null,
        duration: null,
        playing: false,
      },
      timeouts: {
        controls: null,
        playPause: null,
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
    video(newValue, oldValue) {
      if (newValue && newValue !== oldValue) {
        const $video = this.$refs.video;
        $video.currentTime = 0;
        this.$bus.$emit('busy');
      }
    },
  },

  computed: {
    dimension() {
      const dimensions = [];
      Object.entries(this.video.sources).forEach(entry =>{
        const [dimension, source] = entry;
        dimensions.push([source.height, dimension]);
      });
      dimensions.sort((a, b) => (b[0] - a[0]))
      return dimensions[0][1];
    },

    source() {
      return this.video && this.video.sources[this.dimension].url;
    },

    progress() {
      return (100 / this.status.duration) * this.status.time;
    }
  },

  methods: {
    show() {
      this.display.player = true;
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
      this.display.controls = true;
      clearTimeout(this.timeouts.controls);
      this.timeouts.controls = setTimeout(() => {
        if (!this.status.playing) {
          return;
        }
        this.display.controls = false;
      }, 3000);
    },

    showPlayPause() {
      this.display.playPause = true;
      clearTimeout(this.timeouts.playPause);
      this.timeouts.playPause = setTimeout(() => {
        this.display.playPause = false;
      }, 1000);
    },

    hide() {
      this.display.player = false;
      if (!document.webkitIsFullScreen &&
          !document.mozFullScreen &&
          !document.msFullscreenElement)
      {
        return;
      }
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
    },

    play(video) {
      console.log('playing', video);

      this.video = video;
      this.show();
      //this.showControls();
      //this.showPlayPause();
    },

    pause() {
      const $video = this.$refs.video;

      console.log('pausing');

      $video.pause();
      this.hide();
      //this.showControls();
      //this.showPlayPause();
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
        case ENTER:
          if ($video.paused) {
            $video.play();
          } else {
            $video.pause();
          }
          this.showControls();
          this.showPlayPause();
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
  top: 40%;
	left: 50%;
  margin-top: -24;
  margin-left: -24;
  font-size: 78px;
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
