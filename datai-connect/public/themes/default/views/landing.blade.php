<div class="container loginContainer">
  <div class="main-eve"></div>
  <div class="row">
    <div class="col-md-7">
      <div id="myCarousel" class="carousel slide carousel-fade" data-ride="carousel">
            <!-- Carousel items -->
            <div class="carousel-inner">

              <!-- Slide 1 : Active -->
              <div class="item active">
                <div class="carousel-caption">
                  <h5>Plan, Develop, &amp; Execute the Entire Media Investment Process from a Single Comprehensive Platform</h5>
                </div><!-- /.carousel-caption -->
              </div><!-- /Slide1 -->

              <!-- Slide 2 -->
              <div class="item">
                <div class="carousel-caption">
                  <h5>Automate the creation of campaigns across Ad Servers, DSP’s, Google AdWords, &amp; Facebook Business Manager.</h5>
                </div><!-- /.carousel-caption -->
              </div><!-- /Slide2 -->

              <!-- Slide 3 -->
              <div class="item">
                <div class="carousel-caption">
                  <h5>Delivers consistent data structure for analysis &amp; optimization to further tune your media campaigns.</h5>
                </div><!-- /.carousel-caption -->
              </div><!-- /Slide3 -->

              <!-- Slide 4 -->
              <div class="item">
                <div class="carousel-caption">
                  <h5>An enterprise grade ERP to collaborate Advertisers, Media Agencies &amp; Creative Agencies.</h5>
                </div><!-- /.carousel-caption -->
              </div><!-- /Slide4 -->

              <!-- Slide 4 -->
              <div class="item">
                <div class="carousel-caption">
                  <h5>Achieve the three R’s—the Right message, to the Right person, at the Right time.</h5>
                </div><!-- /.carousel-caption -->
              </div><!-- /Slide4 -->

              <!-- Slide 4 -->
              <div class="item">
                <div class="carousel-caption">
                  <h5>Replace Disconnected Worksheets with One Integrated Application.</h5>
                </div><!-- /.carousel-caption -->
              </div><!-- /Slide4 -->

              <!-- Slide 4 -->
              <div class="item">
                <div class="carousel-caption">
                  <h5>Synchronized Reporting and Automation with Historical Data Automated Intelligently.</h5>
                </div><!-- /.carousel-caption -->
              </div><!-- /Slide4 -->

            </div><!-- /.carousel-inner -->
        </div>
    </div>
      <div class="col-md-4">
          <div id="signinDiv">
            <h2 class="register-heading">Create an Account</h2>
            <div class="panel panel-default">
              <div class="panel-body nopadding">

                <div class="login-bottom">

                  <ul class="signup-errors text-danger list-unstyled"></ul>

                  <form autocomplete="off" method="POST" class="signup-form" action="{{ url('/register') }}">
                    {{ csrf_field() }}

              <div class="row">
                <div class="col-md-12">

                </div>
                <div class="col-md-12">
                  <fieldset class="form-group required {{ $errors->has('email') ? ' has-error' : '' }}">
                    <!-- {{ Form::label('email', trans('auth.email_address')) }}  -->
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
                      <div class="col-md-12">
                        <fieldset class="form-group required {{ $errors->has('name') ? ' has-error' : '' }}">
                          <!-- {{ Form::label('name', trans('auth.name')) }}  -->
                          {{ Form::text('nSiame', NULL, ['class' => 'form-control', 'id' => 'name', 'placeholder'=> trans('auth.name')]) }}
                          @if ($errors->has('name'))
                          <span class="help-block">
                            {{ $errors->first('name') }}
                          </span>
                          @endif
                        </fieldset>
                      </div>
                      <div class="col-md-12">

                      </div>
                    </div>

                    <div class="row">
                      <div class="col-md-12">
                        <fieldset class="form-group required {{ $errors->has('username') ? ' has-error' : '' }}">
                          <!-- {{ Form::label('username', trans('common.username')) }}  -->
                          {{ Form::text('username', NULL, ['class' => 'form-control', 'id' => 'username', 'placeholder'=> trans('common.username')]) }}
                          @if ($errors->has('username'))
                          <span class="help-block">
                            {{ $errors->first('username') }}
                          </span>
                          @endif
                        </fieldset>
                      </div>
                      <div class="col-md-12">
                        <fieldset class="form-group required {{ $errors->has('password') ? ' has-error' : '' }}">
                          <!-- {{ Form::label('password', trans('auth.password')) }}  -->
                          {{ Form::password('password', ['class' => 'form-control', 'id' => 'password', 'autocomplete' => 'new-password', 'placeholder'=> trans('auth.password')]) }}
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
                      <div class="col-md-12">
                        <fieldset class="form-group">
                          <!-- {{ Form::label('birthday', trans('common.birthday')) }}<i class="optional">(optional)</i> -->
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
                      <div class="col-md-12">
                        <fieldset class="form-group">
                          <!-- {{ Form::label('city', trans('common.current_city')) }}<i class="optional">(optional)</i> -->
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
          <!-- @if (session('status'))
              <div class="alert alert-success">
                  {{ session('status') }}
              </div>
              @endif
          <div id="resetPasswordDiv" class="login-bottom">
              <h2 class="register-heading">Reset Password</h2>
              <form class="form-horizontal" role="form" method="POST" action="{{ url('/password/email') }}">
                  {!! csrf_field() !!}
                  <fieldset class="form-group {{ $errors->has('email') ? ' has-error' : '' }}">
                      {{ Form::label('email', trans('common.email_address')) }}
                      <input type="email" class="form-control" name="email" value="{{ old('email') }}" placeholder="{{ trans('common.enter_mail') }}">
                      @if ($errors->has('email'))
                          <span class="help-block">
                              <strong>{{ $errors->first('email') }}</strong>
                          </span>
                      @endif
                  </fieldset>
                  <fieldset class="form-group">
                      {{ Form::button( trans('common.send_password_reset_link') , ['type' => 'submit','class' => 'btn btn-success btn-submit']) }}
                  </fieldset>
              </form>

          </div>  -->
            <!-- /login-bottom -->
        </div>
    </div>
  </div><!-- /row -->
</div><!-- /container -->
{!! Theme::asset()->container('footer')->usePath()->add('app', 'js/app.js') !!}
