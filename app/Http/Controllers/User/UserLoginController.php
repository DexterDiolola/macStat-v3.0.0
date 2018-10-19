<?php

namespace App\Http\Controllers\User;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Foundation\Auth\AuthenticatesUsers;
use Auth;
use App\User;
use DB;

class UserLoginController extends Controller
{
    
    public function __construct()
    {
        $this->middleware('guest')->except('logout');
    }

    public function showRegisterForm(){
        return view('users.user-register');
    }

    public function register(Request $request){
        $this->validateRegister($request);
        $request['password'] = bcrypt($request->password);
        $request['userType'] = 'Operator';

        // The newly created user/operator must be inserted in partners table
        $operator = $request->username;
        DB::select("call mac_administration('add-new-operator', '$operator', '', '')");

        User::create($request->all());
        return redirect('/operator/login');
    }    

    public function showLoginForm(){
        return view('users.user-login');
    }

    public function login(Request $request){
        $this->validateLogin($request);
         if(Auth::attempt(['username'=>$request->username, 
                           'password'=>$request->password])){
            
            Auth::guard('web')->logout();
            $userName = $request->username;
            $userType = DB::select("call mac_administration('get-user-type', '$userName', '', '')");
            $userType = json_decode(json_encode($userType),true);

            if($userType[0]['userType'] == 'Operator'){
                Auth::attempt(['username' => $request->username,
                               'password' => $request->password]);
            }
            
            return redirect('operator/login')->withErrors(['Login Failed User Unknown']); 

         }
         return redirect('operator/login')->withErrors(['Login Failed']);
    }

    public function logout(){
        Auth::guard('web')->logout();
        return redirect('/operator/dashboard');  /*To prevent the use of back button, 
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
