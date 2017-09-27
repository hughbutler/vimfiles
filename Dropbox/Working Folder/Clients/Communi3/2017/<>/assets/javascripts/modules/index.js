/*
  Automatically instantiates modules based on data-attrubiutes
  specifying module file-names.
*/

window.init = function() {
    let moduleElements = document.querySelectorAll('[data-module]')

    for (var i = 0; i < moduleElements.length; i++) {
        const el = moduleElements[i]
        const name = el.getAttribute('data-module')
        const Module = require(`./${name}`).default
        new Module(el)
    }
};

window.init();

/*
  Usage:
  ======

  html
  ----
  <button data-module="disappear">disappear!</button>

  js
  --
  // modules/disappear.js
  export default class Disappear {
    constructor(el) {
      el.style.display = none
    }
  }
*/
