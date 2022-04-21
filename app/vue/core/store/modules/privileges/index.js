import Vuex from 'vuex'

import mutations from './mutations.js';
import actions from './actions.js';
import getters from './getters.js';

const store = new Vuex.Store({
  state() {
    return {
      privileges: []
    };
  },
  mutations,
  actions,
  getters
});

export default store;