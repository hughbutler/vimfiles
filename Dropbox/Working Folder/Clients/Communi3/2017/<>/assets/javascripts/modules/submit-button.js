  export default class SubmitButton {
      constructor(el) {
          el.onclick = function(e) {
              $(el).closest('form').trigger('submit');
              e.preventDefault();
              return false;
          }
      }
  }
