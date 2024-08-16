<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjAdminBookings extends pjAdmin
{
    public function pjActionCheckEmail()
    {
        $this->setAjax(true);
        
        if ($this->isXHR())
        {
            if (!$this->_get->toString('c_email'))
            {
                echo 'false';
                exit;
            }
            
            $pjClientModel = pjAuthUserModel::factory()
            ->join("pjClient", 't2.foreign_id = t1.id', 'left outer')
            ->where('t1.role_id', 3)
            ->where('t1.email', $this->_get->toString('c_email'));
            
            echo $pjClientModel->findCount()->getData() == 0 ? 'true' : 'false';
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
        
        $this->set('date_format', pjUtil::toBootstrapDate($this->option_arr['o_date_format']));
        
        $this->appendCss('datepicker3.css', PJ_THIRD_PARTY_PATH . 'bootstrap_datepicker/');
        $this->appendJs('bootstrap-datepicker.js', PJ_THIRD_PARTY_PATH . 'bootstrap_datepicker/');
        $this->appendJs('jquery.datagrid.js', PJ_FRAMEWORK_LIBS_PATH . 'pj/js/');
        $this->appendJs('pjAdminBookings.js');
        
        $this->set('has_update', pjAuth::factory('pjAdminBookings', 'pjActionUpdate')->hasAccess());
        $this->set('has_create', pjAuth::factory('pjAdminBookings', 'pjActionCreate')->hasAccess());
        $this->set('has_delete', pjAuth::factory('pjAdminBookings', 'pjActionDeleteBooking')->hasAccess());
        $this->set('has_delete_bulk', pjAuth::factory('pjAdminBookings', 'pjActionDeleteBookingBulk')->hasAccess());
    }
    
    public function pjActionGetBooking()
    {
        $this->checkLogin();
        $this->setAjax(true);
        
        if ($this->isXHR())
        {
            $pjBookingModel = pjBookingModel::factory()
            ->join('pjMultiLang', "t2.model='pjFleet' AND t2.foreign_id=t1.fleet_id AND t2.field='fleet' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
            ->join('pjClient', "t3.id=t1.client_id", 'left outer')
            ->join('pjAuthUser', "t4.id=t3.foreign_id", 'left outer');
            
            if ($this->_get->has('q') && !$this->_get->isEmpty('q'))
            {
                $q = $this->_get->toString('q');
                $pjBookingModel->where("(t4.name LIKE '%$q%' OR t4.email LIKE '%$q%' OR t2.content LIKE '%$q%')");
            }
            
            if ($this->_get->toInt('fleet_id') > 0)
            {
                $fleet_id = $this->_get->toInt('fleet_id');
                $pjBookingModel->where("(t1.fleet_id='".$fleet_id."')");
            }
            if ($this->_get->toInt('client_id') > 0)
            {
                $client_id = $this->_get->toInt('client_id');
                $pjBookingModel->where("(t1.client_id='".$client_id."')");
            }
            if (!$this->_get->isEmpty('status') && in_array($this->_get->toString('status'), array('confirmed','cancelled','pending')))
            {
                $pjBookingModel->where('t1.status', $this->_get->toString('status'));
            }
            
            if (!$this->_get->isEmpty('name'))
            {
                $q = $this->_get->toString('name');
                $pjBookingModel->where("(t4.name LIKE '%$q%')");
            }
            if (!$this->_get->isEmpty('email'))
            {
                $q = $this->_get->toString('email');
                $pjBookingModel->where('t4.email LIKE', "%$q%");
            }
            if (!$this->_get->isEmpty('phone'))
            {
                $q = $this->_get->toString('phone');
                $pjBookingModel->where('t4.phone LIKE', "%$q%");
            }
            if (!$this->_get->isEmpty('date'))
            {
                $pjBookingModel->where("(DATE_FORMAT(t1.booking_date, '%Y-%m-%d')='".$this->_get->toString('date')."')");
            }
            $column = 'created';
            $direction = 'DESC';
            if ($this->_get->check('column') && in_array(strtoupper($this->_get->toString('direction')), array('ASC', 'DESC')))
            {
                $column = $this->_get->toString('column');
                $direction = strtoupper($this->_get->toString('direction'));
            }
            
            $total = $pjBookingModel->findCount()->getData();
            
            $rowCount = $this->_get->toInt('rowCount') ? $this->_get->toInt('rowCount') : 10;
            $pages = ceil($total / $rowCount);
            $page = $this->_get->toInt('page') ? $this->_get->toInt('page') : 1;
            $offset = ((int) $page - 1) * $rowCount;
            if ($page > $pages)
            {
                $page = $pages;
            }
            
            $data = array();
            
            $data = $pjBookingModel
            ->select("t1.*, t2.content as fleet, t4.name, t4.email,t4.phone, AES_DECRYPT(t1.cc_type, '".PJ_SALT."') AS `cc_type`,
								AES_DECRYPT(t1.cc_num, '".PJ_SALT."') AS `cc_num`,
								AES_DECRYPT(t1.cc_exp_month, '".PJ_SALT."') AS `cc_exp_month`,
								AES_DECRYPT(t1.cc_exp_year, '".PJ_SALT."') AS `cc_exp_year`,
								AES_DECRYPT(t1.cc_code, '".PJ_SALT."') AS `cc_code`")
			->orderBy("$column $direction")
			->limit($rowCount, $offset)
			->findAll()
			->getData();
			
			foreach($data as $k => $v)
			{
			    $v['client'] = pjSanitize::clean($v['name']);
			    $v['date_time']  = date($this->option_arr['o_date_format'] . ', ' . $this->option_arr['o_time_format'] , strtotime($v['booking_date']));
			    $v['distance'] = (int) $v['distance'] . ' km';
			    $data[$k] = $v;
			}
			
			self::jsonResponse(compact('data', 'total', 'pages', 'page', 'rowCount', 'column', 'direction'));
        }
        exit;
    }
    
    public function pjActionGetExtras()
    {
        $this->setAjax(true);
        
        if ($this->isXHR())
        {
            if($this->_post->toInt('fleet_id') >0)
            {
                $pjFleetExtraModel = pjFleetExtraModel::factory()
                ->join('pjMultiLang', "t2.model='pjExtra' AND t2.foreign_id=t1.extra_id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
                ->join('pjExtra', "t1.extra_id=t3.id", 'left')
                ->select("t1.*, t2.content as name, t3.price, t3.per")
                ->where('t1.fleet_id', $this->_post->toInt('fleet_id'))
                ->orderBy("name ASC");
                $avail_extra_arr = $pjFleetExtraModel->findAll()->getData();
                $this->set('avail_extra_arr', $avail_extra_arr);
            }
        }
    }
    public function pjActionCalPrice()
    {
        $this->setAjax(true);
        
        if ($this->isXHR())
        {
            $extra_ids = $this->_post->toArray('extra_id');
            $result = pjAppController::calPrice($this->_post->toInt('fleet_id'), $this->_post->toInt('distance'), $this->_post->toInt('passengers'), $extra_ids, $this->option_arr);
            pjAppController::jsonResponse($result);
            exit;
        }
    }
    
    public function pjActionCreate()
    {
        $this->checkLogin();
        if (!pjAuth::factory()->hasAccess())
        {
            $this->sendForbidden();
            return;
        }
        if (self::isPost() && $this->_post->check('booking_create'))
        {
            $pjBookingModel = pjBookingModel::factory();
            
            $_date = $this->_post->toString('booking_date');
            if(count(explode(" ", $_date)) == 3)
            {
                list($date, $time, $period) = explode(" ", $_date);
                $time = pjDateTime::formatTime($time . ' ' . $period, $this->option_arr['o_time_format']);
            }else{
                list($date, $time) = explode(" ", $_date);
                $time = pjDateTime::formatTime($time, $this->option_arr['o_time_format']);
            }
            
            $data = array();
            $data['uuid'] = pjUtil::uuid();
            $data['ip'] = pjUtil::getClientIp();
            $data['booking_date'] = pjDateTime::formatDate($date, $this->option_arr['o_date_format']) . ' ' . $time;
            $data['c_flight_time'] = $this->_post->check('c_flight_time') ? date("H:i:s", strtotime($this->_post->toString('c_flight_time'))) : ':NULL';
            
            if($this->_post->check('new_client'))
            {
                $c_data = array();
                $c_data['title'] = $this->_post->toString('c_title');
                $c_data['fname'] = $this->_post->toString('c_fname');
                $c_data['lname'] = $this->_post->toString('c_lname');
                $c_data['email'] = $this->_post->toString('c_email');
                $c_data['password'] = $this->_post->toString('c_password');
                $c_data['phone'] = $this->_post->toString('c_phone');
                $c_data['company'] = $this->_post->toString('c_company');
                $c_data['address'] = $this->_post->toString('c_address');
                $c_data['city'] = $this->_post->toString('c_city');
                $c_data['state'] = $this->_post->toString('c_state');
                $c_data['zip'] = $this->_post->toString('c_zip');
                $c_data['country_id'] = $this->_post->toInt('c_country');
                $c_data['status'] = 'T';
                $c_data['locale_id'] = $this->getLocaleId();
                $response = pjFrontClient::init($c_data)->createClient();
                if(isset($response['client_id']) && (int) $response['client_id'] > 0)
                {
                    $data['client_id'] = $response['client_id'];
                }
            }else{
                $data['client_id'] = $this->_post->toInt('client_id');
            }
            
            $id = pjBookingModel::factory(array_merge($this->_post->raw(), $data))->insert()->getInsertId();
            
            if ($id !== false && (int) $id > 0)
            {
                $pjBookingExtraModel = pjBookingExtraModel::factory();
                $extra_ids = $this->_post->toArray('extra_id');
                if (count($extra_ids) > 0)
                {
                    $pjBookingExtraModel->begin();
                    foreach ($extra_ids as $extra_id)
                    {
                        $pjBookingExtraModel
                        ->reset()
                        ->set('booking_id', $id)
                        ->set('extra_id', $extra_id)
                        ->insert();
                    }
                    $pjBookingExtraModel->commit();
                }
                $err = 'ABB03';
            }else{
                $err = 'ABB04';
            }
            pjUtil::redirect(PJ_INSTALL_URL. "index.php?controller=pjAdminBookings&action=pjActionIndex&err=$err");
        }
        if(self::isGet())
        {
            $country_arr = pjBaseCountryModel::factory()
            ->select('t1.id, t2.content AS name')
            ->join('pjMultiLang', "t2.model='pjBaseCountry' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
            ->where('t1.status', 'T')
            ->orderBy('`name` ASC')->findAll()->getData();
            $this->set('country_arr', $country_arr);
            
            $client_arr = pjClientModel::factory()
            ->select("t1.*, t2.email as c_email, t2.name as c_name, t2.phone as c_phone")
            ->join("pjAuthUser", "t2.id=t1.foreign_id", 'left outer')
            ->where('t2.status', 'T')
            ->orderBy('t2.name ASC')
            ->findAll()
            ->getData();
            $this->set('client_arr', pjSanitize::clean($client_arr));
            
            $fleet_arr = pjFleetModel::factory()
            ->join('pjMultiLang', "t2.model='pjFleet' AND t2.foreign_id=t1.id AND t2.field='fleet' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
            ->select("t1.*, t2.content as fleet")
            ->where('t1.status', 'T')
            ->orderBy("fleet ASC")
            ->findAll()->getData();
            $this->set('fleet_arr', $fleet_arr);
            
            if(pjObject::getPlugin('pjPayments') !== NULL)
            {
                $this->set('payment_option_arr', pjPaymentOptionModel::factory()->getOptions($this->getForeignId()));
                $this->set('payment_titles', pjPayments::getPaymentTitles($this->getForeignId(), $this->getLocaleId()));
            }else{
                $this->set('payment_titles', __('payment_methods', true));
            }
            
            $this->set('date_format', pjUtil::toBootstrapDate($this->option_arr['o_date_format']));
            
            $api_key = isset($this->option_arr['o_google_maps_api_key']) && !empty($this->option_arr['o_google_maps_api_key']) ? '&key=' . $this->option_arr['o_google_maps_api_key'] : '';
            $this->appendJs('https://maps.googleapis.com/maps/api/js?libraries=places' . $api_key, null, true);
            
            $this->appendCss('css/select2.min.css', PJ_THIRD_PARTY_PATH . 'select2/');
            $this->appendJs('js/select2.full.min.js', PJ_THIRD_PARTY_PATH . 'select2/');
            $this->appendJs('moment-with-locales.min.js', PJ_THIRD_PARTY_PATH . 'moment/');
            $this->appendCss('build/css/bootstrap-datetimepicker.min.css', PJ_THIRD_PARTY_PATH . 'bootstrap_datetimepicker/');
            $this->appendJs('build/js/bootstrap-datetimepicker.min.js', PJ_THIRD_PARTY_PATH . 'bootstrap_datetimepicker/');
            $this->appendJs('pjAdminBookings.js');
        }
    }
    
    public function pjActionUpdate()
    {
        $this->checkLogin();
        if (!pjAuth::factory()->hasAccess())
        {
            $this->sendForbidden();
            return;
        }
        
        if (self::isPost() && $this->_post->toInt('booking_update') && $this->_post->toInt('id'))
        {
            $pjBookingModel = pjBookingModel::factory();
            
            $data = array();
            $arr = $pjBookingModel->find($this->_post->toInt('id'))->getData();
            if (empty($arr))
            {
                pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminBookings&action=pjActionIndex&err=ABB08");
            }
            
            $_date = $this->_post->toString('booking_date');
            if(count(explode(" ", $_date)) == 3)
            {
                list($date, $time, $period) = explode(" ", $_date);
                $time = pjDateTime::formatTime($time . ' ' . $period, $this->option_arr['o_time_format']);
            }else{
                list($date, $time) = explode(" ", $_date);
                $time = pjDateTime::formatTime($time, $this->option_arr['o_time_format']);
            }
            
            $data['ip'] = pjUtil::getClientIp();
            $data['booking_date'] = pjDateTime::formatDate($date, $this->option_arr['o_date_format']) . ' ' . $time;
            $data['c_flight_time'] = $this->_post->check('c_flight_time') && !$this->_post->isEmpty('c_flight_time') ? date("H:i:s", strtotime($this->_post->toString('c_flight_time'))) : ':NULL';
            
            if($this->_post->check('new_client'))
            {
                $c_data = array();
                $c_data['title'] = $this->_post->toString('c_title');
                $c_data['fname'] = $this->_post->toString('c_fname');
                $c_data['lname'] = $this->_post->toString('c_lname');
                $c_data['email'] = $this->_post->toString('c_email');
                $c_data['password'] = $this->_post->toString('c_password');
                $c_data['phone'] = $this->_post->toString('c_phone');
                $c_data['company'] = $this->_post->toString('c_company');
                $c_data['address'] = $this->_post->toString('c_address');
                $c_data['city'] = $this->_post->toString('c_city');
                $c_data['state'] = $this->_post->toString('c_state');
                $c_data['zip'] = $this->_post->toString('c_zip');
                $c_data['country_id'] = $this->_post->toInt('c_country');
                $c_data['status'] = 'T';
                $c_data['locale_id'] = $this->getLocaleId();
                $response = pjFrontClient::init($c_data)->createClient();
                if(isset($response['client_id']) && (int) $response['client_id'] > 0)
                {
                    $data['client_id'] = $response['client_id'];
                }
            }else{
                $data['client_id'] = $this->_post->toInt('client_id');
            }
            
            $pjBookingModel->reset()->where('id', $this->_post->toInt('id'))->limit(1)->modifyAll(array_merge($this->_post->raw(), $data));
            
            $pjBookingExtraModel = pjBookingExtraModel::factory();
            $pjBookingExtraModel->where('booking_id', $this->_post->toInt('id'))->eraseAll();
            $extra_ids = $this->_post->toArray('extra_id');
            if (count($extra_ids) > 0)
            {
                $pjBookingExtraModel->begin();
                foreach ($extra_ids as $extra_id)
                {
                    $pjBookingExtraModel
                    ->reset()
                    ->set('booking_id', $this->_post->toInt('id'))
                    ->set('extra_id', $extra_id)
                    ->insert();
                }
                $pjBookingExtraModel->commit();
            }
            
            $err = 'ABB01';
            pjUtil::redirect(PJ_INSTALL_URL. "index.php?controller=pjAdminBookings&action=pjActionIndex&err=$err");
        }
        if (self::isGet() && $this->_get->toInt('id'))
        {
            $id = $this->_get->toInt('id');
            
            $arr = pjBookingModel::factory()->find($id)->getData();
            if(count($arr) <= 0)
            {
                pjUtil::redirect(PJ_INSTALL_URL. "index.php?controller=pjAdminBookings&action=pjActionIndex&err=ABB08");
            }
            
            $country_arr = pjBaseCountryModel::factory()
            ->select('t1.id, t2.content AS name')
            ->join('pjMultiLang', "t2.model='pjBaseCountry' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
            ->where('t1.status', 'T')
            ->orderBy('`name` ASC')->findAll()->getData();
            $this->set('country_arr', $country_arr);
            
            $client_arr = pjClientModel::factory()
            ->select("t1.*, t2.email as c_email, t2.name as c_name, t2.phone as c_phone")
            ->join("pjAuthUser", "t2.id=t1.foreign_id", 'left outer')
            ->where('t2.status', 'T')
            ->orderBy('t2.name ASC')
            ->findAll()
            ->getData();
            $this->set('client_arr', $client_arr);
            
            $fleet_arr = pjFleetModel::factory()
            ->join('pjMultiLang', "t2.model='pjFleet' AND t2.foreign_id=t1.id AND t2.field='fleet' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
            ->select("t1.*, t2.content as fleet")
            ->where('t1.status', 'T')
            ->orderBy("fleet ASC")
            ->findAll()->getData();
            $this->set('fleet_arr', $fleet_arr);
            
            $pjFleetExtraModel = pjFleetExtraModel::factory()
            ->join('pjMultiLang', "t2.model='pjExtra' AND t2.foreign_id=t1.extra_id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
            ->join('pjExtra', "t1.extra_id=t3.id", 'left')
            ->select("t1.*, t2.content as name, t3.price, t3.per")
            ->where('t1.fleet_id', $arr['fleet_id'])
            ->orderBy("name ASC");
            $avail_extra_arr = $pjFleetExtraModel->findAll()->getData();
            $this->set('avail_extra_arr', $avail_extra_arr);
            
            $extra_id_arr = pjBookingExtraModel::factory()->where('booking_id', $id)->findAll()->getDataPair(null, 'extra_id');
            $this->set('extra_id_arr', $extra_id_arr);
            
            if(pjObject::getPlugin('pjPayments') !== NULL)
            {
                $this->set('payment_option_arr', pjPaymentOptionModel::factory()->getOptions($this->getForeignId()));
                $this->set('payment_titles', pjPayments::getPaymentTitles($this->getForeignId(), $this->getLocaleId()));
            }else{
                $this->set('payment_titles', __('payment_methods', true));
            }
            
            $this->set('arr', $arr);
            
            $this->set('date_format', pjUtil::toBootstrapDate($this->option_arr['o_date_format']));
            
            $api_key = isset($this->option_arr['o_google_maps_api_key']) && !empty($this->option_arr['o_google_maps_api_key']) ? '&key=' . $this->option_arr['o_google_maps_api_key'] : '';
            $this->appendJs('https://maps.googleapis.com/maps/api/js?libraries=places' . $api_key, null, true);
            
            $this->appendJs('tinymce.min.js', PJ_THIRD_PARTY_PATH . 'tinymce/');
            $this->appendCss('css/select2.min.css', PJ_THIRD_PARTY_PATH . 'select2/');
            $this->appendJs('js/select2.full.min.js', PJ_THIRD_PARTY_PATH . 'select2/');
            $this->appendJs('moment-with-locales.min.js', PJ_THIRD_PARTY_PATH . 'moment/');
            $this->appendCss('build/css/bootstrap-datetimepicker.min.css', PJ_THIRD_PARTY_PATH . 'bootstrap_datetimepicker/');
            $this->appendJs('build/js/bootstrap-datetimepicker.min.js', PJ_THIRD_PARTY_PATH . 'bootstrap_datetimepicker/');
            $this->appendJs('pjAdminBookings.js');
        }
    }
    
    public function pjActionDeleteBooking()
    {
        $this->setAjax(true);
        
        if (!$this->isXHR())
        {
            self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
        }
        if (!self::isPost())
        {
            self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'HTTP method not allowed.'));
        }
        if (!pjAuth::factory()->hasAccess())
        {
            self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => 'Access denied.'));
        }
        if (!($this->_get->toInt('id')))
        {
            self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => 'Missing, empty or invalid parameters.'));
        }
        $pjBookingModel = pjBookingModel::factory();
        $arr = $pjBookingModel->find($this->_get->toInt('id'))->getData();
        if (!$arr)
        {
            self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => 'Fleet not found.'));
        }
        $id = $this->_get->toInt('id');
        if ($pjBookingModel->setAttributes(array('id' => $id))->erase()->getAffectedRows() == 1)
        {
            pjBookingExtraModel::factory()->where('booking_id', $id)->eraseAll();
            pjBookingPaymentModel::factory()->where('booking_id', $id)->eraseAll();
            self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Fleet has been deleted'));
        }else{
            self::jsonResponse(array('status' => 'ERR', 'code' => 105, 'text' => 'Fleet has not been deleted.'));
        }
        exit;
    }
    
    public function pjActionDeleteBookingBulk()
    {
        $this->setAjax(true);
        if (!$this->isXHR())
        {
            self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
        }
        if (!self::isPost())
        {
            self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'HTTP method not allowed.'));
        }
        if (!pjAuth::factory()->hasAccess())
        {
            self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => 'Access denied.'));
        }
        if (!$this->_post->has('record'))
        {
            self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => 'Missing, empty or invalid parameters.'));
        }
        $record = $this->_post->toArray('record');
        if (empty($record))
        {
            self::jsonResponse(array('status' => 'ERR', 'code' => 104, 'text' => 'Missing, empty or invalid parameters.'));
        }
        $pjBookingModel = pjBookingModel::factory();
        $pjBookingModel->reset()->whereIn('id', $record)->eraseAll();
        pjBookingExtraModel::factory()->whereIn('booking_id', $record)->eraseAll();
        pjBookingPaymentModel::factory()->whereIn('booking_id', $record)->eraseAll();
        self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Fleet(s) has been deleted.'));
        exit;
    }
    
    public function pjActionExportBooking()
    {
        $this->checkLogin();
        if (!pjAuth::factory()->hasAccess())
        {
            $this->sendForbidden();
            return;
        }
        
        $record = $this->_post->toArray('record');
        if (!empty($record))
        {
            $arr = pjBookingModel::factory()->whereIn('id', $record)->findAll()->getData();
            $csv = new pjCSV();
            $csv
            ->setHeader(true)
            ->setName("Bookings-".time().".csv")
            ->process($arr)
            ->download();
        }
        exit;
    }
    
    public function pjActionPrint()
    {
        $this->checkLogin();
        $this->setLayout('pjActionPrint');
        $transfer_arr = array();
        
        if (($this->_get->check('record') && !$this->_get->isEmpty('record')) || $this->_get->check('today') || $this->_get->check('id'))
        {
            $pjBookingModel = pjBookingModel::factory()
            ->select("t1.*, t2.content as fleet, t5.name, t5.email, t5.phone, t3.company, t3.address, t3.city, t3.state, t3.zip, t4.content as country")
            ->join('pjMultiLang', "t2.model='pjFleet' AND t2.foreign_id=t1.fleet_id AND t2.field='fleet' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
            ->join('pjClient', "t3.id=t1.client_id", 'left outer')
            ->join('pjMultiLang', "t4.model='pjBaseCountry' AND t4.foreign_id=t3.country_id AND t4.field='name' AND t4.locale='".$this->getLocaleId()."'", 'left outer')
            ->join('pjAuthUser', "t5.id=t3.foreign_id", 'left outer');
            
            if(!$this->_get->check('id'))
            {
                if ($this->_get->check('record') && !$this->_get->isEmpty('record'))
                {
                    $pjBookingModel->whereIn("t1.id", explode(",", $this->_get->toString('record')));
                }else{
                    $pjBookingModel->where("(DATE_FORMAT(t1.booking_date, '%Y-%m-%d')=DATE_FORMAT(NOW(), '%Y-%m-%d'))")	;
                    $pjBookingModel->where("t1.status <> 'cancelled'");
                }
            }else{
                $pjBookingModel->where("t1.id", $this->_get->toInt('id'));
                
                $extras = NULL;
                $extra_arr = array();
                $avail_extra_arr = pjBookingExtraModel::factory()
                ->join('pjMultiLang', "t2.model='pjExtra' AND t2.foreign_id=t1.extra_id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
                ->join('pjExtra', "t1.extra_id=t3.id", 'left')
                ->select("t1.*, t2.content as name, t3.price, t3.per")
                ->where('t1.booking_id', $this->_get->toInt('id'))
                ->orderBy("name ASC")
                ->findAll()->getData();
                
                foreach($avail_extra_arr as $k => $v)
                {
                    $extra_arr[] = pjSanitize::html($v['name']) . " (" . pjCurrency::formatPrice($v['price']) .  ($v['per'] == 'person' ? ' ' . __('lblPerPerson', true) : '') . ')';
                }
                
                $extras = join("<br/>", $extra_arr);
                $this->set('extras', $extras);
            }
            $transfer_arr = $pjBookingModel
            ->orderBy("t1.created DESC")
            ->findAll()
            ->getData();
        }
        
        if(pjObject::getPlugin('pjPayments') !== NULL)
        {
            $this->set('payment_option_arr', pjPaymentOptionModel::factory()->getOptions($this->getForeignId()));
            $this->set('payment_titles', pjPayments::getPaymentTitles($this->getForeignId(), $this->getLocaleId()));
        }else{
            $this->set('payment_titles', __('payment_methods', true));
        }
        
        $this->set('transfer_arr', $transfer_arr);
    }
    
    public function pjActionCancellation()
    {
        $this->setAjax(true);
        
        if ($this->isXHR())
        {
            if ($this->_post->check('send_cancellation') && $this->_post->toString('to') && $this->_post->toString('from') && $this->_post->toInt('locale_id'))
            {
                $pjEmail = self::getMailer($this->option_arr);
                
                $locale_id = $this->_post->toInt('locale_id');
                
                $subject = $this->_post->toString('subject');
                $message = $this->_post->toString('message');
                
                $r = $pjEmail
                ->setTo($this->_post->toString('to'))
                ->setSubject($subject)
                ->send($message);
                
                if ($r)
                {
                    self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Email has been sent.'));
                }
                self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Email failed to send.'));
            }
            
            if ($this->_get->toInt('booking_id'))
            {
                $booking_arr = pjBookingModel::factory()
                ->select("t1.*, t3.email AS c_email")
                ->join('pjClient', 't1.client_id=t2.id', 'left')
                ->join('pjAuthUser', 't3.id=t2.foreign_id', 'left')
                ->find($this->_get->toInt('booking_id'))->getData();
                
                $pjMultiLangModel = pjMultiLangModel::factory();
                $pjNotificationModel = pjNotificationModel::factory();
                
                $tokens = pjAppController::getTokens($this->option_arr, $booking_arr, PJ_SALT, $booking_arr['locale_id']);
                
                $notification = $pjNotificationModel->reset()->where('recipient', 'client')->where('transport', 'email')->where('variant', "cancel")->findAll()->getDataIndex(0);
                if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
                {
                    $resp = pjAppController::pjActionGetSubjectMessage($notification, $booking_arr['locale_id'], $this->getForeignId());
                    $lang_message = $resp['lang_message'];
                    $lang_subject = $resp['lang_subject'];
                    if (count($lang_message) === 1 && count($lang_subject) === 1 && !empty($lang_subject[0]['content']))
                    {
                        $subject = str_replace($tokens['search'], $tokens['replace'], $lang_subject[0]['content']);
                        $message = str_replace($tokens['search'], $tokens['replace'], $lang_message[0]['content']);
                        
                        $this->set('arr', array(
                            'locale_id' => $booking_arr['locale_id'],
                            'to' => $booking_arr['c_email'],
                            'from' => self::getAdminEmail(),
                            'subject' => $subject,
                            'message' => $message,
                        ));
                    }
                }
            } else {
                exit;
            }
        }
    }
    public function pjActionConfirmation()
    {
        $this->setAjax(true);
        
        if ($this->isXHR())
        {
            if ($this->_post->check('send_confirmation') && $this->_post->toString('to') && $this->_post->toString('from') && $this->_post->toInt('locale_id'))
            {
                $pjEmail = self::getMailer($this->option_arr);
                
                $locale_id = $this->_post->toInt('locale_id');
                
                $subject = $this->_post->toString('subject');
                $message = $this->_post->toString('message');
                
                $r = $pjEmail
                ->setTo($this->_post->toString('to'))
                ->setSubject($subject)
                ->send($message);
                
                if ($r)
                {
                    self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Email has been sent.'));
                }
                self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Email failed to send.'));
            }
            
            if ($this->_get->toInt('booking_id'))
            {
                $booking_arr = pjBookingModel::factory()
                ->select("t1.*, t3.email AS c_email")
                ->join('pjClient', 't1.client_id=t2.id', 'left')
                ->join('pjAuthUser', 't3.id=t2.foreign_id', 'left')
                ->find($this->_get->toInt('booking_id'))->getData();
                
                $pjMultiLangModel = pjMultiLangModel::factory();
                $pjNotificationModel = pjNotificationModel::factory();
                
                $tokens = pjAppController::getTokens($this->option_arr, $booking_arr, PJ_SALT, $booking_arr['locale_id']);
                
                $notification = $pjNotificationModel->reset()->where('recipient', 'client')->where('transport', 'email')->where('variant', "confirmation")->findAll()->getDataIndex(0);
                if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
                {
                    $resp = pjAppController::pjActionGetSubjectMessage($notification, $booking_arr['locale_id'], $this->getForeignId());
                    $lang_message = $resp['lang_message'];
                    $lang_subject = $resp['lang_subject'];
                    if (count($lang_message) === 1 && count($lang_subject) === 1 && !empty($lang_subject[0]['content']))
                    {
                        $subject = str_replace($tokens['search'], $tokens['replace'], $lang_subject[0]['content']);
                        $message = str_replace($tokens['search'], $tokens['replace'], $lang_message[0]['content']);
                        
                        $this->set('arr', array(
                            'locale_id' => $booking_arr['locale_id'],
                            'to' => $booking_arr['c_email'],
                            'from' => self::getAdminEmail(),
                            'subject' => $subject,
                            'message' => $message,
                        ));
                    }
                }
            } else {
                exit;
            }
        }
    }
    
    public function pjActionSmsConfirmation()
    {
        $this->setAjax(true);
        
        if ($this->isXHR())
        {
            if ($this->_post->check('send_sms_confirmation') && $this->_post->toString('phone') && $this->_post->toInt('locale_id'))
            {
                $message = $this->_post->toString('message');
                
                $params = array(
                    'text' => stripslashes($message),
                    'type' => 'unicode',
                    'key' => md5($this->option_arr['private_key'] . PJ_SALT)
                );
                $params['number'] = $this->_post->toString('phone');
                pjBaseSms::init($params)->pjActionSend();
                
                self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Email has been sent.'));
            }
            
            if ($this->_get->toInt('booking_id'))
            {
                $booking_arr = pjBookingModel::factory()
                ->select("t1.*, t3.phone AS c_phone")
                ->join('pjClient', 't1.client_id=t2.id', 'left')
                ->join('pjAuthUser', 't3.id=t2.foreign_id', 'left')
                ->find($this->_get->toInt('booking_id'))->getData();
                
                $pjMultiLangModel = pjMultiLangModel::factory();
                $pjNotificationModel = pjNotificationModel::factory();
                
                $tokens = pjAppController::getTokens($this->option_arr, $booking_arr, PJ_SALT, $booking_arr['locale_id']);
                
                $notification = $pjNotificationModel->reset()->where('recipient', 'client')->where('transport', 'sms')->where('variant', "confirmation")->findAll()->getDataIndex(0);
                if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
                {
                    $resp = pjFront::pjActionGetSmsMessage($notification, $booking_arr['locale_id'], $this->getForeignId());
                    $lang_message = $resp['lang_message'];
                    if (count($lang_message) === 1)
                    {                        
                        $message = str_replace($tokens['search'], $tokens['replace'], $lang_message[0]['content']);                        
                        $this->set('arr', array(
                            'locale_id' => $booking_arr['locale_id'],
                            'phone' => $booking_arr['c_phone'],
                            'message' => $message,
                        ));
                    }
                }
            } else {
                exit;
            }
        }
    }
}
?>