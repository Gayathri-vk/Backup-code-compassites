<!-- main-section -->	
<div class="container">
	<div class="row">              
		<div class="col-md-8 col-lg-8">
			<div class="panel panel-default">
				<div class="panel-heading no-bg panel-settings">
					<h3 class="panel-title">{{ trans('common.create_album') }}</h3>
				</div>

				<div class="panel-body nopadding">  
					<div class="socialite-form">
						@include('flash::message')                         
						<form class="margin-right" method="POST" action="{{ url('/'.Auth::user()->username.'/album/create') }}" files="true" enctype="multipart/form-data">
							{{ csrf_field() }}

							<div class="row">
								<div class="col-md-6">
									<fieldset class="form-group required {{ $errors->has('name') ? ' has-error' : '' }}">
										{{ Form::label('name', trans('auth.name'), ['class' => 'control-label']) }}
										{{ Form::text('name', old('name'), ['class' => 'form-control', 'placeholder' => trans('common.name_of_the_album')]) }}
										@if ($errors->has('name'))
											<span class="help-block">
												{{ $errors->first('name') }}
											</span>
										@endif
									</fieldset>
								</div>
								<div class="col-md-6">
									<fieldset class="form-group required {{ $errors->has('privacy') ? ' has-error' : '' }}">
										{{ Form::label('privacy', trans('common.privacy_type'), ['class' => 'control-label']) }}
										{{ Form::select('privacy', array('' => trans('admin.please_select'), 'private' => trans('common.private'), 'public' => trans('common.public')), 'public' ,array('class' => 'form-control')) }}
										@if ($errors->has('privacy'))
											<span class="help-block">
												{{ $errors->first('privacy') }}
											</span>
										@endif
									</fieldset>
								</div>
							</div>

							<fieldset class="form-group">
								{{ Form::label('about', trans('common.about'), ['class' => 'control-label']) }}
								{{ Form::textarea('about', old('about'), ['class' => 'form-control', 'placeholder' => trans('messages.create_album_placeholder'), 'rows' => '4', 'cols' => '20']) }}
							</fieldset>

							<fieldset class="form-group">
								{{ Form::label('album_photos', trans('common.upload_photos'), ['class' => 'control-label']) }}
								{{ Form::file('album_photos[]', ['multiple' => 'multiple', 'accept' =>  'image/jpeg,image/png,image/gif']) }}
							</fieldset>

							<fieldset class="form-group">
								<div class="pull-right">
									<a href="#" class="add-youtube-input">{{ '+ '.trans('common.one_more') }}</a>
								</div>
								{{ Form::label('album_videos[]', trans('common.youtube_links'), ['class' => 'control-label']) }}
								<div class="youtube-videos">
									{{ Form::text('album_videos[]', null, ['class' => 'form-control youtube_link', 'placeholder' => trans('common.copy_paste_youtube_link')] ) }}
								</div>
							</fieldset>
							
							<fieldset class="form-group">
								<div class="pull-right">
									{{ Form::submit(trans('common.create_album'), ['class' => 'btn btn-success']) }}
								</div>
							</fieldset>

						</form>
					</div><!-- /socialite-form -->
				</div>
			</div><!-- /panel -->		
		</div><!-- /col-md-8 -->

		<div class="col-md-4 col-lg-4">
			{!! Theme::partial('home-rightbar',compact('suggested_users','suggested_groups','suggested_pages','timeline')) !!}
		</div>
	</div>
</div>	
<!-- /main-section -->