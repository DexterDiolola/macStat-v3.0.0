<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;
use App\mac;
use App\mac_track_info;

class apiController extends Controller
{
    //ADD NEW STAT
    public function addStat(Request $request){
        $query = $request->all();
        $mac = $query['mac'];
        $active = $query['active'];
        $utiltx = $query['utiltx'];
        $utilrx = $query['utilrx'];
        $usagetx = $query['usagetx'];
        $usagerx = $query['usagerx'];
        
        $query['ccq'] == null || $query['ccq'] == '' ? $ccq = 0 : $ccq = $query['ccq'];

        $lease = $query['lease'];
        $uptime = $query['uptime'];
        $freeMem = $query['FreeMem'];
        $cpuFreq = $query['cpuFreq'];
        $cpuLoad = $query['cpuLoad'];
        $freeHDD = $query['freeHDD'];
        $badBlock = $query['badBlock'];

        
        $request->query->has('version') ? $version = $query['version'] : $version = 0;
        $request->query->has('appVersion') ? $appVersion = $query['appVersion'] : $appVersion = 0;
        $request->query->has('gps') ? $gps = $query['gps'] : $gps = 0;
        $request->query->has('dispense') ? $dispense = $query['dispense'] : $dispense = 0;
        $request->query->has('packages') ? $packages = $query['packages'] : $packages = 0;
        $request->query->has('vpnaddr') ? $vpnaddr = $query['vpnaddr'] : $vpnaddr = 0;
        $request->query->has('vendoVersion') ? $vendoVersion = $query['vendoVersion'] : $vendoVersion = 0;
        $request->query->has('wallet') ? $wallet = $query['wallet'] : $wallet = 0;


        $macs = mac::all('mac')->where('mac', '=', $mac);

       if(count($macs)>0){
            $addexist = DB::select("call ADD_MAC_ENTRY('$mac', 
                                   '$active', '$utiltx', '$utilrx', 
                                   '$usagetx', '$usagerx', '$ccq', '$lease',
                                   '$uptime', '$freeMem', '$cpuFreq',
                                   '$cpuLoad', '$freeHDD', '$badBlock', '$version',
                                   '$appVersion', '$gps', '$dispense', '$packages',
                                   '$vpnaddr', '$vendoVersion', '$wallet', 'existed')");
            
        }
        else{
            $addnotexist = DB::select("call ADD_MAC_ENTRY('$mac',
                                    '$active', '$utiltx', '$utilrx', 
                                    '$usagetx', '$usagerx', '$ccq', '$lease',
                                    '$uptime', '$freeMem', '$cpuFreq',
                                    '$cpuLoad', '$freeHDD', '$badBlock', '$version',
                                    '$appVersion', '$gps', '$dispense', '$packages',
                                    '$vpnaddr', '$vendoVersion', '$wallet', 'not_existing')");
            
        }

    }

    public function addViews(Request $request){
        $query = $request->all();
        $routerMac = $query['routerMac'];
        $userMac = $query['userMac'];
        $loginType = $query['logintype'];
        $loginValue = $query['loginvalue'];


        /* 
        This ternary condition was made in order to bypass the error data that has been input during REST API
        Because the data returned has a value of routerMac = $(identity) and $userMac = undefinedundefinedundefined. . .
        which is too long and greater than 255 characters
        To debug, just assign a new value to $userMac 
        
        If the length of $userMac variable is greater than 50 then no insertion will be happened
        */
        strlen($userMac) > 50 ? $userMac =  'DATA_TOO_LONG_ERROR' : true;

        $add = DB::select("call VIEWS('insert', '$routerMac', '$userMac', '$loginType', '$loginValue')");
    }

    public function getActiveMacs(Request $request){
        $query = $request->all();
        $trend = $query['trend'];
        $get = $query['get'];
        $created = $query['created'];

        $response = DB::select("call GET_ACTIVE_MACS('$trend', '$get', '$created')");
        return response()->json($response,200);
    }

    public function macsPerTrend(Request $request){
        $query = $request->all();
        $trend = $query['trend'];

        $response = DB::select("call MACS_PER_TREND('$trend')");
        return response()->json($response,200);
    }

