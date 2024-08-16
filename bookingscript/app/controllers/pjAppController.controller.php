<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjAppController extends pjBaseAppController
{
	public $models = array();
	
	public function pjActionCheckInstall()
	{
	    $this->setLayout('pjActionEmpty');
	    
	    $result = array('status' => 'OK', 'code' => 200, 'text' => 'Operation succeeded', 'info' => array());
	    $folders = array('app/web/upload');
	    foreach ($folders as $dir)
	    {
	        if (!is_writable($dir))
	        {
	            $result['status'] = 'ERR';
	            $result['code'] = 101;
	            $result['text'] = 'Permission requirement';
	            $result['info'][] = sprintf('Folder \'<span class="bold">%1$s</span>\' is not writable. You need to set write permissions (chmod 777) to directory located at \'<span class="bold">%1$s</span>\'', $dir);
	        }
	    }
	    
	    return $result;
	}
	
	public function beforeFilter()
	{
	    parent::beforeFilter();
	    
	    if(!in_array($this->_get->toString('controller'), array('pjFront')))
	    {
	        $this->appendJs('pjAdminCore.js');
	        // TODO: DELETE unnecessary files
	        #$this->appendCss('reset.css');
	        #$this->appendCss('pj-all.css', PJ_FRAMEWORK_LIBS_PATH . 'pj/css/');
	        $this->appendCss('admin.css');
	    }
	    
	    return true;
	}
	
	public function afterFilter()
	{
	    parent::afterFilter();
	    if(!in_array($this->_get->toString('controller'), array('pjFront', 'pjInstaller')))
	    {
	        $this->appendCss('admin.css');
	    }
	}
	
	/**
	 * Sets some predefined role permissions and grants full permissions to Admin.
	 */
	public function pjActionAfterInstall()
	{
	    $this->setLayout('pjActionEmpty');
	    
	    $result = array('status' => 'OK', 'code' => 200, 'text' => 'Operation succeeded', 'info' => array());
	    
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
	    if (isset($GLOBALS['CONFIG'], $GLOBALS['CONFIG']["listing_actions"])
	        && is_array($GLOBALS['CONFIG']["listing_actions"])
	        && !empty($GLOBALS['CONFIG']["listing_actions"]))
	    {
	        $pjAuthPermissionModel = pjAuthPermissionModel::factory();
	        foreach($GLOBALS['CONFIG']["listing_actions"] as $parent_key => $get_action)
	        {
	            $parent_arr = $pjAuthPermissionModel->reset()->where('`key`', $parent_key)->findAll()->getDataIndex(0);
	            if(!empty($parent_arr))
	            {
	                $data = array('parent_id' => ':NULL', 'key' => $get_action, 'inherit_id' => $parent_arr['id']);
	                $pjAuthPermissionModel->reset()->setAttributes($data)->insert();
	            }
	        }
	    }
	    pjAuthRoleModel::factory()->setAttributes(array('id' => 3, 'role' => 'Client', 'is_backend' => 'F', 'T'))->insert();
	    
	    // Grant full permissions to Admin
	    $user_id = 1; // Admin ID
	    $pjAuthUserPermissionModel->reset()->where('user_id', $user_id)->eraseAll();
	    foreach($permissions as $key => $permission_id)
	    {
	        $pjAuthUserPermissionModel->setAttributes(compact('user_id', 'permission_id'))->insert();
	    }
	    
	    return $result;
	}
	public function isClient()
	{
	    return $this->getRoleId() == 3;
	}
	public function getDirection()
	{
	    $dir = 'ltr';
	    if($this->getLocaleId() != false)
	    {
	        $locale_arr = pjLocaleModel::factory()->find($this->getLocaleId())->getData();
	        $dir = $locale_arr['dir'];
	    }
	    return $dir;
	}
	
	protected static function getAdminEmail()
	{
	    $arr = pjAuthUserModel::factory()->select('t1.email')->find(1)->getData();
	    
	    return $arr ? $arr['email'] : NULL;
	}
	protected static function getAdminPhone()
	{
	    $arr = pjAuthUserModel::factory()->select('t1.phone')->find(1)->getData();
	    
	    return $arr ? $arr['phone'] : NULL;
	}
	/*
	 * Returns the ID needed to fetch the Payment Options from pjPayments plugin.
	 *
	 * Scenario 1:
	 *  - The script uses just one set of options, so the method returns NULL to fetch script's default options.
	 *
	 * Scenario 2:
	 *  - The script uses multiple option sets, e.g. Vacation Rental Website.
	 *    Then the method should find the related Property ID as each property has different payment options.
	 */
	public function getPaymentOptionsForeignId($foreign_id)
	{
	    return null;
	}
	
	protected function isAmPm()
	{
	    return strpos($this->option_arr['o_time_format'], 'a') !== false || strpos($this->option_arr['o_time_format'], 'A') !== false;
	}
	
	protected function getAmPmTime()
	{
	    if (!$this->isAmPm())
	    {
	        return 0;
	    }
	    
	    if (strpos($this->option_arr['o_time_format'], 'a') !== false)
	    {
	        return 1;
	    }
	    
	    return 2;
	}
	
	protected function getAmPmFormat()
	{
	    if (strpos($this->option_arr['o_time_format'], 'a') !== false)
	    {
	        return 'a';
	    }
	    
	    return 'A';
	}
	
	public static function calPrice($fleet_id, $distance, $passengers, $extra_ids, $option_arr)
	{
	    $subtotal = 0;
	    $tax = 0;
	    $total = 0;
	    $deposit = 0;
	    $extra = 0;
	    $price_id = 0;
	    
	    if((int) $fleet_id > 0 && (int) $passengers > 0)
	    {
	        $fleet = pjFleetModel::factory()->find($fleet_id)->getData();
	        $price_arr = pjPriceModel::factory()->where('fleet_id', $fleet_id)->where("(t1.`start` <= $distance AND $distance <= t1.`end`)")->limit(1)->findAll()->getData();
	        $subtotal = $fleet['start_fee'] + $passengers * $fleet['fee_per_person'];
	        if(count($price_arr) == 1)
	        {
	            if(isset($price_arr[0]['price']) && (float) $price_arr[0]['price'] > 0)
	            {
	                $subtotal += $distance * (float) $price_arr[0]['price'];
	                $price_id = $price_arr[0]['id'];
	            }
	        }
	    }
	    if(!empty($extra_ids))
	    {
	        $avail_extra_arr = pjFleetExtraModel::factory()
	        ->join('pjExtra', "t1.extra_id=t2.id", 'left')
	        ->select("t1.*, t2.price, t2.per")
	        ->where('t1.fleet_id', $fleet_id)
	        ->findAll()->getData();
	        foreach($avail_extra_arr as $k => $v)
	        {
	            if(in_array($v['extra_id'], $extra_ids))
	            {
	                if($v['per'] == 'person')
	                {
	                    $subtotal += $v['price'] * $passengers;
	                    $extra += $v['price'] * $passengers;
	                }else{
	                    $subtotal += $v['price'];
	                    $extra += $v['price'];
	                }
	            }
	        }
	    }
	    
	    $tax = $subtotal * (float) $option_arr['o_tax_payment'] / 100;
	    $total = $subtotal + $tax;
	    $deposit = $total * (float) $option_arr['o_deposit_payment'] / 100;
	    
	    return compact('subtotal', 'tax', 'total', 'deposit', 'extra', 'price_id');
	}
	
	public function getTokens($option_arr, $booking_arr, $salt, $locale_id)
	{
	    $name_titles = __('personal_titles', true, false);
	    $country = NULL;
	    $title = !empty($booking_arr['c_title']) ? $name_titles[$booking_arr['c_title']] : NULL;
	    $first_name = pjSanitize::clean($booking_arr['c_fname']);
	    $last_name = pjSanitize::clean($booking_arr['c_lname']);
	    $phone = pjSanitize::clean($booking_arr['c_phone']);
	    $email = pjSanitize::clean($booking_arr['c_email']);
	    
	    $city = NULL;
	    $state = NULL;
	    $zip = NULL;
	    $address = NULL;
	    $company = NULL;
	    if((int) $booking_arr['client_id'] > 0)
	    {
	        $client = pjClientModel::factory()
	        ->select("t1.*, t2.content AS country_title")
	        ->join('pjMultiLang', "t2.model='pjBaseCountry' AND t2.foreign_id=t1.country_id AND t2.field='name' AND t2.locale='".$locale_id."'", 'left outer')
	        ->find($booking_arr['client_id'])
	        ->getData();
	        if (!empty($client))
	        {
	            $country = $client['country_title'];
	            $title = !empty($client['title']) ? $name_titles[$client['title']] : NULL;
	            if((int) $client['foreign_id'] > 0)
	            {
	                $user = pjAuthUserModel::factory()->find($client['foreign_id'])->getData();
	                if(!empty($user))
	                {
	                    $phone = pjSanitize::clean($user['phone']);
	                    $email = pjSanitize::clean($user['email']);
	                    $name_arr = pjUtil::splitName($user['name']);
	                    $first_name = $name_arr[0];
	                    $last_name = $name_arr[1];
	                }
	            }
	            $city = $client['city'];
	            $zip = $client['zip'];
	            $address = $client['address'];
	            $state = $client['state'];
	            $company = $client['company'];
	        }
	    }
	    
	    $sub_total = pjCurrency::formatPrice($booking_arr['sub_total']);
	    $tax = pjCurrency::formatPrice($booking_arr['tax']);
	    $total = pjCurrency::formatPrice($booking_arr['total']);
	    $deposit = pjCurrency::formatPrice($booking_arr['deposit']);
	    
	    $booking_date = NULL;
	    if (isset($booking_arr['booking_date']) && !empty($booking_arr['booking_date']))
	    {
	        $tm = strtotime(@$booking_arr['booking_date']);
	        $booking_date = date($option_arr['o_date_format'], $tm) . ', ' . date($option_arr['o_time_format'], $tm);
	    }
	    
	    $extras = NULL;
	    $extra_arr = array();
	    $avail_extra_arr = pjBookingExtraModel::factory()
	    ->join('pjMultiLang', "t2.model='pjExtra' AND t2.foreign_id=t1.extra_id AND t2.field='name' AND t2.locale='".$locale_id."'", 'left outer')
	    ->join('pjExtra', "t1.extra_id=t3.id", 'left')
	    ->select("t1.*, t2.content as name, t3.price, t3.per")
	    ->where('t1.booking_id', $booking_arr['id'])
	    ->orderBy("name ASC")
	    ->findAll()->getData();
	    
	    foreach($avail_extra_arr as $k => $v)
	    {
	        $extra_arr[] = pjSanitize::html($v['name']) . " (" . pjCurrency::formatPrice($v['price']) .  ($v['per'] == 'person' ? ' ' . __('lblPerPerson', true) : '') . ')';
	    }
	    
	    $extras = join("<br/>", $extra_arr);
	    
	    $flight_time = null;
	    if(!empty($booking_arr['c_flight_time']))
	    {
	        $flight_time = date($option_arr['o_time_format'], strtotime($booking_arr['c_flight_time']));
	    }
	    $distance = (int) $booking_arr['distance'] . ' km';
	    
	    $payment_methods = __('payment_methods', true, false);
	    if(pjObject::getPlugin('pjPayments') !== NULL)
	    {
	        $payment_methods = pjPayments::getPaymentTitles(1, $locale_id);
	    }
	    $payment_method = !empty($booking_arr['payment_method']) ? $payment_methods[$booking_arr['payment_method']]: NULL;
	    
	    $vehicle = NULL;
	    if((int) $booking_arr['fleet_id'] > 0)
	    {
	        $fleet = pjFleetModel::factory()
	        ->select("t1.*,t2.content AS name")
	        ->join('pjMultiLang', "t2.model='pjFleet' AND t2.foreign_id=t1.id AND t2.field='fleet' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
	        ->find( $booking_arr['fleet_id'])
	        ->getData();
	        if(!empty($fleet))
	        {
	            $vehicle = pjSanitize::html($fleet['name']);
	        }
	    }
	    
	    $cancelURL = PJ_INSTALL_URL . 'index.php?controller=pjFrontEnd&action=pjActionCancel&id='.@$booking_arr['id'].'&hash='.sha1(@$booking_arr['id'].@$booking_arr['created'].$salt);
	    $cancelURL = '<a href="'.$cancelURL.'">'.$cancelURL.'</a>';
	    $search = array(
	        '{Title}', '{FirstName}', '{LastName}', '{Email}', '{Password}', '{Phone}', '{Country}',
	        '{City}', '{State}', '{Zip}', '{Address}',
	        '{Airline}', '{FlightNumber}', '{ArrivalTime}', '{Terminal}',
	        '{Company}', '{CCType}', '{CCNum}', '{CCExp}','{CCSec}', '{PaymentMethod}',
	        '{UniqueID}', '{DateTime}', '{From}', '{To}', '{Vehicle}', '{Distance}', '{Passengers}', '{Luggage}', '{Extras}',
	        '{SubTotal}', '{Tax}', '{Total}', '{Deposit}', '{Notes}',
	        '{CancelURL}');
	    $replace = array(
	        $title, $first_name, $last_name, $email, @$booking_arr['password'], $phone, $country,
	        $city, $state, $zip, $address,
	        $booking_arr['c_airline_company'], $booking_arr['c_flight_number'], $flight_time, $booking_arr['c_terminal'],
	        $company, @$booking_arr['cc_type'], @$booking_arr['cc_num'], (@$booking_arr['payment_method'] == 'creditcard' ? @$booking_arr['cc_exp_month'] . '/' . substr(@$booking_arr['cc_exp_year'], -2) : NULL), @$booking_arr['cc_code'], $payment_method,
	        @$booking_arr['uuid'], $booking_date, @$booking_arr['pickup_address'], @$booking_arr['return_address'], $vehicle, $distance, @$booking_arr['passengers'], @$booking_arr['luggage'], $extras,
	        @$sub_total, @$tax, @$total, @$deposit, @$booking_arr['c_notes'],
	        $cancelURL);
	    
	    return compact('search', 'replace');
	}
	public function getClientTokens($option_arr, $client, $salt, $locale_id)
	{
	    $name_titles = __('personal_titles', true, false);
	    
	    $first_name = NULL;
	    $last_name = NULL;
	    $phone = NULL;
	    $email = NULL;
	    $password = NULL;
	    $title = NULL;
	    
	    $client_arr = pjClientModel::factory()
	    ->select("t1.*, t2.content AS country_title")
	    ->join('pjMultiLang', "t2.model='pjBaseCountry' AND t2.foreign_id=t1.country_id AND t2.field='name' AND t2.locale='".$locale_id."'", 'left outer')
	    ->find($client['id'])
	    ->getData();
	    if (!empty($client_arr))
	    {
	        $country = $client_arr['country_title'];
	        $title = !empty($client['title']) ? $name_titles[$client_arr['title']] : NULL;
	        if((int) $client_arr['foreign_id'] > 0)
	        {
	            $user = pjAuthUserModel::factory()->find($client_arr['foreign_id'])->getData();
	            if(!empty($user))
	            {
	                $phone = pjSanitize::clean($user['phone']);
	                $email = pjSanitize::clean($user['email']);
	                $password = pjSanitize::clean($user['password']);
	                $name_arr = pjUtil::splitName($user['name']);
	                $first_name = $name_arr[0];
	                $last_name = $name_arr[1];
	            }
	        }
	    }
	    
	    $search = array('{Title}', '{FirstName}', '{LastName}', '{Email}', '{Password}', '{Phone}');
	    $replace = array($title, $first_name, $last_name, $email, $password, $phone);
	    
	    return compact('search', 'replace');
	}
	
	public static function pjActionGetSubjectMessage($notification, $locale_id, $calendar_id)
	{
	    $field = $notification['variant'] . '_tokens_' . $notification['recipient'];
	    $field = str_replace('confirmation', 'confirm', $field);
	    $pjMultiLangModel = pjMultiLangModel::factory();
	    $lang_message = $pjMultiLangModel
	    ->reset()
	    ->select('t1.*')
	    ->where('t1.foreign_id', $calendar_id)
	    ->where('t1.model','pjOption')
	    ->where('t1.locale', $locale_id)
	    ->where('t1.field', $field)
	    ->limit(0, 1)
	    ->findAll()
	    ->getData();
	    $field = $notification['variant'] . '_subject_' . $notification['recipient'];
	    $field = str_replace('confirmation', 'confirm', $field);
	    $lang_subject = $pjMultiLangModel
	    ->reset()
	    ->select('t1.*')
	    ->where('t1.foreign_id',  $calendar_id)
	    ->where('t1.model','pjOption')
	    ->where('t1.locale', $locale_id)
	    ->where('t1.field', $field)
	    ->limit(0, 1)
	    ->findAll()
	    ->getData();
	    return compact('lang_message', 'lang_subject');
	}
	
	public static function pjActionGetSmsMessage($notification, $locale_id, $calendar_id)
	{
	    $field = $notification['variant'] . '_sms_' . $notification['recipient'];
	    $field = str_replace('confirmation', 'confirm', $field);
	    $pjMultiLangModel = pjMultiLangModel::factory();
	    $lang_message = $pjMultiLangModel
	    ->reset()
	    ->select('t1.*')
	    ->where('t1.foreign_id', $calendar_id)
	    ->where('t1.model','pjOption')
	    ->where('t1.locale', $locale_id)
	    ->where('t1.field', $field)
	    ->limit(0, 1)
	    ->findAll()
	    ->getData();
	    return compact('lang_message');
	}
	
	public function pjActionConfirmSend($option_arr, $booking_arr, $salt, $opt, $locale_id)
	{
	    $pjMultiLangModel = pjMultiLangModel::factory();
	    $pjNotificationModel = pjNotificationModel::factory();
	    
	    $Email = self::getMailer($option_arr);
	    
	    $locale_id = isset($booking_arr['locale_id']) && (int) $booking_arr['locale_id'] > 0 ? (int) $booking_arr['locale_id'] : $this->getLocaleId();
	    $booking_arr['calendar_id'] = $this->getForeignId();
	    
	    $tokens = pjAppController::getTokens($option_arr, $booking_arr, $salt, $locale_id);
	    
	    $admin_email = $this->getAdminEmail();
	    $admin_phone = $this->getAdminPhone();
	    
	    $client_email = NULL;
	    $client_phone = NULL;
	    if((int) $booking_arr['client_id'] > 0)
	    {
    	    $client = pjClientModel::factory()->find($booking_arr['client_id'])->getData();
    	    if (!empty($client))
    	    {
    	        if((int) $client['foreign_id'] > 0)
    	        {
    	            $user = pjAuthUserModel::factory()->find($client['foreign_id'])->getData();
    	            if(!empty($user['email']))
    	            {
    	                $client_email = $user['email'];
    	            }
    	            if(!empty($user['phone']))
    	            {
    	                $client_phone = $user['phone'];
    	            }
    	        }
    	    }
	    }
	    
	    /*SMS sent to Client*/
	    if($client_email != NULL)
	    {
	        $notification = $pjNotificationModel->reset()->where('recipient', 'client')->where('transport', 'email')->where('variant', $opt)->findAll()->getDataIndex(0);
	        if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
	        {
	            $resp = pjAppController::pjActionGetSubjectMessage($notification, $locale_id, $booking_arr['calendar_id']);
	            $lang_message = $resp['lang_message'];
	            $lang_subject = $resp['lang_subject'];
	            if (count($lang_message) === 1 && count($lang_subject) === 1 && !empty($lang_subject[0]['content']))
	            {
	                $subject = str_replace($tokens['search'], $tokens['replace'], $lang_subject[0]['content']);
	                $message = str_replace($tokens['search'], $tokens['replace'], $lang_message[0]['content']);
	                $Email
	                ->setTo($client_email)
	                ->setSubject(stripslashes($subject))
	                ->send(stripslashes($message));
	            }
	        }
	    }
	    
	    /*SMS sent to Admin*/
	    $notification = $pjNotificationModel->reset()->where('recipient', 'admin')->where('transport', 'email')->where('variant', $opt)->findAll()->getDataIndex(0);
	    if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
	    {
	        $resp = pjFront::pjActionGetSubjectMessage($notification, $locale_id, $booking_arr['calendar_id']);
	        $lang_message = $resp['lang_message'];
	        $lang_subject = $resp['lang_subject'];
	        if (count($lang_message) === 1 && count($lang_subject) === 1 && !empty($lang_subject[0]['content']))
	        {
	            $subject = str_replace($tokens['search'], $tokens['replace'], $lang_subject[0]['content']);
	            $message = str_replace($tokens['search'], $tokens['replace'], $lang_message[0]['content']);
	            
	            $Email
	            ->setTo($admin_email)
	            ->setSubject(stripslashes($subject))
	            ->send(stripslashes($message));
	        }
	    }
	    
	    /*SMS sent to client*/
	    if($client_phone != NULL)
	    {
	        $notification = $pjNotificationModel->reset()->where('recipient', 'client')->where('transport', 'sms')->where('variant', $opt)->findAll()->getDataIndex(0);
	        if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
	        {
	            $resp = pjFront::pjActionGetSmsMessage($notification, $locale_id, $booking_arr['calendar_id']);
	            $lang_message = $resp['lang_message'];
	            if (count($lang_message) === 1)
	            {
	                $message = str_replace($tokens['search'], $tokens['replace'], $lang_message[0]['content']);
	                $params = array(
	                    'text' => stripslashes($message),
	                    'type' => 'unicode',
	                    'key' => md5($option_arr['private_key'] . PJ_SALT)
	                );
	                $params['number'] = $client_phone;
	                pjBaseSms::init($params)->pjActionSend();
	            }
	        }
	    }
	    
	    /*SMS sent to admin*/
	    if(!empty($admin_phone))
	    {
	        $notification = $pjNotificationModel->reset()->where('recipient', 'admin')->where('transport', 'sms')->where('variant', $opt)->findAll()->getDataIndex(0);
	        if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
	        {
	            $resp = pjFront::pjActionGetSmsMessage($notification, $locale_id, $booking_arr['calendar_id']);
	            $lang_message = $resp['lang_message'];
	            if (count($lang_message) === 1)
	            {
	                $message = str_replace($tokens['search'], $tokens['replace'], $lang_message[0]['content']);
	                $params = array(
	                    'text' => stripslashes($message),
	                    'type' => 'unicode',
	                    'key' => md5($option_arr['private_key'] . PJ_SALT)
	                );
	                $params['number'] = $admin_phone;
	                pjBaseSms::init($params)->pjActionSend();
	            }
	        }
	    }
	}
	
	public function pjActionAccountSend($option_arr, $client_id, $salt, $opt, $locale_id)
	{
	    $Email = self::getMailer($option_arr);
	    
	    $pjNotificationModel = pjNotificationModel::factory();
	    
	    $notification = $pjNotificationModel->reset()->where('recipient', 'client')->where('transport', 'email')->where('variant', $opt)->findAll()->getDataIndex(0);
	    if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
	    {
	        $data = pjClientModel::factory()->find($client_id)->getData();
	        $tokens = pjAppController::getClientTokens($option_arr, $data, PJ_SALT, $locale_id);
	        $resp = pjFrontEnd::pjActionGetSubjectMessage($notification, $locale_id, $this->getForeignId());
	        $lang_message = $resp['lang_message'];
	        $lang_subject = $resp['lang_subject'];
	        $auth_client = pjAuthUserModel::factory()->find($data['foreign_id'])->getData();
	        if (count($lang_message) === 1 && count($lang_subject) === 1 && !empty($auth_client['email']))
	        {
	            $message = preg_replace('/\[Delivery\].*\[\/Delivery\]/s', '', $lang_message[0]['content']);
	            $message = str_replace($tokens['search'], $tokens['replace'], $message);
	            $Email
	            ->setTo($auth_client['email'])
	            ->setSubject($lang_subject[0]['content'])
	            ->send($message);
	        }
	    }
	}
}
?>