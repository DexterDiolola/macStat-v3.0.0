<?php

namespace App\Http\Controllers\User;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Foundation\Auth\AuthenticatesUsers;
use Auth;
use App\User;
use DB;

class PartnerLoginController extends Controller
{
    
    public function __construct()
    {
        $this->middleware('guest:partner')->except('logout');
    }

    public function showRegisterForm(){
        return view('users.partner-register');
    }

    public function register(Request $request){
        $this->validateRegister($request);
        $request['password'] = bcrypt($request->password);
        $request['userType'] = 'Partner';
        User::create($request->all());
        return redirect('/partner/login');
    }    

    public function showLoginForm(){
        return view('users.partner-login');
    }

    public function login(Request $request){
        $this->validateLogin($request);
        if(Auth::guard('partner')->attempt(['username' => $request->username, 
                                         'password' => $request->password])){
            Auth::guard('partner')->logout();
            $userName = $request->username;
            $userType = DB::select("call mac_administration('get-user-type', '$userName', '', '')");
            $userType = json_decode(json_encode($userType),true);

            if($userType[0]['userType'] == 'Partner'){
                Auth::guard('partner')->attempt(['username' => $request->username,
                                                 'password' => $request->password]);
            }
            
            return redirect('partner/login')->withErrors(['Login Failed User Unknown']); 

        }

        return redirect('partner/login')->withErrors(['Login Failed']); 

    }

    public function logout(){
        Auth::guard('partner')->logout();
        return redirect('/partner/dashboard');  /*To prevent the use of back button, 
                                         redirect it to your dashboard page when it is 
                                         logged out*/
    }





    public function validateRegister($request){
        return $this->validate($request, [
            'username' => 'required|max:255',
            'email' => 'required|max:255',
            'password' => 'required|confirmed|max:255',
        ]);
    }
    public function validateLogin($request){
        return $this->validate($request, [
            'username' => 'required|max:255',
            'password' => 'required|max:255',
        ]);
    }
}
