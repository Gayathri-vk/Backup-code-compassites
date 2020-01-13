console.log('me');
$(document).on ('click', '.lesson_ident', function(){
    console.log("lesson");
    var lesson_id = $(this).data('id'), lesson_slug = $(this).data('slug');
    var lesson_url = 'https://private-79f2e8-qlms.apiary-mock.com/lesson/'+lesson_id+'/'+lesson_slug;
    $.ajax({ 
        type: 'GET', 
        url: lesson_url,
        dataType: 'json',
        success: function (data) {
            $('.lesson_container').html('');
            for(i=0;i<data.length;i++) {
                if(data[i] != null) {
                    var lesson_content = '<div class="course-section"><hr><div class="col-md-12"><h4><span class="glyphicon glyphicon-play-circle"></span>'+data[i].title+'</h4><p>'+data[i].short_text+'</p><p>'+data[i].full_text+'</p></div><hr></div>';
                    $('.lesson_container').append(lesson_content);
                }
            }
        }    
    });
});

$(document).on ('click', '.course_ident', function(){
    console.log("course");
    var course_slug = $(this).data('slug');
    var lesson_url = 'https://private-79f2e8-qlms.apiary-mock.com/api/v1/course/'+course_slug;
    $.ajax({ 
        type: 'GET', 
        url: lesson_url,
        dataType: 'json',
        success: function (data) {
            $('.lesson_container').html('');
            for(i=0;i<data.length;i++) {
                if(data[i] != null) {
                    var course_content = '<div class="course-section"><hr><div class="col-md-12 lesson_ident" data-id="25" data-slug="optio-eum-vel-magnam-quod"><h4><span class="glyphicon glyphicon-play-circle"></span>'+data[i].title+'</h4></div><hr></div>';
                    $('.lesson_container').append(course_content);
                }
            }
        }    
    });
});