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
                {!! Theme::partial('user_edit_info',compact('user','timeline','liked_pages','joined_groups','followRequests','following_count','followers_count','follow_confirm','user_post','joined_groups_count','guest_events')) !!}
        </div>

        <div class="user-edit-mobile-view">

         {!! Theme::partial('user_edit_info_mobile',compact('user','timeline','liked_pages','joined_groups','followRequests','following_count','followers_count','follow_confirm','user_post','joined_groups_count','guest_events')) !!}

           

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
      <!-- Request Block -->

      <div class="col-md-8 joinRequest">            

            <div class="panel panel-default">
              <div class="panel-heading">
                <h3 class="panel-title">{{ trans('common.join_requests') }}</h3>            
              </div>
              <div class="panel-body group-suggested-users">

                {{-- @include('flash::message') --}}
                @if(count($followRequests))
                  @foreach($followRequests as $followRequest)

                    <div class="holder">
                      <div class="follower pull-left">
                        <a href="{{ url($followRequest->username) }}">
                          <img src="{{ $followRequest->avatar }}" alt="{{ $followRequest->name }}" class="img-icon img-30" title="{{ $followRequest->name }}">
                        </a>
                        <a href="{{ url($followRequest->username) }}">
                          <span>{{ $followRequest->username }}</span>
                        </a>
                        @if($followRequest->verified)
                                <span class="verified-badge bg-success">
                                      <i class="fa fa-check"></i>
                                  </span>
                              @endif

                      </div>

                      <div class="follow-links pull-right">
                        <div class="left-col">
                          <a href="#" class="btn btn-to-follow accept-follow btn-success accept" data-user-id="{{ $followRequest->id }}">
                            <i class="fa fa-thumbs-up"></i> {{ trans('common.accept') }} 
                          </a>
                          <a href="#" class="btn btn-to-follow reject-follow btn-danger reject" data-user-id="{{ $followRequest->id }}">
                            <i class="fa fa-thumbs-down"></i> {{ trans('common.decline') }}
                          </a>
                        </div>
                      </div>

                    </div>
                  @endforeach
                @else
                  <div class="alert alert-warning">{{ trans('messages.no_requests') }}</div>
                @endif
              </div>
            </div><!-- /panel -->
          </div><!-- /col-md-8 -->

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