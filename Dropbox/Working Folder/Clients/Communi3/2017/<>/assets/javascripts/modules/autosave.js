  export default class Autosave {
      constructor(el) {
          el.onchange = function(e) {
              let form = $(el).closest('form');
              if (form.attr('data-remote')) {
                  form.trigger('submit');
                  e.preventDefault();
                  return false;
                  // form.submit();
              }
          }
      }
  }
