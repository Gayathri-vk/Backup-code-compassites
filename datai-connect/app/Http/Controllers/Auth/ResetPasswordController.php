<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Foundation\Auth\ResetsPasswords;

class ResetPasswordController extends Controller
{
    /*
    |--------------------------------------------------------------------------
    | Password Reset Controller
    |--------------------------------------------------------------------------
    |
    | This controller is responsible for handling password reset requests
    | and uses a simple trait to include this behavior. You're free to
    | explore this trait and override any methods you wish to tweak.
    |
    */

    use ResetsPasswords;
    /*use Illuminate\Support\Str;*/
    protected $redirectTo = '/get-login';

    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('guest');
    }

    protected function resetPassword($user, $password) { 
        // $user->forceFill([ 'password' => bcrypt($password), 'remember_token' => \Str::random(60), ])->save(); 

        $user->forceFill([ 'password' => bcrypt($password), 'remember_token' => 'jxhjhasx', ])->save(); 
    }

   protected function sendResetResponse($response) { 
         return redirect($this->redirectPath())->with('reset_password_success', trans($response)); 
   }
}
