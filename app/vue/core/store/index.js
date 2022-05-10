import Vuex from "vuex";

// import abilitiesModule from './modules/abilities/index.js';

const store = new Vuex.Store({
  modules: {
    // abilities: abilitiesModule
  },
  state() {
    return {
      isLoggedIn: false
    };
  }
});

export default store;