    public function maxPerTrend(Request $request){
        $query = $request->all();
        $trend = $query['trend'];
        $get = $query['get'];
        $created = $query['created'];

        $response = DB::select("call MAX_PER_TREND('$trend', '$get', '$created')");
        return response()->json($response,200);
    }

    public function permacActivity(Request $request){
        $query = $request->all();
        $trend = $query['trend'];
        $mac = $query['mac'];

        $response = DB::select("call PERMAC_ACTIVITY('$trend', '$mac')");
        return response()->json($response,200);
    }

    public function searchMac($mac){
        $response = DB::select("call testsearchmac('$mac')");
        return response()->json($response,200);
    }

    public function addMacLabel(Request $request){
        $query = $request->all();
        $cond = $query['cond'];
        $mac = $query['mac'];
        $label = $query['label'];

        $response = DB::select("call ADD_MAC_LABEL('$cond', '$mac', '$label')");
        return response()->json($response,200);
    }
/*
    public function macAdministration(Request $request){
        $query = $request->all();
        $cond = $query['cond'];
        $owner = $query['owner'];
        $mac = $query['mac'];

        $response = DB::select("call MAC_ADMINISTRATION('$cond', '$owner', '$mac')");
        return response()->json($response,200);
    }
*/
    public function getViews(Request $request){
        $query = $request->all();
        $cond = $query['cond'];
        $routerMac = $query['routerMac'];
        $userMac = $query['userMac'];

        $response = DB::select("call VIEWS('$cond', '$routerMac', '$userMac', '', '')");
        return response()->json($response,200);
    }
 


    // NEWLY FUNCTONS
    public function macAdministration(Request $request){
        $query = $request->all();
        $cond = $query['cond'];
        $operator = $query['operator'];
        $partner = $query['partner'];
        $mac = $query['mac'];

        $response = DB::select("call mac_administration('$cond', '$operator', '$partner', '$mac')");
        return response()->json($response,200);
    }

    public function Dashboard(Request $request){
        $query = $request->all();
        $cond = $query['cond'];
        $trend = $query['trend'];
        $userParam = $query['userParam'];

        $response = DB::select("call Dashboard('$cond', '$trend', '$userParam')");
        return response()->json($response, 200);
    }

    public function Dashboard2(Request $request){
        $query = $request->all();
        $cond = $query['cond'];
        $trend = $query['trend'];
        $userParam = $query['userParam'];

        $response = DB::select("call Dashboard2('$cond', '$trend', '$userParam')");
        return response()->json($response, 200);
    }

    public function Wallet(Request $request){
        $query = $request->all();
        $cond = $query['cond'];
        $trend = $query['trend'];
        $userParam = $query['userParam'];

        $response = DB::select("call Wallet('$cond', '$trend', '$userParam')");
        return response()->json($response, 200);
    }

    public function Stats(Request $request){
        $query = $request->all();
        $cond = $query['cond'];
        $trend = $query['trend'];
        $userParam = $query['userParam'];
        $nth = $query['nth'];
        $arr = array();

        $response = DB::select("call Stats('$cond', '$trend', '$userParam', '$nth')");
        return response()->json($response, 200);
        
    }

    public function Devices(Request $request){
        $query = $request->all();
        $cond = $query['cond'];
        $trend = $query['trend'];
        $userParam = $query['userParam'];

        $response = DB::select("call Devices('$cond', '$trend', '$userParam')");
        return response()->json($response, 200);
    }

    public function MacStats(Request $request){
        $query = $request->all();
        $cond = $query['cond'];
        $trend = $query['trend'];
        $userParam = $query['userParam'];
        $macParam = $query['macParam'];

        $response = DB::select("call MacStats('$cond', '$trend', '$userParam', '$macParam')");
        return response()->json($response, 200);
    }


    public function TopUps(Request $request){
        $query = $request->all();
        $cond1 = $query['cond1'];
        $cond2 = $query['cond2'];
        $trend = $query['trend'];
        $userParam = $query['userParam'];

        // Get the macs active
        $macs = DB::select("call TopUps('$cond1', '', '$userParam', '')");
        // Initialize the topup results
        $topup = $this->initTopUps($macs, $cond2, $trend);

        return response()->json($topup, 200);   // For testing purpose
    }

