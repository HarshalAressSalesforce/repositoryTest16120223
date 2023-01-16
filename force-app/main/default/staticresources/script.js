alert("1");
jQuery( document ).ready(function() {
	jQuery(".dataContainer").hide();
	alert("2");
   jQuery(".click").click(function(){
	  jQuery(".dataContainer").hide();
	  jQuery(this).parent().next().show();
   }); 
});