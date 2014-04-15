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
    return $('.current-file').click(function() {
      $(this).next('input[type="radio"]').prop('checked', true);
      $('.current-file').removeClass('default');
      return $(this).addClass('default');
    });
  });

  $(document).ajaxComplete(function() {
    return attachment_ui();
  });

  attachment_ui = function() {
    $('.new-file').on('click', function() {
      return $(this).next('input[type="file"]').trigger('click');
    });
    return $('.file-upload').change(function() {
      var clean, parent, value;
      value = $(this).val();
      clean = value.replace(/^.*[\\\/]/, '');
      parent = $(this).prev('.new-file');
      parent.children('div').text(clean);
      if (clean) {
        parent.css('background-color', '#8DC73F');
        return parent.children('.icon-upload-3').css('top', '20px');
      } else {
        parent.css('background-color', '#00aff1');
        return parent.children('.icon-upload-3').css('top', '41px');
      }
    });
  };

}).call(this);

//# sourceMappingURL=application.js.map
