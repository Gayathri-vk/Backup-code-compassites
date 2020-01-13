
 if($('.rightDiv').css('display') == 'none'){
    $('.centerDiv').removeClass('col-md-6').addClass('col-md-9');  
   }
$('#left').on('click',function(){
    $('.leftDiv').toggle();
   if($('.rightDiv').css('display') == 'none'){
    $('.centerDiv').removeClass('col-md-9').addClass('col-md-6');  
   }
    
});
$('#right').on('click',function(){
    $('.rightDiv').toggle();
    if($('.rightDiv').css('display') == 'none' && $('.leftDiv').css('display') == 'none'){
        $('.centerDiv').removeClass('col-md-6').addClass('col-md-9');  
       }
    else{
        $('.centerDiv').removeClass('col-md-9').addClass('col-md-6');  
       }
        
      
    // if($('.leftDiv').css('display') == 'none'){
    //     $('.centerDiv').removeClass('col-md-9').addClass('col-md-12');  
    // }
    // else if($('.leftDiv').css('display') == 'block'){
    //     $('.centerDiv').removeClass('col-md-6').addClass('col-md-9');
    // }
});

// if($('.leftDiv').css('display') == 'none' && $('.rightDiv').css('display') == 'none'){
//     $('.centerDiv').removeClass('col-md-6').addClass('col-md-12');
// }