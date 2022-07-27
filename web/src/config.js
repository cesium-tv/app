const API_URL = 'http://192.168.1.101:8000/api/v1/';

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
  SEEKING: 4,
  RESUME: 5,
};

export {
  API_URL,
  KEYCODE,
  STATUS,
};
