<div class="timeline-cover">
               <img src=" @if($timeline->cover_id) {{ url('user/cover/'.$timeline->cover->source) }} @else {{ url('user/cover/default-cover-user.png') }} @endif" alt="{{ $timeline->name }}" title="{{ $timeline->name }}">
               @if($timeline->id == Auth::user()->timeline_id)
                            <a href="#" class="btn btn-camera-cover change-cover"><i class="fa fa-camera" aria-hidden="true"></i><span class="change-cover-text">{{ trans('common.change_cover') }}</span></a>
                            @endif
                        <div class="user-cover-progress hidden">

                </div>


                </div>

<div class="container section-container ">
    <div class="row">
      <div class="col-md-12 col-sm-12 col-xs-12 timeline-cover-block">
                  <div class="timeline-cover-section">

  <div class="timeline-list">

      <div class="timeline-user-avtar">
         <div class="user-image">
        <img src="{{ $timeline->user->avatar }}" alt="{{ $timeline->name }}" title="{{ $timeline->name }}">
@if($timeline->id == Auth::user()->timeline_id)

                <div class="chang-user-avatar">
    <a href="#" class="btn btn-camera change-avatar"><i class="fa fa-pencil-square-o" aria-hidden="true"></i><span class="avatar-text">{{ trans('common.update_profile') }}<span>{{ trans('common.picture') }}</span></span></a>
</div>
@endif
<div class="user-avatar-progress hidden">
        </div>


</div>

         <div class="edit-user-block">
                {!! Theme::partial('user_edit_info',compact('user','timeline','liked_pages','joined_groups','followRequests','following_count','followers_count','follow_confirm','user_post','joined_groups_count','guest_events','follow_user_status')) !!}
        </div>

        <div class="user-edit-mobile-view">

         {!! Theme::partial('user_edit_info_mobile',compact('user','timeline','liked_pages','joined_groups','followRequests','following_count','followers_count','follow_confirm','user_post','joined_groups_count','guest_events','follow_user_status')) !!}

           

    </div><!-- Edit User Mobile View -->
  </div><!-- timeline-cover-section -->
 
              </div>
    </div>

      <div class="col-md-12 col-sm-12 col-xs-12 timeline-block">


          <div class="timeline">
            <div class="col-md-2 col-sm-3 col-xs-4">


                              </div>

            <!-- Post box on timeline,page,group -->
       <div class="col-md-10 col-sm-9 col-xs-8 dashboard-block">
                  <div class="dashboard">
                       {!! Theme::partial('user_dashboard_info',compact('user','timeline','liked_pages','joined_groups','followRequests','following_count','followers_count','follow_confirm','user_post','joined_groups_count','guest_events')) !!}   
                  </div>
                    <!--Follower block-->
      <div class="followers-block  row">

      @if(count($following) > 0)
      @foreach($following as $follower)
      <!--Cover picture-->
      <div class="followers-details col-md-3 col-sm-6 col-xs-12">
      <div class="followers-cover">
      <img src="{{ $follower->avatar }}" alt="{{ $follower->name }}" title="{{ $follower->name }}">
      <div class="user-cover-image-progress">
      </div>
      </div>
      <!--Profile picture-->
      <div class="followers-profile-img">
       <img src="{{ $follower->avatar }}" alt="{{ $follower->name }}" title="{{ $follower->name }}">
      </div>
      <!--Follower name-->
      <div class="follower-info-block">
      <div class="row">
      <div class="col-md-6 col-sm-6 col-xs-6"></div>
      <div class="col-md-6 col-sm-6 col-xs-6 follower-name">{{$follower->name}}</div>
      </div>
      <!--Follower profile details-->
      <div class="follower-profile">
      <h6 class="follower-designation">Sr Technical Manager</h6>
      <h6 class="follower-company">XYZ company</h6>
      <div class="follows-you">
      <span>Follows you</span>
      </div>
      <p class="follower-status">Status Comes Here..</p>

      </div>

      </div>
      <!--Onhover display of follower-->
      <div class="follower-settings">
      <!--eye icon-->
      <div class="eye-icon">
      <a href="{{ url($follower->username) }}">
      <img  src="{{url('themes/default/assets/images/customicons/eye.svg')}}"  alt="eye-icon"/>
      <label class="eye-icon-label">VIEW</label>
      </a>
      </div>
      <!--view and message icon row-->
      
      <div class="view-message">
      <div class=" col-md-6 col-sm-6 col-xs-6 send-message">
      <a href="">
      <img  src="{{url('themes/default/assets/images/customicons/message.svg')}}"  alt="message-icon"/>
      <label class="send-message-icon-label">MESSAGE</label>
      </a>
      </div>
      
      </div>
      </div>
      </div>
      @endforeach
      @endif




      </div>


      </div><!-- /col-md-10 -->



    </div><!-- /row -->


        </div>
 



 


 


 




</div>


</div>


</div>

<script type="text/javascript">
  @if($timeline->background_id != NULL)
    $('body')
      .css('background-image', "url({{ url('/wallpaper/'.$timeline->wallpaper->source) }})")
      .css('background-attachment', 'fixed');
  @endif
</script>