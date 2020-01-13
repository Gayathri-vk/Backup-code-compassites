 <div class="widget-events widget-left-panel">
              <div class="menu-list menuposfixed">
                <ul class="list-unstyled">
                  <li>
                  	<a href="{{ url(Auth::user()->username.'/followers') }}"class="btn menu-btn"><span class="event-circle">{{ Auth::user()->followers->count() }}</span><i class="connections-icon" aria-hidden="true"></i>{{ trans('common.followers') }}  </a>
                  </li>
                   <li>
                    <a href="{{ url(Auth::user()->username.'/following') }}" class="btn menu-btn"><span class="event-circle">{{ Auth::user()->following->count() }}</span><i class="keep-connecting-icon" aria-hidden="true"></i>{{ trans('common.following') }}</a>
                  </li>
                  <li>
                    <a href="{{ url(Auth::user()->username.'/follow-requests') }}"class="btn menu-btn"><span class="event-circle">{{count($followRequests = Auth::user()->followers()->where('status', '=', 'pending')->get())}} </span><i class="invitation-icon" aria-hidden="true"></i>{{ trans('common.follow_requests') }} </a>
                  </li>
                  
                 
                </ul>
              </div>
            </div>