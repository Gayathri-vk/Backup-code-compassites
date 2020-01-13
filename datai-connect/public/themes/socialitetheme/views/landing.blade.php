<div class="container">
  <div class="text-center welcome-message">
    <h2>{!! Setting::get('home_welcome_message') !!}</h2>
    @if (Config::get('app.env') == 'demo')
    <p>
      Check out the RTL version of Socialite: <a href="http://socialite-rtl.laravelguru.com" target="_blank">Click Here</a>
    </p>
    @endif
  </div>
  <div class="row">
    <div class="col-lg-4 col-md-5 col-sm-12 col-xs-12">
      <div class="panel panel-default">
        <div class="panel-body nopadding">
          <div class="icon-boxes">
            <div class="application-image">
              <img src="{!! url('setting/app-icon1.png') !!}" alt="">
            </div>
            <div class="app-files">
              {!! Setting::get('home_widget_one') !!}
            </div>
          {{-- <div class="new-campaign">
            <a href="#" class="btn btn-success app-btn">Start new Campaign</a>
          </div> --}}
        </div>
      </div>
    </div>
  </div>
  <div class="col-lg-4 col-md-5 col-sm-12 col-xs-12">
    <div class="panel panel-default">
      <div class="panel-body nopadding">
        <div class="icon-boxes">
          <div class="application-image">
            <img src="{!! url('setting/app-icon2.png') !!}" alt="">
          </div>
          <div class="app-files">
            {!! Setting::get('home_widget_two') !!}
          </div>
          {{-- <div class="new-campaign">
            <a href="#" class="btn btn-success app-btn">View your Reports</a>
          </div> --}}
        </div>
      </div>
    </div>
  </div>
  <div class="col-lg-4 col-md-5 col-sm-12 col-xs-12">
    <div class="panel panel-default">
      <div class="panel-body nopadding">
        <div class="icon-boxes">
          <div class="application-image">
            <img src="{!! url('setting/app-icon3.png') !!}" alt="">
          </div>
          <div class="app-files">
            {!! Setting::get('home_widget_three') !!}
          </div>
          {{-- <div class="new-campaign">
            <a href="#" class="btn btn-success app-btn">Start Using Dashboard</a>
          </div> --}}
        </div>
      </div>
    </div>
  </div>
</div><!-- /row -->

