<?php

if(!empty($_POST['hidden_field'])) {
    // Detected a bot; exit or redirect
    exit;
}

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

// Create a well-formatted HTML body using Bootstrap
$mail->isHTML(true);  // Set email format to HTML
$mail->Body = "
    <html>
    <head>
        <link href='https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css' rel='stylesheet'>
        <style>
            .container {
                max-width: 600px;
                margin: 20px auto;
                background-color: #f7f7f7;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            }
            .header {
                background-color: #007bff;
                color: #fff;
                padding: 15px;
                border-radius: 10px 10px 0 0;
                text-align: center;
            }
            .details {
                padding: 20px;
                background-color: #fff;
                border-radius: 0 0 10px 10px;
            }
            .details h3 {
                color: #007bff;
                margin-bottom: 20px;
            }
            .details p {
                margin: 5px 0;
                font-size: 16px;
                color: #04376e;
            }
            .footer {
                text-align: center;
                padding: 10px;
                background-color: #f7f7f7;
                color: #666;
                font-size: 12px;
                border-top: 1px solid #ddd;
                margin-top: 20px;
            }
        </style>
    </head>
    <body>
        <div class='container'>
            <div class='header'>
                <h2>New Taxi Booking Request</h2>
            </div>
            <div class='details'>
                <h3>Booking Details</h3>
                <p><strong>Name:</strong> $name</p>
                <p><strong>Email:</strong> $email</p>
                <p><strong>Phone:</strong> $phone</p>
                <p><strong>Date:</strong> $date</p>
                <p><strong>Time:</strong> $time</p>
                <p><strong>Direction:</strong> $direction</p>
                <p><strong>Passengers:</strong> $passengers</p>
                <p><strong>Payment Method:</strong> $paymentMethod</p>
                <p><strong>Pickup Location:</strong> $txtLocation3</p>
                <p><strong>Drop-off Location:</strong> $txtLocation4</p>
            </div>
            <div class='footer'>
                <p>Thank you for choosing City Cross Taxi.</p>
            </div>
        </div>
    </body>
    </html>
";

$mail->send();
?>
