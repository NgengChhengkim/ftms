$(document).ready(function () {
    var oTable = $('#course').dataTable({
        'bPaginate': false
    });

    // Populate values
    var $rows = oTable.fnGetNodes();
    var values = {};
    var colnums = [2, 4];

//     for (var col = 0, n = colnums.length; col < n; col++) {

//         var colnum = colnums[col];
//         if (typeof values[colnum] === "undefined") values[colnum] = {};

//         // Create Unique List of Values
//         $('td:nth-child(' + colnum + ')', $rows).each(function () {
//             values[colnum][$(this).text()] = 1;
//         });-

//         // Create Checkboxes
//         var labels = [];
//         $.each(values[colnum], function (key, count) {
//             var $checkbox = $('<input />', {
//                 'class': 'filter-column filter-column-' + colnum,
//                     'type': 'checkbox',
//                     'value': key
// });
//             var $label = $('<label></label>', {
//                 'class': 'filter-container'
//             }).append($checkbox).append(' ' + key);
//             $checkbox.on('click', function () {
//                 oTable.fnDraw();
//             }).data('colnum', colnum);
//             labels.push($label.get(0));
//         });
//         var $sorted_containers = $(labels).sort(function (a, b) {
//             return $(a).text().toLowerCase() > $(b).text().toLowerCase();
//         });
//         $('#demo').prepend($sorted_containers);
//         $sorted_containers.wrapAll($('<div></div>', {
//             'class': 'checkbox-group checkbox-group-column-' + colnum
//         }));
//     }

//     $.fn.dataTableExt.afnFiltering.push(function (oSettings, aData, iDataIndex) {
//         var checked = [];
//         $('.filter-column').each(function () {
//             var $this = $(this);
//             if ($this.is(':checked')) checked.push($this);
//         });
//  if (checked.length) {
//             var returnValue = false;
//             $.each(checked, function (i, $obj) {
//                 if (aData[$obj.data('colnum') - 1] == $obj.val()) {
//                     returnValue = true;
//                     return false; // exit loop early
//                 }
//             });

//             return returnValue;
//         }

//         if (!checked.length) return true;
//         return false;
//     });
});
