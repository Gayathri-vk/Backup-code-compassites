<div class="right-side-section">

	 
	
	<div class="panel panel-default">
		<div class="panel-heading no-bg">
			<h3 class="panel-title">
				{{ trans('common.suggested_people') }}
			</h3>
		</div>
		<div class="panel-body">
			<!-- widget holder starts here -->
			<div class="user-follow socialite">
				<!-- Each user is represented with media block -->
				@if($suggested_users != "")

				@foreach($suggested_users as $suggested_user)
	
				<div class="media">
					<div class="media-left badge-verification">
						<a href="{{ url($suggested_user->username) }}">
							<img src="{{ $suggested_user->avatar }}" class="img-icon" alt="{{ $suggested_user->name }}" title="{{ $suggested_user->name }}">
							@if($suggested_user->verified)
							<span class="verified-badge bg-success verified-medium">
								<i class="fa fa-check"></i>
							</span>
							@endif
						</a>
					</div>
					<div class="media-body socialte-timeline follow-links">
						<h4 class="media-heading"><a href="{{ url($suggested_user->username) }}">{{ $suggested_user->name }} </a>
							<span class="text-muted">{{ '@'.$suggested_user->username }}</span>
							<time class="post-time timeago" datetime="{{ $suggested_user->created_at }}+00:00" title="{{ $suggested_user->created_at }}+00:00">
                            {{ $suggested_user->created_at }}+00:00
                            </time>
						</h4>
							<div class="btn-follow">
								<a href="#" class="btn btn-default follow-user follow" data-timeline-id="{{ $suggested_user->timeline->id }}"> <i class="fa fa-user-plus"></i> {{ trans('common.follow') }}</a>
							</div>
							<div class="btn-follow hidden">
								<a href="#" class="btn btn-success follow-user unfollow" data-timeline-id="{{ $suggested_user->timeline->id }}"><i class="fa fa-check"></i> {{ trans('common.following') }}</a>
							</div>
						</div>
					</div>
					@endforeach
					@else
					<div class="alert alert-warning">
						{{ trans('messages.no_suggested_users') }}
					</div>
					@endif

				</div>
				<!-- widget holder ends here -->
			</div>
		</div>


        <div class="panel panel-default">
		<div class="panel-heading no-bg">
			<h3 class="panel-title">
				{{ trans('common.popular_people') }}
			</h3>
		</div>
		<div class="panel-body">
			<!-- widget holder starts here -->
			<div class="user-follow socialite">
				<!-- Each user is represented with media block -->
				@if($popularUsers != "")

				@foreach($popularUsers as $count)

				<div class="media">
					<div class="media-left badge-verification">
						<a href="{{ url($count->username) }}">
							<img src="{{ $count->avatar }}" class="img-icon" alt="{{ $count->name }}" title="{{ $count->name }}">
							@if($count->verified)
							<span class="verified-badge bg-success verified-medium">
								<i class="fa fa-check"></i>
							</span>
							@endif
						</a>
					</div>
					<div class="media-body socialte-timeline follow-links">
						<h4 class="media-heading"><a href="{{ url($count->username) }}">{{ $count->name }} </a>
							<span class="text-muted">{{count($count->followers).' followers' }}</span>
						</h4>
							<div class="btn-follow">
								<a href="#" class="btn btn-default follow-user follow" data-timeline-id="{{ $count->timeline_id }}"> <i class="fa fa-user-plus"></i> {{ trans('common.follow') }}</a>
							</div>
							<div class="btn-follow hidden">
								<a href="#" class="btn btn-success follow-user unfollow" data-timeline-id="{{ $count->timeline_id }}"><i class="fa fa-user-plus"></i> {{ trans('common.following') }}</a>
							</div>
						</div>
					</div>
					@endforeach
					@else
					<div class="alert alert-warning">
						{{ trans('messages.no_popular_users') }}
					</div>
					@endif

				</div>
				<!-- widget holder ends here -->
			</div>
		</div>









	 

		 

			@if(Setting::get('home_ad') != NULL)
			<div id="link_other" class="post-filters">
				{!! htmlspecialchars_decode(Setting::get('home_ad')) !!}
			</div>
			@endif
		<div class="socialite-terms text-center">
			<!-- {{ trans('common.copyright') }} &copy; {{ date('Y') }} {{ Setting::get('site_name') }}. {{ trans('common.all_rights_reserved') }} -->
			{{ trans('common.copyright') }} &copy; {{ date('Y') }} DatAi Connect. {{ trans('common.all_rights_reserved') }}
		</div>
		</div>