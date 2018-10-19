<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::group(['prefix' => 'admin'], function(){
	/*Route::get('/register', 'Admin\LoginController@showRegisterForm');
	Route::post('/register', 'Admin\LoginController@register')->name('admin-register');*/
	Route::get('/login', 'Admin\AdminLoginController@showLoginForm')->name('admin.login');
	Route::post('/login', 'Admin\AdminLoginController@login')->name('admin.login.submit');
	Route::post('logout', 'Admin\AdminLoginController@logout')->name('admin.logout');

	Route::get('/dashboard', 'Admin\AdminController@reports')->name('admin.dashboard');
	Route::get('/reports/summaries', 'Admin\AdminController@reports');
	Route::get('/reports/charts', 'Admin\AdminController@reports');	
	Route::get('/reports/permac', 'Admin\AdminController@reports');
	Route::get('/reports/permac/macs{mac?}', 'Admin\AdminController@reports');
	Route::get('/reports/charts/macs{mac?}', 'Admin\AdminController@reports');


	Route::get('/administration/add-mac-label', 'Admin\AdminController@reports');
	Route::get('/administration/assign-mac', 'Admin\AdminController@reports');
	Route::get('/administration/maps', 'Admin\AdminController@reports');

});

Route::group(['prefix' => 'partner'], function(){
	Route::get('/register', 'User\PartnerLoginController@showRegisterForm');
	Route::post('/register', 'User\PartnerLoginController@register')->name('partner.register.submit');
	Route::get('/login', 'User\PartnerLoginController@showLoginForm')->name('partner.login');
	Route::post('/login', 'User\PartnerLoginController@login')->name('partner.login.submit');
	Route::post('/logout', 'User\PartnerLoginController@logout')->name('partner.logout');

	Route::get('/dashboard', 'User\PartnerController@reports')->name('partner.dashboard');
	Route::get('/wallet', 'User\PartnerController@reports');
	Route::get('/stats', 'User\PartnerController@reports');
	Route::get('/devices', 'User\PartnerController@reports');
	Route::get('/macStats', 'User\PartnerController@reports');
	Route::get('/topUps', 'User\PartnerController@reports');

});

Route::group(['prefix' => 'operator'], function(){
	Route::get('/register', 'User\UserLoginController@showRegisterForm');
	Route::post('/register', 'User\UserLoginController@register')->name('operator.register.submit');
	Route::get('/login', 'User\UserLoginController@showLoginForm')->name('operator.login');
	Route::post('/login', 'User\UserLoginController@login')->name('operator.login.submit');
	Route::post('/logout', 'User\UserLoginController@logout')->name('operator.logout');

	Route::get('/dashboard', 'User\UserController@reports')->name('operator.dashboard');
	Route::get('/wallet', 'User\UserController@reports');
	Route::get('/stats', 'User\UserController@reports');
	Route::get('/devices', 'User\UserController@reports');
	Route::get('/macStats', 'User\UserController@reports');
	Route::get('/topUps', 'User\UserController@reports');



	Route::get('/reports/summaries', 'User\UserController@reports');
	Route::get('/reports/charts', 'User\UserController@reports');
	Route::get('/reports/permac', 'User\UserController@reports');
	Route::get('/reports/permac/macs{mac?}', 'User\UserController@reports');
	Route::get('/reports/charts/macs{mac?}', 'User\UserController@reports');

});


//API ROUTES
Route::get('/addStat', 'apiController@addStat');
Route::get('/addStat2', 'apiController@addStat');
Route::get('/addViews', 'apiController@addViews');

Route::get('/sendsms', 'apiController@sendSms');
Route::group(['prefix' => 'api'], function(){
	Route::get('/get-active-macs', 'apiController@getActiveMacs');
	Route::get('/macs-per-trend', 'apiController@macsPerTrend');
	Route::get('/max-per-trend', 'apiController@maxPerTrend');
	Route::get('/permac-activity', 'apiController@permacActivity');
	Route::get('/search/{mac}', 'apiController@searchMac');
	Route::get('/add-mac-label', 'apiController@addMacLabel');

	// New API Routes
	Route::get('/dashboard', 'apiController@Dashboard');
	Route::get('/dashboard2', 'apiController@Dashboard2');
	Route::get('/wallet', 'apiController@Wallet');
	Route::get('/stats', 'apiController@Stats');
	Route::get('/devices', 'apiController@Devices');
	Route::get('/macStats', 'apiController@MacStats');
	Route::get('/topUps', 'apiController@TopUps');
	Route::get('/topUp/results', 'apiController@TopUpResults');

		
	// Mac Administration | Assign
	Route::get('/mac-administration', 'apiController@macAdministration');


	// Package & Dispense
	Route::get('/package-results-each', 'apiController@packageEach');
	Route::get('/package-all', 'apiController@packageAll');
	Route::get('/package-results-all', "apiController@packageResults");
	Route::get('/dispense-results', 'apiController@dispenseResults');

	
	Route::get('/alerts', 'apiController@alerts');
	Route::post('/send-alerts', 'apiController@sendAlerts');
	Route::post('/set-alert-values', 'apiController@setAlertValues');
	Route::get('/get-views', 'apiController@getViews');

	Route::get('/get-active-macs-user', 'apiController@getActiveMacsUser');
	Route::get('/macs-per-trend-user', 'apiController@macsPerTrendUser');
	Route::get('/max-per-trend-user', 'apiController@maxPerTrendUser');
});


Route::any('{path?}', function()
{
    return view("error");
})->where("path", ".+");
