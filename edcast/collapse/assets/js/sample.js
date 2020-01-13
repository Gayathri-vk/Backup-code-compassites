
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



   $('#adbtn').on('click',function() {
      $(".sec_page").css('display','block');
      $(".first_page").css('display','none');
      var ipdata = [];
      var count =1;
      console.log(count,'countval');
      $('.inputs').each(function() {
        var res = $(this).val();
        console.log(res);
        ipdata.push(res);       
      });
    //   console.log(ipdata[0]);
      var content = ` <tr scope="row"> <td class ="counter">0</td> <td>${ipdata[0]}</td> 
        <td><label><input type="checkbox" class="chk_box">Select</label></td> </tr>`;
    $('#first_table').append(content);

    $('.counter').each(function(){       
        $(this).html(count++);
    })
    
  });