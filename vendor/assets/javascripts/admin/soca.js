(function() {
  var attachment_ui;

  $(document).ready(function() {
    $('[data-toggle="tooltip"]').tooltip();
    $(".user-menu ul li:first-child a").hover((function() {
      return $(".user-menu .fa-caret-up").css('color', '#2f363d');
    }), function() {
      return $(".user-menu .fa-caret-up").css('color', '#ffffff');
    });
    attachment_ui();
    $('.current-file:not(.icon-close)').click(function() {
      $(this).next('input[type="radio"]').prop('checked', true);
      $('.current-file').removeClass('default');
      return $(this).addClass('default');
    });
    return $('#menu-trigger-input').change(function() {
      if (this.checked) {
        return $('body').css('overflow', 'hidden');
      } else {
        return $('body').css('overflow', 'auto');
      }
    });
  });

  attachment_ui = function() {
    $('body').on('click', '.new-file', function() {
      return $(this).next('input[type="file"]').trigger('click');
    });
    return $('body').on('change', '.file-upload', function() {
      var clean, parent, value;
      value = $(this).val();
      clean = value.replace(/^.*[\\\/]/, '');
      parent = $(this).prev('.new-file');
      parent.children('div').text(clean);
      if (clean) {
        return parent.css('background-color', '#8DC73F').children('.icon-upload-3').css('top', '20px');
      } else {
        return parent.css('background-color', '#00aff1').children('.icon-upload-3').css('top', '41px');
      }
    });
  };

}).call(this);
