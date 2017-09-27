window.announcement_form = {

    el: {
        links: $('#category_picklist a'),
        formfield: $('#announcement_category_id')
    },

    current_id: null,

    set_buttons: function (e) {
      var obj = window.announcement_form;

      var el = e.currentTarget;
      e.preventDefault();

      obj.current_id = $(el).data('id');
      obj.set_states (el);
    },

    set_states: function (el) {
      var obj = window.announcement_form;
      var id = obj.current_id;

      this.el.formfield.val (obj.current_id);

      if (el) {
        $(el).addClass ('selected');
        $('#category_picklist a').not ($(el)).removeClass ('selected');
      }

    },

    init: function () {

        this.current_id = this.el.formfield.val();
        this.set_states ();

        this.el.links.unbind ('click')
          .bind('click', this.set_buttons.bind(this));


    }
}
