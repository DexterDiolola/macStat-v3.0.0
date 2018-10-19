<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Support\Facades\Auth;

class RedirectIfAuthenticated
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @param  string|null  $guard
     * @return mixed
     */
    public function handle($request, Closure $next, $guard = null)
    {
        //if (Auth::guard($guard)->check()) {
          //  return redirect('/user/reports');
        //}

        switch ($guard) {
            case 'admin':
                if(Auth::guard($guard)->check()){
                    return redirect()->route('admin.dashboard');  //Same for using return redirect('my_url');
                }
                break;
            case 'partner':
                if(Auth::guard($guard)->check()){
                    return redirect()->route('partner.dashboard');
                }
                break;
            default:
                if(Auth::guard($guard)->check()){
                    return redirect()->route('operator.dashboard');
                }
                break;
        }

        return $next($request);
    }
}
