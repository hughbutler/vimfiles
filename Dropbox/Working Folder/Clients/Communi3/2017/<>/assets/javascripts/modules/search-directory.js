  export default class RemoteLink {
      constructor(el) {
          const self = this;
          const form = el;
          const textField = el.querySelector('#person_name');
          let lastTouchedTS;
          textField.onkeyup = function(e) {
              lastTouchedTS = Math.floor(Date.now() / 1000);
              setTimeout(function() {
                  const nowTS = Math.floor(Date.now() / 1000);
                  if (nowTS - lastTouchedTS >= 1) {
                      self.xhr({
                          url: el.getAttribute('action') + '?q=' + textField.value + '&gender=' + textField.getAttribute('data-gender'),
                          success: (response) => {
                              const json = JSON.parse(response);
                              let ul = document.createElement('ul');
                              ul.id = 'peopleResults';
                              for (var i = 0; i < json.length; i++) {
                                  let li = document.createElement('li');
                                  li.setAttribute('data-person-id', json[i]['id']);
                                  li.innerText = json[i]['last_name'] + ', ' + json[i]['first_name'];
                                  ul.appendChild(li);

                                  li.onclick = function(e) {
                                      const personId = this.getAttribute('data-person-id');
                                      const weekendId = form.getAttribute('data-weekend-id');
                                      const url = location.protocol + '//' + location.host + "/weekends/" + weekendId + "/attendees/new.js?person_id=" + personId

                                      self.xhr({
                                          url: url,
                                          success: (response) => {
                                              // Not a fan of this approach. TODO later?
                                              eval(response);
                                          },
                                          error: (response) => {
                                              console.log('Error', response);
                                          }
                                      })
                                      // alert(this.getAttribute('data-person-id'));
                                  };
                              }
                              if (el.querySelector('ul#peopleResults')) {
                                  el.remove(el.querySelector('ul#peopleResults'));
                              }
                              el.appendChild(ul);

                          },
                          error: (response) => {
                              console.log('Error', response);
                          }
                      });
                  }
                  lastTouchedTS = nowTS;
              }, 1000);

          }
      }

      xhr(args) {
          const url = args['url'];
          const success = args['success'];
          const error = args['error'];

          let xhr = new XMLHttpRequest();
          xhr.open('GET', url);
          xhr.send();
          xhr.onreadystatechange = function() {
              const DONE = 4;
              const OK = 200;
              if (xhr.readyState === DONE) {
                  if (xhr.status === OK) {
                      success(xhr.responseText);
                  } else {
                      error(xhr.status);
                  }
              }
          };
      }
  }
