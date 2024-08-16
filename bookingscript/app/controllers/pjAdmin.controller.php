<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjAdmin extends pjAppController
{
	public $defaultUser = 'admin_user';
	
	public $requireLogin = true;
		
	public function __construct($requireLogin=null)
	{
	    $this->setLayout('pjActionAdmin');
	    
	    if (!is_null($requireLogin) && is_bool($requireLogin))
	    {
	        $this->requireLogin = $requireLogin;
	    }
	    
	    if ($this->requireLogin)
	    {
	        $_get = pjRegistry::getInstance()->get('_get');
	        if (!$this->isLoged() && !in_array(@$_get->toString('action'), array('pjActionLogin', 'pjActionForgot', 'pjActionValidate', 'pjActionExportFeed')))
	        {
	            if (!$this->isXHR())
	            {
	                pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjBase&action=pjActionLogin");
	            } else {
	                header('HTTP/1.1 401 Unauthorized');
	                exit;
	            }
	        }
	    }
	    $ref_inherits_arr = array();
	    if ($this->isXHR() && isset($_SERVER['HTTP_REFERER'])) {
	        $http_refer_arr = parse_url($_SERVER['HTTP_REFERER']);
	        parse_str($http_refer_arr['query'], $arr);
	        if (isset($arr['controller']) && isset($arr['action'])) {
	            parse_str($_SERVER['QUERY_STRING'], $query_string_arr);
	            $key = $query_string_arr['controller'].'_'.$query_string_arr['action'];
	            $cnt = pjAuthPermissionModel::factory()->where('`key`', $key)->findCount()->getData();
	            if ($cnt <= 0) {
	                $ref_inherits_arr[$query_string_arr['controller'].'::'.$query_string_arr['action']] = $arr['controller'].'::'.$arr['action'];
	            }
	        }
	    }
	    $inherits_arr = array(
	        'pjBasePermissions::pjActionResetPermission' => 'pjBasePermissions::pjActionUserPermission',
	        
	        'pjAdminOptions::pjActionPaymentOptions' => 'pjAdminOptions::pjActionPayments',
	        'pjAdminOptions::pjActionNotificationsGetMetaData' => 'pjAdminOptions::pjActionNotifications',
	        'pjAdminOptions::pjActionNotificationsGetContent' => 'pjAdminOptions::pjActionNotifications',
	        'pjAdminOptions::pjActionNotificationsSetContent' => 'pjAdminOptions::pjActionNotifications',
	        
	        'pjAdminBookings::pjActionCheckEmail' => 'pjAdminBookings::pjActionCreate',
	        'pjAdminBookings::pjActionCheckEmail' => 'pjAdminBookings::pjActionUpdate',
	        'pjAdminBookings::pjActionGetExtras' => 'pjAdminBookings::pjActionCreate',
	        'pjAdminBookings::pjActionGetExtras' => 'pjAdminBookings::pjActionUpdate',
	        'pjAdminBookings::pjActionCalPrice' => 'pjAdminBookings::pjActionCreate',
	        'pjAdminBookings::pjActionCalPrice' => 'pjAdminBookings::pjActionUpdate',
	        'pjAdminBookings::pjActionGetBooking' => 'pjAdminBookings::pjActionIndex',
	        'pjAdminBookings::pjActionCancellation' => 'pjAdminBookings::pjActionUpdate',
	        'pjAdminBookings::pjActionConfirmation' => 'pjAdminBookings::pjActionUpdate',
	        'pjAdminBookings::pjActionSmsConfirmation' => 'pjAdminBookings::pjActionUpdate',
	        
	        'pjAdminClients::pjActionCheckEmail' => 'pjAdminClients::pjActionCreate',
	        'pjAdminClients::pjActionCheckEmail' => 'pjAdminClients::pjActionUpdate',
	        'pjAdminClients::pjActionGetClient' => 'pjAdminClients::pjActionIndex',
	        'pjAdminClients::pjActionSaveClient' => 'pjAdminClients::pjActionUpdate',
	        'pjAdminClients::pjActionStatusClient' => 'pjAdminClients::pjActionUpdate',
	        
	        'pjAdminExtras::pjActionGetExtra' => 'pjAdminExtras::pjActionIndex',
	        'pjAdminExtras::pjActionCreate' => 'pjAdminExtras::pjActionCreateForm',
	        'pjAdminExtras::pjActionUpdate' => 'pjAdminExtras::pjActionUpdateForm',
	        
	        'pjAdminFleets::pjActionGetFleet' => 'pjAdminFleets::pjActionIndex',
	        'pjAdminFleets::pjActionDeleteImage' => 'pjAdminFleets::pjActionUpdate',
	        'pjAdminFleets::pjActionCheckPrices' => 'pjAdminFleets::pjActionCreate',
	        'pjAdminFleets::pjActionCheckPrices' => 'pjAdminFleets::pjActionUpdate',
	    );
	    if ($_REQUEST['controller'] == 'pjAdminOptions' && isset($_REQUEST['next_action'])) {
	        $inherits_arr['pjAdminOptions::pjActionUpdate'] = 'pjAdminOptions::'.$_REQUEST['next_action'];
	    }
	    $inherits_arr = array_merge($ref_inherits_arr, $inherits_arr);
	    pjRegistry::getInstance()->set('inherits', $inherits_arr);
	}
	
	public function beforeFilter()
	{
	    parent::beforeFilter();
	    
	    if (!pjAuth::factory()->hasAccess())
	    {
	        if (!$this->isXHR())
	        {
	            $this->sendForbidden();
	            return false;
	        } else {
	            self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Access denied.'));
	        }
	    }
	    
	    return true;
	}
	
	public function afterFilter()
	{
	    parent::afterFilter();
	    $this->appendJs('index.php?controller=pjBase&action=pjActionMessages', PJ_INSTALL_URL, true);
	}
	
	public function beforeRender()
	{
		
	}
	
	public function setLocalesData()
	{
	    $locale_arr = pjLocaleModel::factory()
	    ->select('t1.*, t2.file')
	    ->join('pjBaseLocaleLanguage', 't2.iso=t1.language_iso', 'left')
	    ->where('t2.file IS NOT NULL')
	    ->orderBy('t1.sort ASC')->findAll()->getData();
	    
	    $lp_arr = array();
	    foreach ($locale_arr as $item)
	    {
	        $lp_arr[$item['id']."_"] = $item['file'];
	    }
	    $this->set('lp_arr', $locale_arr);
	    $this->set('locale_str', pjAppController::jsonEncode($lp_arr));
	    $this->set('is_flag_ready', $this->requestAction(array('controller' => 'pjBaseLocale', 'action' => 'pjActionIsFlagReady'), array('return')));
	}
	
	public function pjActionVerifyAPIKey()
	{
	    $this->setAjax(true);
	    
	    if ($this->isXHR())
	    {
	        if (!self::isPost())
	        {
	            self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'HTTP method is not allowed.'));
	        }
	        
	        $option_key = $this->_post->toString('key');
	        if (!array_key_exists($option_key, $this->option_arr))
	        {
	            self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Option cannot be found.'));
	        }
	        
	        $option_value = $this->_post->toString('value');
	        if(empty($option_value))
	        {
	            self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'API key is empty.'));
	        }
	        
	        $html = '';
	        $isValid = false;
	        switch ($option_key)
	        {
	            case 'o_google_maps_api_key':
	                $address = preg_replace('/\s+/', '+', $this->option_arr['o_timezone']);
	                $api_key_str = $option_value;
	                $gfile = "https://maps.googleapis.com/maps/api/geocode/json?key=".$api_key_str."&address=".$address;
	                $Http = new pjHttp();
	                $response = $Http->request($gfile)->getResponse();
	                $geoObj = pjAppController::jsonDecode($response);
	                $geoArr = (array) $geoObj;
	                if ($geoArr['status'] == 'OK')
	                {
	                    $html = '<img src="' . $url . '" class="img-responsive" />';
	                    $isValid = true;
	                }
	                break;
	            default:
	                // API key for an unknown service. We can't verify it so we assume it's correct.
	                $isValid = true;
	        }
	        
	        if ($isValid)
	        {
	            self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Key is correct!', 'html' => $html));
	        }
	        else
	        {
	            self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Key is not correct!', 'html' => $html));
	        }
	    }
	    exit;
	}
		
	public function pjActionIndex()
	{
	    $this->checkLogin();
	    if (!pjAuth::factory()->hasAccess())
	    {
	        $this->sendForbidden();
	        return;
	    }
	    
	    $pjBookingModel = pjBookingModel::factory();
	    
	    $enquiries_received_today = $pjBookingModel->where("(DATE_FORMAT(t1.created, '%Y-%m-%d')='".date('Y-m-d')."')")->findCount()->getData();
	    $reservations_today = $pjBookingModel->reset()->where("(DATE_FORMAT(t1.booking_date, '%Y-%m-%d')='".date('Y-m-d')."')")->where("t1.status <>", 'cancelled')->findCount()->getData();
	    $total_reservations = $pjBookingModel->reset()->findCount()->getData();
	    
	    $latest_enquiries = $pjBookingModel
	    ->reset()
	    ->select("t1.*, t2.content as fleet, t4.name, t4.email, t4.phone")
	    ->join('pjMultiLang', "t2.model='pjFleet' AND t2.foreign_id=t1.fleet_id AND t2.field='fleet' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
	    ->join('pjClient', "t3.id=t1.client_id", 'left outer')
	    ->join('pjAuthUser', "t4.id=t3.foreign_id", 'left outer')
	    ->orderBy("t1.created DESC")
	    ->limit(4)
	    ->findAll()->getData();
	    
	    $reservations_today_arr = $pjBookingModel
	    ->reset()
	    ->select("t1.*, t2.content as fleet, t4.name, t4.email, t4.phone")
	    ->join('pjMultiLang', "t2.model='pjFleet' AND t2.foreign_id=t1.fleet_id AND t2.field='fleet' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
	    ->join('pjClient', "t3.id=t1.client_id", 'left outer')
	    ->join('pjAuthUser', "t4.id=t3.foreign_id", 'left outer')
	    ->where("(DATE_FORMAT(t1.booking_date, '%Y-%m-%d')='".date('Y-m-d')."')")
	    ->where("t1.status <>", 'cancelled')
	    ->orderBy("t1.booking_date ASC")
	    ->limit(4)
	    ->findAll()->getData();
	    
	    $this->set('enquiries_received_today', $enquiries_received_today);
	    $this->set('reservations_today', $reservations_today);
	    $this->set('total_reservations', $total_reservations);
	    
	    $this->set('latest_enquiries', $latest_enquiries);
	    $this->set('reservations_today_arr', $reservations_today_arr);
	}
	
	public function rebuildPermissions()
	{
	    $this->setLayout('pjActionEmpty');
	    
	    $pjAuthRolePermissionModel = pjAuthRolePermissionModel::factory();
	    $pjAuthUserPermissionModel = pjAuthUserPermissionModel::factory();
	    
	    $permissions = pjAuthPermissionModel::factory()->findAll()->getDataPair('key', 'id');
	    
	    $roles = array(1 => 'admin', 2 => 'editor');
	    foreach ($roles as $role_id => $role)
	    {
	        if (isset($GLOBALS['CONFIG'], $GLOBALS['CONFIG']["role_permissions_{$role}"])
	        && is_array($GLOBALS['CONFIG']["role_permissions_{$role}"])
	        && !empty($GLOBALS['CONFIG']["role_permissions_{$role}"]))
	        {
	            $pjAuthRolePermissionModel->reset()->where('role_id', $role_id)->eraseAll();
	            
	            foreach ($GLOBALS['CONFIG']["role_permissions_{$role}"] as $role_permission)
	            {
	                if($role_permission == '*')
	                {
	                    // Grant full permissions for the role
	                    foreach($permissions as $key => $permission_id)
	                    {
	                        $pjAuthRolePermissionModel->setAttributes(compact('role_id', 'permission_id'))->insert();
	                    }
	                    break;
	                }
	                else
	                {
	                    $hasAsterix = strpos($role_permission, '*') !== false;
	                    if($hasAsterix)
	                    {
	                        $role_permission = str_replace('*', '', $role_permission);
	                    }
	                    
	                    foreach($permissions as $key => $permission_id)
	                    {
	                        if($role_permission == $key || ($hasAsterix && strpos($key, $role_permission) !== false))
	                        {
	                            $pjAuthRolePermissionModel->setAttributes(compact('role_id', 'permission_id'))->insert();
	                        }
	                    }
	                }
	            }
	        }
	    }
	    echo 'DONE!';
	    exit;
	}
}
?>