var currentOption = ''; 

function proceccOptions(option) {
	currentOption = option; 
 
	$('.add_more_label').addClass('hideMe'); 
	$('.'+option+'_add_more_label').removeClass('hideMe'); 
    $('.options').parent().addClass('hideMe');  	
}  


function initActions() {
	$(".typeQuestions input[type='radio']").click(function(){
		var option = $(this).val();
		if(option != currentOption) {
			$('.options').html('');
		}
		proceccOptions(option);		
		//currentOption = option; 
	});  
	
	$(".add_more_button").click(function(){ 
		$('.options').parent().removeClass('hideMe');
		 
		$('.options').append($('.'+currentOption+'_question_type').html());
		$(".delete_option").click(function(){                        
			$(this).parent().remove();
		}); 
		
		var currentIndex = 1;
		$('.options input[type="text"]').each(function( i ) {
			$(this).removeAttr('id');  
			$(this).attr('id','option'+currentIndex);
			currentIndex++;
		});
	}); 	        
}


$(document).ready(function(){ 
	initActions(); 
});  

function storeValue(element) {
	var options = new Array();
	var currentIndex = 0;
	$('.options input[type="text"]').each(function( i ) {
		options[currentIndex] = $(this).val();
		currentIndex++;
	});
	document.getElementById(element).value = options.join(',');                     
	return false;
}