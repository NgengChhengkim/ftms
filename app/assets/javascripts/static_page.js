$(document).ready(function () {
  var tbl_course = $('#tbl-course').dataTable({
    sPaginationType: "full_numbers",
    bJQueryUI: true,
    "paging":   true,
    "bPaginate": true,
    "bLengthChange": false,
  });

  $("#tbl-course_filter").hide();
  $("#tbl-course th").unbind("click");

  $(".filter-list").on("click", function(e){
    e.stopPropagation();
  });

  // filter(tbl_course, 1, "name");
  // filter(tbl_course, 2, "email");
  // filter(tbl_course, 3, "role");
  // tbl_course.fnSortListener($('#name-a-z'), 0 );
  $(".dropdown-menu .sort").on("click", function(){
    var parent = $(this).parent();
    var col_number = parent.data("column");
    var type = $(this).data("type");
    tbl_course.DataTable().order([col_name, type]).draw();
  });

  $('input#search').quicksearch(".filter-container", {
    'delay': 100,
    'bind': 'keyup'
  });

  $(".clear-checkbox").on("click", function(){
    var options = $(this).parent().find(".checkbox-group input");
    options.attr("checked", false);
    tbl_course.fnDraw();
    $("#search").val("").trigger("keyup");
  }).data('col_number', 1);

  $(".btn-close").on("click", function(){
    $(this).parents(".dropdown-menu").dropdown("toggle");
  });

  $('.dropdown-filter').on('hide.bs.dropdown', function () {
    var check = $(this).find(".filter-list input:checkbox:checked").length;
    if(check > 0) {
      $(this).find(".ic").removeClass("ic-filter").addClass("ic-filtered");
    } else {
      $(this).find(".ic").removeClass("ic-filtered").addClass("ic-filter")
    }
  });


  $.fn.dataTableExt.afnFiltering.push(function(oSettings, aData, iDataIndex) {
    var result1 = $.inArray(aData[0], arr1);
    if(arr2.length >0){
      var result2 = $.inArray(aData[2], arr2);
    }else {
      var result2 = $.inArray(aData[2], aData[2])
    }

    if (result1 >= 0 && result2 >= 0) {
        return true;
    }
    return false;
  });

  var arr1 = [];
  var arr2 = [];
  $(".ck").on("click", function() {
    arr1.push($(this).val());
    console.log(arr1);
  });

  $(".cb").on("click", function() {
    arr2.push($(this).val());
  });
  $(".sk").on("click", function() {
    tbl_course.fnDraw();
  });

});


function filter(table, col_number, col_name) {
  var $rows = table.fnGetNodes();
  var values = {};

  if (typeof values[col_number] === "undefined") values[col_number] = {};

  $('td:nth-child(' + col_number + ')', $rows).each(function () {
      values[col_number][$(this).text()] = 1;
  });

  var labels = [];
  $.each(values[col_number], function (key, count) {
    var $checkbox = $('<input />', {
        'class': 'filter-column filter-column-' + col_number,
            'type': 'checkbox',
            'value': key,
            'id': key
  });
  var $label_for = $('<label />', {
    'for': key,
    'text': key
  });
  var $label = $('<div></div>', {
      'class': 'filter-container'
  }).append($checkbox)
  .append($label_for);


  $checkbox.on('click', function () {
        table.fnDraw();
    }).data('col_number', col_number);
    labels.push($label.get(0));
  });

  var $sorted_containers = $(labels).sort(function (a, b) {
      return $(a).text().toLowerCase() > $(b).text().toLowerCase();
  });

  $("#checkbox-" + col_name).prepend($sorted_containers);

  $sorted_containers.wrapAll($('<div></div>', {
    'class': 'checkbox-group checkbox-group-column-' + col_number
  }));

  $.fn.dataTableExt.afnFiltering.push(function (oSettings, aData, iDataIndex) {
    var checked = [];
    $('.filter-column').each(function () {
      var $this = $(this);
      if ($this.is(':checked')) checked.push($this);
    });
    if (checked.length) {
      var returnValue = false;
      $.each(checked, function (i, $obj) {
        if (aData[$obj.data('col_number') -1] == $obj.val()) {
          returnValue = true;
          return false; // exit loop early
        }
      });
      return returnValue;
    }

    if (!checked.length) return true;
      return false;
  });
}
