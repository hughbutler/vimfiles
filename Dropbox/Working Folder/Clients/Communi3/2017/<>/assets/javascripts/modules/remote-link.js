  export default class RemoteLink {
      constructor(el) {
          el.onclick = function(e) {
              e.preventDefault();
              return false;
          }
      }
  }
