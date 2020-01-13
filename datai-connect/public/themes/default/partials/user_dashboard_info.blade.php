<h6 class="dashboard-title">Your Dashboard</h6>



                      <div class="dashboard-content">
                            <div class="row dashboard-row">
                          <div class="col-md-2 col-sm-2 col-xs-6 dashboard-info"><a href="{{ url($timeline->username.'/followers') }}" >
                              {{ $followers_count }}<span>{{ trans('common.followers') }}</span></a>
                          </div>
                          <div class="col-md-2 col-sm-2 col-xs-6 dashboard-info">
                              <a href="{{ url($timeline->username.'/following') }}" >{{ $following_count }}
                              <span>{{ trans('common.following') }}</span></a>
                          </div>
                          <div class="col-md-2 col-sm-2 col-xs-6 dashboard-info">
                            @if($user_post == true)
                            <a href="{{ url($timeline->username.'/posts') }}" >{{ count($timeline->posts()->where('active', 1)->get()) }}</span></a></li>
                            @else
                            <a href="#"><span class="top-list">{{ count($timeline->posts()->where('active', 1)->get()) }} </span>
                            @endif
                              <span>{{ trans('common.posts') }}</span>
                            </a>
                          </div>
@if($follow_confirm == "yes" && $timeline->id == Auth::user()->timeline_id)
            <div class="col-md-2 col-sm-2 col-xs-6 dashboard-info">
                              <a href="{{ url($timeline->username.'/follow-requests') }}" >{{count($followRequests)}}
                              <span>{{ trans('common.follow_requests') }}</span></a>
                          </div>
          @endif




                      </div>
                  </div>
