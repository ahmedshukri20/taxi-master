<?php

$name = $_POST["name"];
$email = $_POST["email"];
$subject = $_POST["subject"];
$message = $_POST["message"];

require "vendor/autoload.php";

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;

$mail = new PHPMailer(true);

// $mail->SMTPDebug = SMTP::DEBUG_SERVER;

$mail->isSMTP();
$mail->SMTPAuth = true;

$mail->Host = "send.one.com";
$mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
$mail->Port = 465;

$mail->Username = "info@citycrosstaxi.nl";
$mail->Password = "Anfaal@07";

$mail->setFrom($email, $name);
$mail->addAddress("info@citycrosstaxi.nl", "Dave");

$mail->Subject = $subject;

$mail->Body = $subject . "\n" . $name . "\n" . $message . "\n" . $email;

$mail->send();