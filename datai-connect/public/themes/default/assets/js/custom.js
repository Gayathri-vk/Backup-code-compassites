$(".searchIconHeader").click(function(){
    //alert("The paragraph was clicked.");
    $("#searchPopup").show();
});
$(".searchClose").click(function(){
	$("#searchPopup").hide();
});
$("#bodyCloseSearch").click(function(){
	$("#searchPopup").hide();
});
// $(document).ready(function(){
//   console.log("scrolled");
//
// $(document).scroll(function() {
//
//   var span = $('.course-block'),
//     div = $('.main-content'),
//     spanHeight = span.outerHeight(),
//     divHeight = div.height(),
//     spanOffset = span.offset().top + spanHeight,
//     divOffset = div.offset().top + divHeight;
//     console.log(spanHeight);
//   if (spanOffset >= divOffset) {
//
//     console.log("scrolled");
//     span.addClass('bottom');
//     var windowScroll = $(window).scrollTop() + $(window).height() - 50;
//     if (spanOffset > windowScroll) {
//       span.removeClass('bottom');
//     }
//   }
// });
// });
