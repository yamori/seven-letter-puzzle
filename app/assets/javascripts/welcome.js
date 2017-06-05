function populateSolveForm(firstChar, otherChars) {
  $("#puzzleSet_target").html("");
  $("#puzzle_set_center_letter").val(firstChar);
  $("#puzzle_set_other_letters").val(otherChars);
  $('html, body').animate({
    scrollTop: $("#puzzle_set_center_letter").offset().top
    }, 600);
}
