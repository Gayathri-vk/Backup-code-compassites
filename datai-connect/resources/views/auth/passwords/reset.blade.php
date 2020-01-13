@extends('layouts.app')

@section('content')
<div class="container loginContainer">
  <div class="main-eve"></div>
  <div class="row">
      <div class="col-md-4">
          <div id="resetPasswordDivLink" class="login-bottom">
              <h2 class="register-heading">Reset Password</h2>
              <form class="form-horizontal" role="form" method="POST" action="{{ url('/password/reset') }}">
                {!! csrf_field() !!}

                <input type="hidden" name="token" value="{!! $token !!}">

                <div class="form-group{{ $errors->has('email') ? ' has-error' : '' }}">
                    <!-- <label class="col-md-4 control-label">E-Mail Address</label> -->

                    <div class="col-md-12">
                        <input type="email" class="form-control" placeholder="E-Mail Address" name="email" value="{{ $email or old('email') }}">

                        @if ($errors->has('email'))
                            <span class="help-block">
                                <strong>{{ $errors->first('email') }}</strong>
                            </span>
                        @endif
                    </div>
                </div>

                <div class="form-group{{ $errors->has('password') ? ' has-error' : '' }}">
                    <!-- <label class="col-md-4 control-label">Password</label> -->

                    <div class="col-md-12">
                        <input type="password" placeholder="Password" class="form-control" name="password">

                        @if ($errors->has('password'))
                            <span class="help-block">
                                <strong>{{ $errors->first('password') }}</strong>
                            </span>
                        @endif
                    </div>
                </div>

                <div class="form-group{{ $errors->has('password_confirmation') ? ' has-error' : '' }}">
                    <!-- <label class="col-md-4 control-label">Confirm Password</label> -->
                    <div class="col-md-12">
                        <input type="password" placeholder="Confirm Password" class="form-control" name="password_confirmation">

                        @if ($errors->has('password_confirmation'))
                            <span class="help-block">
                                <strong>{{ $errors->first('password_confirmation') }}</strong>
                            </span>
                        @endif
                    </div>
                </div>

                <div class="form-group">
                    <div class="col-md-12">
                        <button type="submit" class="btn btn-primary">
                            <i class="fa fa-btn fa-refresh"></i>Reset Password
                        </button>
                    </div>
                </div>
            </form>
          </div> 
            <!-- /login-bottom -->
        </div>
    </div>
  </div><!-- /row -->
</div><!-- /container -->
@endsection
