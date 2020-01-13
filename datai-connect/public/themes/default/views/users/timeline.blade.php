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
    <a href="#" class="btn btn-camera change-avatar"><i class="fa fa-camera" aria-hidden="true"></i><span class="avatar-text">{{ trans('common.update_profile') }}<span>{{ trans('common.picture') }}</span></span></a>
</div>
@endif

<!-- Change avatar form -->
<form class="change-avatar-form hidden" action="{{ url('ajax/change-avatar') }}" method="post" enctype="multipart/form-data">
  <input name="timeline_id" value="{{ $timeline->id }}" type="hidden">
  <input name="timeline_type" value="{{ $timeline->type }}" type="hidden">
  <input class="change-avatar-input hidden" accept="image/jpeg,image/png" type="file" name="change_avatar" >
</form>

<!-- Change cover form -->
<form class="change-cover-form hidden" action="{{ url('ajax/change-cover') }}" method="post" enctype="multipart/form-data">
  <input name="timeline_id" value="{{ $timeline->id }}" type="hidden">
  <input name="timeline_type" value="{{ $timeline->type }}" type="hidden">
  <input class="change-cover-input hidden" accept="image/jpeg,image/png" type="file" name="change_cover" >
</form>
<div class="user-avatar-progress hidden">
        </div>


</div>

         <div class="edit-user-block">
                {!! Theme::partial('user_edit_info',compact('user','timeline','liked_pages','joined_groups','followRequests','following_count','followers_count','follow_confirm','user_post','joined_groups_count','guest_events', 'follow_user_status')) !!}
        </div>

        <div class="user-edit-mobile-view">

         {!! Theme::partial('user_edit_info_mobile',compact('user','timeline','liked_pages','joined_groups','followRequests','following_count','followers_count','follow_confirm','user_post','joined_groups_count','guest_events', 'follow_user_status')) !!}



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
                  <div class="row">
                      <div class="col-md-7 col-sm-7 user-post">
                        <div class="">

@if($timeline->type == "user" && $timeline_post == true)
                {!! Theme::partial('create-post',compact('timeline','user_post')) !!}

@endif



<div class="timeline-posts">
<div class="jscroll-inner">
                @if($user_post == "user" || $user_post == "page" || $user_post == "group")
                  @if(count($posts) > 0)
                    @foreach($posts as $post)
                      {!! Theme::partial('post',compact('post','timeline','next_page_url','user')) !!}
                    @endforeach
                  @else
                    <div class="no-posts alert alert-warning">{{ trans('messages.no_posts') }}</div>
                  @endif
                @endif

                @if($user_post == "event")
                  @if($event->type == 'private' && Auth::user()->get_eventuser($event->id) || $event->type == 'public')
                    @if(count($posts) > 0)
                      @foreach($posts as $post)
                        {!! Theme::partial('post',compact('post','timeline','next_page_url','user')) !!}
                      @endforeach
                    @else
                      <div class="no-posts alert alert-warning">{{ trans('messages.no_posts') }}</div>
                    @endif
                  @else
                    <div class="no-posts alert alert-warning">{{ trans('messages.private_posts') }}</div>
                  @endif
                @endif
              </div></div>






            </div>
                      </div>
                      <div class="col-md-5 col-sm-5 course-block">
                          <div class="user-progress">Progress Bar
                          </div>
                          <div class="add-new-skill-block">
                              <h5>Add new skills with these courses</h5>
                              <div class="row">
                               <div class="video-block col-md-4">
                                  <iframe class="videos" width="420" height="345" src="https://www.youtube.com/embed/tgbNymZ7vqY"></iframe>
                              </div>
                              <div class="video-description col-md-7">
                                  <p>Learning Dynamics Talent</p>
                                  <span>Viewers 0</span>
                              </div>

                              </div>
                              <div class="row">
                               <div class="video-block col-md-4">
                                  <iframe class="videos" width="420" height="345" src="https://www.youtube.com/embed/tgbNymZ7vqY"></iframe>
                              </div>
                              <div class="video-description col-md-7">
                                  <p>Dynamics 365:Setup The LinkedIn Sales Navigator Integration</p>
                                  <span>Viewers 2,951</span>
                              </div>

                              </div>


                          </div>
                      </div>
                  </div>


			</div><!-- /col-md-10 -->



		</div><!-- /row -->


        </div>















</div>


</div>


</div>
  <script type="text/javascript" src="{{ Theme::asset()->url('js/custom.js') }}"></script> 
<script type="text/javascript">
  @if($timeline->background_id != NULL)
    $('body')
      .css('background-image', "url({{ url('/wallpaper/'.$timeline->wallpaper->source) }})")
      .css('background-attachment', 'fixed');
  @endif
</script>
