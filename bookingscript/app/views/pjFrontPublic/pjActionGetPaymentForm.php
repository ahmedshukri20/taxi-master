<?php
include_once dirname(__FILE__) . '/elements/header.php'; 

$front_messages = __('front_messages', true, false);
?>
<div class="pjTbs-body">
    <?php
    if (!empty($tpl['arr']['payment_method']))
    {
        if(isset($tpl['params']['plugin']) && !empty($tpl['params']['plugin']))
        {
            $payment_messages = __('payment_plugin_messages');
            ?>
            <p class="text-success text-center"><?php echo isset($payment_messages[$tpl['arr']['payment_method']]) ? $payment_messages[$tpl['arr']['payment_method']]: $front_messages[1];?></p>
            <?php
            if (pjObject::getPlugin($tpl['params']['plugin']) !== NULL)
            {
                $controller->requestAction(array('controller' => $tpl['params']['plugin'], 'action' => 'pjActionForm', 'params' => $tpl['params']));
            }
        }else{
            switch ($tpl['arr']['payment_method'])
            {
                case 'bank':
                case 'creditcard':
                case 'cash':
                default:
                    $system_msg = str_replace("[STAG]", "<a href='#' class='alert-link fdStartOver'>", $front_messages[4]);
                    $system_msg = str_replace("[ETAG]", "</a>", $system_msg);
                    ?>
                    <p class="text-success text-center"><?php echo $system_msg;?></p>
                    <?php
            }
        }
    }else{
        $system_msg = str_replace("[STAG]", "<a href='#' class='alert-link fdStartOver'>", $front_messages[4]);
        $system_msg = str_replace("[ETAG]", "</a>", $system_msg);
        ?>
        <p class="text-success text-center"><?php echo $system_msg;?></p>
        <?php
    }
    ?>
</div>