<div class="row tpadding-20">
  <div class="col-md-7 features-list">
    <h2>{!! Setting::get('home_list_heading') !!}</h2>
    <div class="panel panel-default">
      <div class="panel-body">
        <ul class="list-unstyled">
          @if(Setting::get('home_feature_one_icon') != null || Setting::get('home_feature_one') != null)
          <li>
            <i class="fa fa-{{ Setting::get('home_feature_one_icon') }}"></i> {{ Setting::get('home_feature_one') }}
          </li>
          @endif
          @if(Setting::get('home_feature_two_icon') != null || Setting::get('home_feature_two') != null)
            <li>
              <i class="fa fa-{{ Setting::get('home_feature_two_icon') }}"></i> {{ Setting::get('home_feature_two') }}
            </li>
          @endif
          @if(Setting::get('home_feature_three_icon') != null || Setting::get('home_feature_three') != null)
            <li>
              <i class="fa fa-{{ Setting::get('home_feature_three_icon') }}"></i> {{ Setting::get('home_feature_three') }}
            </li>
          @endif
          @if(Setting::get('home_feature_four_icon') != null || Setting::get('home_feature_four') != null)
            <li>
              <i class="fa fa-{{ Setting::get('home_feature_four_icon') }}"></i> {{ Setting::get('home_feature_four') }}
            </li>
          @endif
          @if(Setting::get('home_feature_five_icon') != null || Setting::get('home_feature_five') != null)
            <li>
              <i class="fa fa-{{ Setting::get('home_feature_five_icon') }}"></i> {{ Setting::get('home_feature_five') }}
            </li>
          @endif
          @if(Setting::get('home_feature_six_icon') != null || Setting::get('home_feature_six') != null)
            <li>
              <i class="fa fa-{{ Setting::get('home_feature_six_icon') }}"></i> {{ Setting::get('home_feature_six') }}
            </li>
          @endif
          @if(Setting::get('home_feature_seven_icon') != null || Setting::get('home_feature_seven') != null)
            <li>
              <i class="fa fa-{{ Setting::get('home_feature_seven_icon') }}"></i> {{ Setting::get('home_feature_seven') }}
            </li>
          @endif
          @if(Setting::get('home_feature_eight_icon') != null || Setting::get('home_feature_eight') != null)
            <li>
              <i class="fa fa-{{ Setting::get('home_feature_eight_icon') }}"></i> {{ Setting::get('home_feature_eight') }}
            </li>
          @endif
          @if(Setting::get('home_feature_nine_icon') != null || Setting::get('home_feature_nine') != null)
            <li>
              <i class="fa fa-{{ Setting::get('home_feature_nine_icon') }}"></i> {{ Setting::get('home_feature_nine') }}
            </li>
          @endif
          @if(Setting::get('home_feature_ten_icon') != null || Setting::get('home_feature_ten') != null)
            <li>
              <i class="fa fa-{{ Setting::get('home_feature_ten_icon') }}"></i> {{ Setting::get('home_feature_ten') }}
            </li>
          @endif
        </ul>
      </div>
    </div>
  </div>
  <div class="col-md-5">

    <h2 class="register-heading">Create an Account</h2>
    <div class="panel panel-default">
      <div class="panel-body nopadding">

        <div class="login-bottom">

          <ul class="signup-errors text-danger list-unstyled"></ul>

          <form method="POST" class="signup-form" action="{{ url('/register') }}">
            {{ csrf_field() }}

            <div class="row">
              <div class="col-md-6">
                <fieldset class="form-group{{ $errors->has('affiliate') ? ' has-error' : '' }}">
                  {{ Form::label('affiliate', trans('auth.affiliate_code')) }}<i class="optional">(optional)</i>
                  @if(isset($_GET['affiliate']))
                  {{ Form::text('affiliate', $_GET['affiliate'], ['class' => 'form-control', 'id' => 'affiliate', 'disabled' =>'disabled']) }}
                  {{ Form::hidden('affiliate', $_GET['affiliate']) }}
                  @else
                  {{ Form::text('affiliate', NULL, ['class' => 'form-control', 'id' => 'affiliate', 'placeholder'=> trans('auth.affiliate_code')]) }}
                  @endif

                  @if ($errors->has('affiliate'))
                  <span class="help-block">
                    {{ $errors->first('affiliate') }}
                  </span>
                  @endif
                </fieldset>
              </div>
              <div class="col-md-6">
                <fieldset class="form-group required {{ $errors->has('email') ? ' has-error' : '' }}">
                  {{ Form::label('email', trans('auth.email_address')) }} 
                  {{ Form::text('email', NULL, ['class' => 'form-control', 'id' => 'email', 'placeholder'=> trans('auth.welcome_to')]) }}
                  @if ($errors->has('email'))
                  <span class="help-block">
                    {{ $errors->first('email') }}
                  </span>
                  @endif
                </fieldset>
              </div>
            </div>

            <div class="row">
              <div class="col-md-6">
                <fieldset class="form-group required {{ $errors->has('name') ? ' has-error' : '' }}">
                  {{ Form::label('name', trans('auth.name')) }} 
                  {{ Form::text('name', NULL, ['class' => 'form-control', 'id' => 'name', 'placeholder'=> trans('auth.name')]) }}
                  @if ($errors->has('name'))
                  <span class="help-block">
                    {{ $errors->first('name') }}
                  </span>
                  @endif
                </fieldset>
              </div>
              <div class="col-md-6">
                <fieldset class="form-group required {{ $errors->has('gender') ? ' has-error' : '' }}">
                  {{ Form::label('gender', trans('common.gender')) }} 
                  {{ Form::select('gender', array('female' => 'Female', 'male' => 'Male', 'other' => 'None'), null, ['placeholder' => trans('auth.select_gender'), 'class' => 'form-control']) }}
                  @if ($errors->has('gender'))
                  <span class="help-block">
                    {{ $errors->first('gender') }}
                  </span>
                  @endif
                </fieldset>
              </div>
            </div>

            <div class="row">
              <div class="col-md-6">
                <fieldset class="form-group required {{ $errors->has('username') ? ' has-error' : '' }}">
                  {{ Form::label('username', trans('common.username')) }} 
                  {{ Form::text('username', NULL, ['class' => 'form-control', 'id' => 'username', 'placeholder'=> trans('common.username')]) }}
                  @if ($errors->has('username'))
                  <span class="help-block">
                    {{ $errors->first('username') }}
                  </span>
                  @endif
                </fieldset>
              </div>
              <div class="col-md-6">
                <fieldset class="form-group required {{ $errors->has('password') ? ' has-error' : '' }}">
                  {{ Form::label('password', trans('auth.password')) }} 
                  {{ Form::password('password', ['class' => 'form-control', 'id' => 'password', 'placeholder'=> trans('auth.password')]) }}
                  @if ($errors->has('password'))
                  <span class="help-block">
                    {{ $errors->first('password') }}
                  </span>
                  @endif
                </fieldset>
              </div>
            </div>

            <div class="row">
              @if(Setting::get('birthday') == "on")
              <div class="col-md-6">
                <fieldset class="form-group">
                  {{ Form::label('birthday', trans('common.birthday')) }}<i class="optional">(optional)</i>
                  <div class="input-group date datepicker">
                    <span class="input-group-addon addon-left calendar-addon">
                      <span class="fa fa-calendar"></span>
                    </span>
                    {{ Form::text('birthday', NULL, ['class' => 'form-control', 'id' => 'datepicker1']) }}
                    <span class="input-group-addon addon-right angle-addon">
                      <span class="fa fa-angle-down"></span>
                    </span>
                  </div>
                </fieldset>
              </div>
              @endif

              @if(Setting::get('city') == "on")
              <div class="col-md-6">
                <fieldset class="form-group">
                  {{ Form::label('city', trans('common.current_city')) }}<i class="optional">(optional)</i>
                  {{ Form::text('city', NULL, ['class' => 'form-control', 'placeholder' => trans('common.current_city')]) }}
                </fieldset>
              </div>
              @endif   
            </div>

            <div class="row">
              @if(Setting::get('captcha') == "on")
              <div class="col-md-12">
                <fieldset class="form-group{{ $errors->has('captcha_error') ? ' has-error' : '' }}">
                  {!! app('captcha')->display() !!}
                  @if ($errors->has('captcha_error'))
                  <span class="help-block">
                    {{ $errors->first('captcha_error') }}
                  </span>
                  @endif
                </fieldset>
              </div>    
              @endif    
            </div>

            {{ Form::button(trans('auth.signup_to_dashboard'), ['type' => 'submit','class' => 'btn btn-success btn-submit']) }}
          </form>
        </div>  
        @if((env('GOOGLE_CLIENT_ID') != NULL && env('GOOGLE_CLIENT_SECRET') != NULL) ||
          (env('TWITTER_CLIENT_ID') != NULL && env('TWITTER_CLIENT_SECRET') != NULL) ||
          (env('FACEBOOK_CLIENT_ID') != NULL && env('FACEBOOK_CLIENT_SECRET') != NULL) ||
          (env('LINKEDIN_CLIENT_ID') != NULL && env('LINKEDIN_CLIENT_SECRET') != NULL) )
          <div class="divider-login">
            <div class="divider-text"> {{ trans('auth.login_via_social_networks') }}</div>
          </div>
          @endif
          <ul class="list-inline social-connect">
            @if(env('GOOGLE_CLIENT_ID') != NULL && env('GOOGLE_CLIENT_SECRET') != NULL)
            <li><a href="{{ url('google') }}" class="btn btn-social google-plus"><span class="social-circle"><i class="fa fa-google-plus" aria-hidden="true"></i></span></a></li> 
            @endif

            @if(env('TWITTER_CLIENT_ID') != NULL && env('TWITTER_CLIENT_SECRET') != NULL)
            <li><a href="{{ url('twitter') }}" class="btn btn-social tw"><span class="social-circle"><i class="fa fa-twitter" aria-hidden="true"></i></span></a></li>
            @endif

            @if(env('FACEBOOK_CLIENT_ID') != NULL && env('FACEBOOK_CLIENT_SECRET') != NULL)
            <li><a href="{{ url('facebook') }}" class="btn btn-social fb"><span class="social-circle"><i class="fa fa-facebook" aria-hidden="true"></i></span></a></li>
            @endif

            @if(env('LINKEDIN_CLIENT_ID') != NULL && env('LINKEDIN_CLIENT_SECRET') != NULL) 
            <li><a href="{{ url('linkedin') }}" class="btn btn-social linkedin"><span class="social-circle"><i class="fa fa-linkedin" aria-hidden="true"></i></span></a></li>
            @endif
          </ul>
        </div>
      </div><!-- /panel -->
    </div>
  </div><!-- /row -->
</div><!-- /container -->
{!! Theme::asset()->container('footer')->usePath()->add('app', 'js/app.js') !!}