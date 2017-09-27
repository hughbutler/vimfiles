  export default class Tables {
      constructor(el) {
          const tableRows = el.querySelectorAll('tr[data-href]');
          for (var i = 0; i < tableRows.length; i++) {
              const tableRow = tableRows[i];
              const href = tableRow.getAttribute('data-href')
              tableRow.onclick = function() {
                  $.ajax({
                      url: href
                  })
                  // window.location.href = href;
              }
          }
          // el.onclick = function () {
          //   el.closest('form').submit();
          // }
      }
  }
