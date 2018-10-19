<?php

namespace App\Http\Controllers\Admin;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Foundation\Auth\AuthenticatesUsers;
use Auth;

class AdminLoginController extends Controller
{
    public function __construct()
    {
        $this->middleware('guest:admin')->except('logout');
    }

    public function showLoginForm(){
    	return view('admin.admin-login');
    }

    public function login(Request $request){
    	$this->validateLogin($request);
        if(Auth::guard('admin')->attempt(['username' => $request->username, 
        								'password' => $request->password])){
        	return redirect('admin/dashboard');
        }
        return redirect('admin/login')->withErrors(['Login Failed']);
    }

    public function logout(){
        Auth::guard('admin')->logout();
        return redirect('/admin/dashboard');  /*To prevent the use of back button, 
                                         redirect it to your dashboard page when it is 
                                         logged out*/
    }








    public function validateLogin($request){
    	return $this->validate($request, [
    		'username' => 'required|max:255',
    		'password' => 'required|max:255',
		]);
    }
}
