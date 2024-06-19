<?php

$name = $_POST["name"];
$email = $_POST["email"];
$subject = $_POST["subject"];
$phone = $_POST["phone"];
$date = $_POST["date"];
$time = $_POST["time"];
$paymentMethod = $_POST["paymentMethod"];
$direction = $_POST["direction"];
$passengers = $_POST["passengers"];
$txtLocation3 = $_POST["txtLocation3"];
$txtLocation4 = $_POST["txtLocation4"];



require "vendor/autoload.php";

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

$mail = new PHPMailer(true);

// $mail->SMTPDebug = SMTP::DEBUG_SERVER;

$mail->isSMTP();
$mail->SMTPAuth = true;

$mail->isSMTP();
$mail->SMTPAuth = true;
$mail->Host = "mailout.one.com";
$mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
$mail->Port = 587;
$mail->Username = "info@citycrosstaxi.nl";
$mail->Password = "Anfaal@07";

// Recipients
$mail->setFrom("info@citycrosstaxi.nl", "City Cross Taxi");
$mail->addAddress("info@citycrosstaxi.nl", "Taxi Booking");
$mail->addReplyTo($email, $name);

$mail->Subject = $subject;

$mail->Body = $subject . "n/" . $name . "n/" . $date . " " . $direction . " " . $passengers . " " . $paymentMethod . $txtLocation3 . $txtLocation4;

$mail->send();