    public function TopUpResults(Request $request){
        $query = $request->all();
        $cond = $query['cond'];

        $response = DB::select("call TopUps2('$cond', '', '', '', '', '', '')");
        return response()->json($response, 200);
    }

    public function initTopUps($macs, $cond, $trend){
        $arr = array();
        $arr2 = array();

        for($x=0; $x<count($macs); $x++){
            $macParam = $macs[$x]->mac;
            $getWallet = DB::select("call TopUps('$cond', '$trend', '', '$macParam')"); // Gets the wallet result of a device
            $result = $this->procTopUps($getWallet);

            array_push($arr, $result);
        }

        // Make the multidimensional array result into a single dimension array
        for($x=0; $x<count($arr); $x++){
            for($y=0; $y<count($arr[$x]); $y++){
                array_push($arr2, $arr[$x][$y]);
            }
        }


        // Trumcates the top_ups table to add new data
        $truncate = DB::select("call TopUps2('truncate', '', '', '', '', '', '')");
        // Inserts new data on top_ups table
        for($x=0; $x<count($arr2); $x++){
            $operator = $arr2[$x]->operator;
            $mac = $arr2[$x]->mac;
            $wallet = $arr2[$x]->wallet;
            $topup = $arr2[$x]->topup;
            $notif = $arr2[$x]->notif;
            $dateCreated = $arr2[$x]->dateCreated;

            $fill_top_ups = DB::select("call TopUps2('fill-topups-table', '$operator', 
                                       '$mac', '$wallet', '$topup', '$notif', '$dateCreated')");
        }


        return $arr2;
    }

    public function procTopUps($object){
        $arr = array();
        $len = count($object);
        
        for($x=0; $x<$len; $x++){
            $z = $x + 1;

            // initialize thee value of $z to the value of max index
            $z >= $len ? $z = $len - 1 : true;

            $operator = $object[$x]->operator; 
            $mac = $object[$x]->mac;
            $wallet = $object[$x]->wallet;
            $wallet < 0 ? $wallet = 0 : true;
            $dateCreated = $object[$x]->dateCreated;


            if($object[$x]->wallet > $object[$z]->wallet){
                $topup = $object[$x]->wallet - $object[$z]->wallet;
                $notif = $object[$x]->mac . ' of ' .$object[$x]->operator. ' has topped up of ' .round($topup, -3). ' balance.';
            }
            else{
                $topup = 0;
                $notif = '';
            }

            $obj = (object) [
                'operator' => $operator,
                'mac' => $mac,
                'wallet' => $wallet,
                'topup' => $topup,
                'notif' => $notif,
                'dateCreated' => $dateCreated
            ];
        
            array_push($arr, $obj);
        }

        return $arr;
    }

    public function sendSms(Request $request){
        $query = $request->all();
        $devic_mac = $query['devic_mac'];
        $mobile_mac = $query['mobile_mac'];
        $mobilenumber = $query['mobilenumber'];
        $message = $query['message'];

        $addSms = DB::select("call Sms('add-sms', '$devic_mac', '$mobile_mac', '$mobilenumber', '$message')");
    }
















/* ------------------------------------- PACKAGE/ DISPENSE FUNCTIONS ------------------------------------- */
    public function packageResults(Request $request){
        $query = $request->all();
        $trend = $query['trend'];
        $mac = $query['mac'];

        $this->checker();
        
        $package_results = DB::select("call package_results('$trend', '$mac')");
        return response()->json($package_results,200);
    }

    public function dispenseResults(Request $request){
        $query = $request->all();
        $x = $query['x'];
        $trend = $query['trend'];
        $owner = $query['owner'];

        //$this->checker();
        
        if($x == 'top'){
            $top_dispenses = DB::select("call package_top_dispenses('$trend', '$owner')");
            return response()->json($top_dispenses,200);
        }
        else if ($x == 'each') {
            // Uses the query parameter owner as 'mac'
            $dispense_each = DB::select("call package_dispense_results_each('$trend', '$owner')");
            return response()->json($dispense_each,200);
        }

        $dispense_results = DB::select("call package_dispense_results('$trend', '$owner')");
        return response()->json($dispense_results,200);
    }

