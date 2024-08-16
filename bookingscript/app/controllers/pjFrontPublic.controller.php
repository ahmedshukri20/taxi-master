<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjFrontPublic extends pjFront
{
	public function __construct()
	{
		parent::__construct();
		
		$this->setAjax(true);
		
		$this->setLayout('pjActionEmpty');
	}
	public function pjActionSearch()
	{
		$this->setAjax(true);
	
		if ($this->isXHR() || $this->_get->check('_escaped_fragment_'))
		{
		    if($this->_post->check('tbs_search'))
			{
			    $date_time = pjDateTime::formatDate($this->_post->toString('booking_date'), $this->option_arr['o_date_format']) . ' ' . date("H:i:s", strtotime($this->_post->toString('booking_time')));
				$date_time_ts = strtotime($date_time);
				if(time() + $this->option_arr['o_hour_earlier'] * 3600 > $date_time_ts)
				{
					pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 120));
				}
					
				if($this->_is('search'))
				{
					$this->_unset('search');
				}
				$this->_set("search", $this->_post->raw());
				
				pjAppController::jsonResponse(array('status' => 'OK', 'code' => 200));
			}
		}
	}
	public function pjActionFleets()
	{
		if($this->isXHR())
		{
			if (isset($_SESSION[$this->defaultStore]) &&
					count($_SESSION[$this->defaultStore]) > 0 &&
					isset($_SESSION[$this->defaultStore]['search']))
			{
				$SEARCH = $this->_get('search');
				$passengers = !empty($SEARCH['passengers']) ? $SEARCH['passengers'] : 0;
				$luggage = !empty($SEARCH['luggage']) ? $SEARCH['luggage'] : 0;
				$distance = !empty($SEARCH['distance']) ? $SEARCH['distance'] : 0;
				
				$pjFleetModel = pjFleetModel::factory();
				$fleet_arr = $pjFleetModel
					->join('pjMultiLang', "t2.model='pjFleet' AND t2.foreign_id=t1.id AND t2.field='fleet' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
					->join('pjMultiLang', "t3.model='pjFleet' AND t3.foreign_id=t1.id AND t3.field='description' AND t3.locale='".$this->getLocaleId()."'", 'left outer')
					->select("t1.*, t2.content as fleet, t3.content as description, (SELECT `TP`.price FROM `".pjPriceModel::factory()->getTable()."` AS `TP` WHERE `TP`.fleet_id=t1.id AND (`TP`.`start` <= $distance AND $distance <= `TP`.`end`) LIMIT 1 ) AS price")
					->where('t1.status', 'T')
					->where('t1.passengers >=', $passengers)
					->where('t1.luggage >=', $luggage)
					->orderBy("price ASC")
					->findAll()->getData();
				
				$this->set('fleet_arr', $fleet_arr);
			}else{
				pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => ''));
			}				
		}
	}
	
	public function pjActionCheckout()
	{
		if($this->isXHR())
		{
			if (isset($_SESSION[$this->defaultStore]) &&
					count($_SESSION[$this->defaultStore]) > 0 &&
					isset($_SESSION[$this->defaultStore]['fleet_id']))
			{
				if($this->_post->check('lbs_checkout'))
				{
					$_SESSION[$this->defaultForm] = $this->_post->raw();
						
					pjAppController::jsonResponse(array('status' => 'OK', 'code' => 200));
				}else{
					$SEARCH = $this->_get('search');
					$passengers = !empty($SEARCH['passengers']) ? $SEARCH['passengers'] : 0;
					$luggage = !empty($SEARCH['luggage']) ? $SEARCH['luggage'] : 0;
					$distance = !empty($SEARCH['distance']) ? $SEARCH['distance'] : 0;
					
					$fleet_arr = pjFleetModel::factory()
						->join('pjMultiLang', "t2.model='pjFleet' AND t2.foreign_id=t1.id AND t2.field='fleet' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
						->join('pjMultiLang', "t3.model='pjFleet' AND t3.foreign_id=t1.id AND t3.field='description' AND t3.locale='".$this->getLocaleId()."'", 'left outer')
						->select("t1.*, t2.content as fleet, t3.content as description,  (SELECT ($distance * `TP`.price) FROM `".pjPriceModel::factory()->getTable()."` AS `TP` WHERE `TP`.fleet_id=t1.id AND (`TP`.`start` <= $distance AND $distance <= `TP`.`end`) LIMIT 1 ) AS price")
						->find($_SESSION[$this->defaultStore]['fleet_id'])->getData();
					$this->set('fleet_arr', $fleet_arr);
					
					$this->set('country_arr', pjBaseCountryModel::factory()
					    ->select('t1.*, t2.content AS country_title')
					    ->join('pjMultiLang', "t2.model='pjBaseCountry' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
					    ->where('t1.status', 'T')
					    ->orderBy('`country_title` ASC')
					    ->findAll()
					    ->getData()
					    );
					
					$pjFleetExtraModel = pjFleetExtraModel::factory()
						->join('pjMultiLang', "t2.model='pjExtra' AND t2.foreign_id=t1.extra_id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
						->join('pjExtra', "t1.extra_id=t3.id", 'left')
						->select("t1.*, t2.content as name, t3.price, t3.per")
						->where('t1.fleet_id', $_SESSION[$this->defaultStore]['fleet_id'])
						->orderBy("name ASC");
					$avail_extra_arr = $pjFleetExtraModel->findAll()->getData();
					$this->set('avail_extra_arr', $avail_extra_arr);
					
					$extra_id_arr = isset($_SESSION[$this->defaultForm]['extra_id']) && is_array($_SESSION[$this->defaultForm]['extra_id']) ? array_keys($_SESSION[$this->defaultForm]['extra_id']) : array();
					$price_arr = pjAppController::calPrice($_SESSION[$this->defaultStore]['fleet_id'], $distance, $passengers, $extra_id_arr, $this->option_arr);
					$this->set('price_arr', $price_arr);
					$this->set('passengers', $passengers);
					$this->set('extra_id_arr', $extra_id_arr);
					
					$bank_account = pjMultiLangModel::factory()
					->select('t1.content')
					->where('t1.model','pjOption')
					->where('t1.locale', $this->getLocaleId())
					->where('t1.field', 'o_bank_account')
					->limit(1)
					->findAll()->getDataIndex(0);
					$this->set('bank_account', $bank_account ? $bank_account['content'] : '');
					
					if(pjObject::getPlugin('pjPayments') !== NULL)
					{
					    $this->set('payment_option_arr', pjPaymentOptionModel::factory()->getOptions($this->getForeignId()));
					    $this->set('payment_titles', pjPayments::getPaymentTitles($this->getForeignId(), $this->getLocaleId()));
					}else{
					    $this->set('payment_titles', __('payment_methods', true));
					}
				}
			}else{
				pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => ''));
			}
		}
	}
	
	public function pjActionGetPrices()
	{
		if($this->isXHR())
		{
			if (isset($_SESSION[$this->defaultStore]) &&
					count($_SESSION[$this->defaultStore]) > 0 &&
					isset($_SESSION[$this->defaultStore]['fleet_id']))
			{
				$SEARCH = $this->_get('search');
				$passengers = !empty($SEARCH['passengers']) ? $SEARCH['passengers'] : 0;
				$luggage = !empty($SEARCH['luggage']) ? $SEARCH['luggage'] : 0;
				$distance = !empty($SEARCH['distance']) ? $SEARCH['distance'] : 0;
					
				$pjFleetExtraModel = pjFleetExtraModel::factory()
					->join('pjMultiLang', "t2.model='pjExtra' AND t2.foreign_id=t1.extra_id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
					->join('pjExtra', "t1.extra_id=t3.id", 'left')
					->select("t1.*, t2.content as name, t3.price, t3.per")
					->where('t1.fleet_id', $_SESSION[$this->defaultStore]['fleet_id'])
					->orderBy("name ASC");
				$avail_extra_arr = $pjFleetExtraModel->findAll()->getData();
				$this->set('avail_extra_arr', $avail_extra_arr);
	
				$extra_id_arr = $this->_post->check('extra_id') && is_array($this->_post->toArray('extra_id')) ? array_keys($this->_post->toArray('extra_id')) : array();
				
				$price_arr = pjAppController::calPrice($_SESSION[$this->defaultStore]['fleet_id'], $distance, $passengers, $extra_id_arr, $this->option_arr);
	
				$this->set('price_arr', $price_arr);
				$this->set('passengers', $passengers);
				$this->set('extra_id_arr', $extra_id_arr);
			}else{
				pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => ''));
			}
		}
	}
	
	public function pjActionPreview()
	{
		if($this->isXHR())
		{
			if (isset($_SESSION[$this->defaultStore]) &&
					count($_SESSION[$this->defaultStore]) > 0 &&
					isset($_SESSION[$this->defaultStore]['fleet_id']))
			{
				$SEARCH = $this->_get('search');
				$passengers = !empty($SEARCH['passengers']) ? $SEARCH['passengers'] : 0;
				$luggage = !empty($SEARCH['luggage']) ? $SEARCH['luggage'] : 0;
				$distance = !empty($SEARCH['distance']) ? $SEARCH['distance'] : 0;
				
				$fleet_arr = pjFleetModel::factory()
					->join('pjMultiLang', "t2.model='pjFleet' AND t2.foreign_id=t1.id AND t2.field='fleet' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
					->select("t1.*, t2.content as fleet, (SELECT ($distance * `TP`.price) FROM `".pjPriceModel::factory()->getTable()."` AS `TP` WHERE `TP`.fleet_id=t1.id AND (`TP`.`start` <= $distance AND $distance <= `TP`.`end`) LIMIT 1 ) AS price")
					->find($_SESSION[$this->defaultStore]['fleet_id'])->getData();
				$this->set('fleet_arr', $fleet_arr);
				
				$extra_id_arr = isset($_SESSION[$this->defaultForm]['extra_id']) && is_array($_SESSION[$this->defaultForm]['extra_id']) ? array_keys($_SESSION[$this->defaultForm]['extra_id']) : array();
				$price_arr = pjAppController::calPrice($_SESSION[$this->defaultStore]['fleet_id'], $distance, $passengers, $extra_id_arr, $this->option_arr);
					
				$this->set('price_arr', $price_arr);
				$this->set('passengers', $passengers);
				
				$this->set('country_arr', pjBaseCountryModel::factory()
				    ->select('t1.*, t2.content AS country_title')
				    ->join('pjMultiLang', "t2.model='pjBaseCountry' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
				    ->find($_SESSION[$this->defaultForm]['c_country'])
				    ->getData()
				    );
				
				$bank_account = pjMultiLangModel::factory()
				->select('t1.content')
				->where('t1.model','pjOption')
				->where('t1.locale', $this->getLocaleId())
				->where('t1.field', 'o_bank_account')
				->limit(1)
				->findAll()->getDataIndex(0);
				$this->set('bank_account', $bank_account ? $bank_account['content'] : '');
				
				if(pjObject::getPlugin('pjPayments') !== NULL)
				{
				    $this->set('payment_option_arr', pjPaymentOptionModel::factory()->getOptions($this->getForeignId()));
				    $this->set('payment_titles', pjPayments::getPaymentTitles($this->getForeignId(), $this->getLocaleId()));
				}else{
				    $this->set('payment_titles', __('payment_methods', true));
				}
			}else{
				pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => ''));
			}
		}
	}
	
	public function pjActionGetPaymentForm()
	{
	    if ($this->isXHR())
	    {
	        $arr = pjBookingModel::factory()->find($this->_get->toInt('booking_id'))->getData();
	        if(pjObject::getPlugin('pjPayments') !== NULL)
	        {
	            $pjPlugin = pjPayments::getPluginName($arr['payment_method']);
	            if(pjObject::getPlugin($pjPlugin) !== NULL)
	            {
	                $client = pjClientModel::factory()
	                ->select("t1.*, t2.email as c_email, t2.name as c_name, t2.phone as c_phone")
	                ->join('pjAuthUser', "t1.foreign_id=t2.id", 'left outer')
	                ->find($arr['client_id'])->getData();
	                
	                $this->set('params', $pjPlugin::getFormParams(array('payment_method' => $arr['payment_method']), array(
	                    'locale_id'	 => $this->getLocaleId(),
	                    'return_url'	=> $this->option_arr['o_thankyou_page'],
	                    'id'			=> $arr['id'],
	                    'foreign_id'	=> $this->getForeignId(),
	                    'uuid'		  => $arr['uuid'],
	                    'name'		  => @$client['c_name'],
	                    'email'		 => @$client['c_email'],
	                    'phone'		 => @$client['c_phone'],
	                    'amount'		=> $arr['deposit'],
	                    'cancel_hash'   => sha1($arr['uuid'].strtotime($arr['created']).PJ_SALT),
	                    'currency_code' => $this->option_arr['o_currency'],
	                )));
	            }
	            
	            if ($arr['payment_method'] == 'bank')
	            {
	                $bank_account = pjMultiLangModel::factory()
	                ->select('t1.content')
	                ->where('t1.model','pjOption')
	                ->where('t1.locale', $this->getLocaleId())
	                ->where('t1.field', 'o_bank_account')
	                ->limit(1)
	                ->findAll()->getDataIndex(0);
	                $this->set('bank_account', $bank_account ? $bank_account['content'] : '');
	            }
	        }
	        
	        $this->set('arr', $arr);
	        $this->set('get', $this->_get->raw());
	    }
	}
}
?>