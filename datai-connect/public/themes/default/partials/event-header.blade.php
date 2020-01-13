<div class="timeline-cover-section">
	<div class="timeline-cover">
		<img src=" @if($timeline->cover_id) {{ url('event/cover/'.$timeline->cover->source) }} @else {{ url('event/cover/default-cover-event.png') }} @endif" alt="{{ $timeline->name }}" title="{{ $timeline->name }}">
		@if($timeline->event->is_eventadmin(Auth::user()->id, $event->id))
		<a href="#" class="btn btn-camera-cover change-cover"><i class="fa fa-camera" aria-hidden="true"></i><span class="change-cover-text">{{ trans('common.change_cover') }}</span></a>
		@endif
		<div class="user-cover-progress hidden"></div>
		<div class="user-timeline-name event">		
			<a href="{{ url($timeline->username) }}">{{ $timeline->name }}</a>
			{!! verifiedBadge($timeline) !!}		
		</div>		
	</div>

	<div class="timeline-list event">
		@if($event->type == 'private' && Auth::user()->get_eventuser($event->id) || $event->type == 'public')
			<ul class="list-inline pagelike-links">				
				@if(($event->is_eventadmin(Auth::user()->id, $event->id) && $event->invite_privacy == 'only_admins')  && $event->isExpire($event->id) || ($event->invite_privacy == 'only_guests' && Auth::user()->get_eventuser($event->id) && $event->isExpire($event->id)))
					<li class="{{ Request::segment(2) == 'add-eventmembers' ? 'active' : '' }}">
						<a href="{{ url($timeline->username.'/add-eventmembers')}}" ><span class="top-list"> {{ trans('common.invitemembers') }}</span></a>
					</li>	
				@endif
				
				<li class="{{ Request::segment(2) == 'eventguests' ? 'active' : '' }}"><a href="{{ url($timeline->username.'/eventguests/')}}">
					<span class="top-list">
						{{ $event->guests($event->user_id) != false ? count($event->guests($event->user_id)) : 0 }} {{ trans('common.guests') }}
					</span>
					</a>
				</li>		
				
				<li class="{{ Request::segment(2) == 'event-posts' ? 'active' : '' }}">
					<a href="{{ url($timeline->username.'/event-posts') }}">
						<span class="top-list">{{ count($timeline->posts()->where('active', 1)->get()) }} {{ trans('common.posts') }}</span>
					</a>
				</li>

				@if(!$timeline->event->is_eventadmin(Auth::user()->id, $event->id))
				<li class="dropdown largescreen-report"><a href="#" class=" dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><span class="top-list"> <i class="fa fa-ellipsis-h"></i></span></a>
					<ul class="dropdown-menu  report-dropdown">
						
						<li class="">
							<a href="#" class="save-timeline" data-timeline-id="{{ $timeline->id }}">
								<span class="top-list"><i class="fa fa-save"></i>
								@if($timeline->usersSaved()->where('user_id',Auth::user()->id)->get()->isEmpty())
									{{ trans('common.save') }}
								@else
									{{ trans('common.unsave') }}
								@endif
								</span>
							</a>
						</li>
					</ul>
				</li>
				@endif
				@if($timeline->event->is_eventadmin(Auth::user()->id, $event->id))
					<li class="pull-right">
						<a href="#" class="event-report eventdelete text-danger" data-event-id="{{ $event->id }}-{{Auth::user()->username}}"> <i class="fa fa-trash" aria-hidden="true"></i>
							{{ trans('common.delete') }}
						</a>
					</li>						
				@endif
			</ul>
		@endif

		<div class="status-button">
			<a href="#" class="btn btn-status">{{ trans('common.status') }}</a>
		</div>

		<div class="event-avatar">
			<div class="event-date">
					{{ date("d", strtotime($event->start_date)) }}
			</div>			
			<div class="event-month">
				{{ date("M", strtotime($event->start_date)) }}
			</div>
		</div>

	</div>
</div>
