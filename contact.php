<?php

$name = $_POST["name"];
$email = $_POST["email"];
$subject = $_POST["subject"];
$message = $_POST["message"];

require "vendor/autoload.php";

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

$mail = new PHPMailer(true);

try {
    // Server settings
    //$mail->SMTPDebug = SMTP::DEBUG_SERVER;
    $mail->isSMTP();
    $mail->SMTPAuth = true;
    $mail->Host = "mailout.one.com";
    $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
    $mail->Port = 587;
    $mail->Username = "info@citycrosstaxi.nl";
    $mail->Password = "Anfaal@07";

    // Recipients
    $mail->setFrom("info@citycrosstaxi.nl", "City Cross Taxi");
    $mail->addAddress("info@citycrosstaxi.nl", "Contact Us");
    $mail->addReplyTo($email, $name);

    // Content
    $mail->Subject = $subject;
    $mail->Body = $subject . "\n" . $name . "\n" . $message . "\n" . $email;

    // Send the email
    $mail->send();
    echo "Message has been sent successfully";
} catch (Exception $e) {
    echo "Message could not be sent. Mailer Error: {$mail->ErrorInfo}";
}