    public function package_decoder($object){
        // Declare a container array
        $arr = array();
        
        // Loop through the object parameter
        for($x=0; $x<count($object); $x++){
            // Split every element to an array of strings
            $split = explode(',', $object[$x]['packages']);
            // If the length of resulting array is <17 then :
            if(count($split) < 17){
                $split = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
            }
            else if(count($split) == 17){
                array_splice($split, 8, 0, array('0', '0'));
            }

            // Declare new object and input every decoded element into it. 
            $decoded = (object) [
                'mac' => $object[$x]['mac'],
                'wallet' => $object[$x]['wallet'],
                'xxxMinutes' => $split[2],
                'iHour' => $split[4],
                'iiHours' => $split[6],
                'iiiHours' => $split[8],
                'vHours' => $split[10],
                'iDay' => $split[12],
                'iiDays' => $split[14],
                'ivDays' => $split[16],
                'iWeek' => $split[18],
                'dateCreated' => $object[$x]['dateCreated']
            ];

            // Insert it into the array.
            array_push($arr, $decoded);
        }
        
        return $arr;
    }

    public function compute_packages($object){

        // Declare an array container.
        $arr = array();
        // Specifies the length of object parameter.
        $len = count($object);

        // Loop through it.
        for($x=0; $x<$len; $x++){
            // The value of $z is decreasing as per loop.
            $z = $len-$x-2;
            // If $z reach to 0 below initialize it to $z=0.
            $z>0 ? true : $z = 0 ;


            $xxxMinutes = $object[$len-$x-1]->xxxMinutes - $object[$z]->xxxMinutes;
            $iHour = $object[$len-$x-1]->iHour - $object[$z]->iHour;
            $iiHours = $object[$len-$x-1]->iiHours - $object[$z]->iiHours;
            $iiiHours = $object[$len-$x-1]->iiiHours - $object[$z]->iiiHours;
            $vHours = $object[$len-$x-1]->vHours - $object[$z]->vHours;
            $iDay = $object[$len-$x-1]->iDay - $object[$z]->iDay;
            $iiDays = $object[$len-$x-1]->iiDays - $object[$z]->iiDays;
            $ivDays = $object[$len-$x-1]->ivDays - $object[$z]->ivDays;
            $iWeek = $object[$len-$x-1]->iWeek - $object[$z]->iWeek;
            $wallet = $object[$len-$x-1]->wallet;

            $xxxMinutes < 0 ? $xxxMinutes = 0 : true;
            $iHour < 0 ? $iHour = 0 : true;
            $iiHours < 0 ? $iiHours = 0 : true;
            $iiiHours < 0 ? $iiiHours = 0 : true;
            $vHours < 0 ? $vHours = 0 : true;
            $iDay < 0 ? $iDay = 0 : true;
            $iiDays < 0 ? $iiDays = 0 : true;
            $ivDays < 0 ? $ivDays = 0 : true;
            $iWeek < 0 ? $iWeek = 0 : true;
            $wallet < 0 ? $wallet = 0 : true;


            // Declare new object and input every subtraction results, mac, and dateCreated attribute into it.
            $obj = (object) [
                'mac' => $object[$x]->mac,
                'wallet' => $wallet,
                'xxxMinutes' => $xxxMinutes,
                'iHour' => $iHour,
                'iiHours' => $iiHours,
                'iiiHours' => $iiiHours,
                'vHours' => $vHours,
                'iDay' => $iDay,
                'iiDays' => $iiDays,
                'ivDays' => $ivDays,
                'iWeek' => $iWeek,
                'dateCreated' => $object[$len-$x-1]->dateCreated
            ];

            // Insert it into the array.
            array_push($arr, $obj);
        }
    
        return $arr;
    }

    public function packageAll(){
        // Get the active macs perMonth
        $get_macs_monthly = DB::select("call GET_ACTIVE_MACS('countActivePM', 'getMac', '')");
        $get_macs_monthly = json_decode(json_encode($get_macs_monthly),true);

        // Declare array contaainers
        $arr = array();
        $arr2 = array();

        // This for loop stores all the computed packages in multidimensional array form
        for($x=0; $x<count($get_macs_monthly); $x++){
            $mac_param = $get_macs_monthly[$x]['activeDevice'];
            $packages_to_decode = DB::select("call packages_to_decode('$mac_param')");
            $packages_to_decode = json_decode(json_encode($packages_to_decode),true);

            $decoded_packages = $this->package_decoder($packages_to_decode);
            $xx = $this->compute_packages($decoded_packages);

            array_push($arr, $xx);
        }

        /* To simplify, this for loop uses the values of multidimensional array $arr and
           insert it to a single array $arr2 */
        for($x=0; $x<count($arr); $x++){
            for($y=0; $y<count($arr[$x]); $y++){
                array_push($arr2, $arr[$x][$y]);
            }
        }

        return $arr2;
    }

