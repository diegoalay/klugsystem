import Vuex from "vuex";

// import privilegesModule from './modules/privileges/index.js';

const store = new Vuex.Store({
  modules: {
    // privileges: privilegesModule
  },
  state() {
    return {
      isLoggedIn: false
    };
  }
});

export default store;