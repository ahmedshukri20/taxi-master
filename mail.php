<?php

$name = $_POST["name"];
$email = $_POST["email"];
$subject = $_POST["subject"];
$message = $_POST["message"];
$phone = $_POST["phone"];
$date = $_POST["date"];
$time = $_POST["time"];
$paymentMethod = $_POST["paymentMethod"];
$direction = $_POST["direction"];
$time = $_POST["time"];

require "vendor/autoload.php";

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;

$mail = new PHPMailer(true);

// $mail->SMTPDebug = SMTP::DEBUG_SERVER;

$mail->isSMTP();
$mail->SMTPAuth = true;

$mail->Host = "sandbox.smtp.mailtrap.io";
$mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
$mail->Port = 587;

$mail->Username = "e4d73ba8039f5e";
$mail->Password = "ac646757f491f6";

$mail->setFrom($email, $name);
$mail->addAddress("ramzalee3@gmail.com", "Dave");

$mail->Subject = $subject;
$mail->Body = $subject;

$mail->send();

header("Location: index.html");