    public function checker(){

        $check_for_length = DB::select("call package_results('check', '')");
        $check_for_length = json_decode(json_encode($check_for_length),true);

        if(count($check_for_length) <= 0){
            $truncate = DB::select("call package_results('truncate', '')");
            $object = $this->packageAll();

            for($x=0; $x<count($object); $x++){
                $mac_addr = $object[$x]->mac;
                $wallet = $object[$x]->wallet;
                $xxxMinutes = $object[$x]->xxxMinutes;
                $iHour = $object[$x]->iHour;
                $iiHours = $object[$x]->iiHours;
                $iiiHours = $object[$x]->iiiHours;
                $vHours = $object[$x]->vHours;
                $iDay = $object[$x]->iDay;
                $iiDays = $object[$x]->iiDays;
                $ivDays = $object[$x]->ivDays;
                $iWeek = $object[$x]->iWeek;
                $dateCreated = $object[$x]->dateCreated;

                $fill_computed_packages = DB::select("call fill_computed_packages('$mac_addr', '$wallet', '$xxxMinutes', '$iHour',
                                                     '$iiHours', '$iiiHours', '$vHours', '$iDay', '$iiDays', '$ivDays',
                                                     '$iWeek', '$dateCreated')");
            }
        }
    }

    









    public function alerts(Request $request){
        $query = $request->all();
        $cond = $query['cond'];

        if($cond=='getMax'){
            $response = DB::select("call ALERTS('getMax', '', '', '', '', '', '')");
            return response()->json($response,200);
        }
        else if($cond=='getAlert'){
            $response = DB::select("call ALERTS('getAlert', '', '', '', '', '', '')");
            return response()->json($response,200);
        }
        else
            return false;

    }

    public function sendAlerts(Request $request){
        $arr = $request->all();
        $len = count($arr);

        $response = DB::select("call ALERTS('truncate', '', '', '', '', '', '')");

        for($x=0; $x<$len; $x++){
            $mac = $arr[$x]['mac'];
            $label = $arr[$x]['label'];
            $owner = $arr[$x]['owner'];
            $alertMsg = $arr[$x]['alertMsg'];
            $alertType = $arr[$x]['alertType'];
            $dateCreated = $arr[$x]['dateCreated'];

            $response2 = DB::select("call ALERTS('sendAlert', '$mac', '$label', '$owner', '$alertType', '$alertMsg',
                                    '$dateCreated')");
        }
    }

    public function setAlertValues(Request $request){
        $arr = $request->all();
        $ccq = $arr[0]['ccq'];
        $cpuLoad = $arr[0]['cpuLoad'];
        $freeMem = $arr[0]['freeMem'];

        $response2 = DB::select("call SET_ALERT_VALUES('$ccq', '$cpuLoad', '$freeMem')");
        
    }





    ///////////////////////////////////////////////////////////////////////

    public function getActiveMacsUser(Request $request){
        $query = $request->all();
        $trend = $query['trend'];
        $get = $query['get'];
        $created = $query['created'];
        $owner = $query['owner'];

        $response = DB::select("call GET_ACTIVE_MACS_USER('$trend', '$get', '$created', '$owner')");
        return response()->json($response,200);
    }
    public function macsPerTrendUser(Request $request){
        $query = $request->all();
        $trend = $query['trend'];
        $owner = $query['owner'];

        $response = DB::select("call MACS_PER_TREND_USER('$trend', '$owner')");
        return response()->json($response,200);
    }
    public function maxPerTrendUser(Request $request){
        $query = $request->all();
        $trend = $query['trend'];
        $get = $query['get'];
        $created = $query['created'];
        $owner = $query['owner'];

        $response = DB::select("call MAX_PER_TREND_USER('$trend', '$get', '$created', '$owner')");
        return response()->json($response,200);
    }

    
}
