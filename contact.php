<?php

if(!empty($_POST['hidden_field'])) {
    // Detected a bot; exit or redirect
    exit;
}

$name = filter_var($_POST["name"], FILTER_SANITIZE_STRING);
$email = filter_var($_POST["email"], FILTER_SANITIZE_EMAIL);
$subject = filter_var($_POST["subject"], FILTER_SANITIZE_STRING);
$message = filter_var($_POST["message"], FILTER_SANITIZE_STRING);

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    // Invalid email address; handle error
    exit('Invalid email address.');
}

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
    $mail->isHTML(true);  // Set email format to HTML
    $mail->Subject = $subject;
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
                    <h2>New Contact Message</h2>
                </div>
                <div class='details'>
                    <h3>Message Details</h3>
                    <p><strong>Name:</strong> $name</p>
                    <p><strong>Email:</strong> $email</p>
                    <p><strong>Subject:</strong> $subject</p>
                    <p><strong>Message:</strong><br>$message</p>
                </div>
                <div class='footer'>
                    <p>This message was sent via the contact form on City Cross Taxi's website.</p>
                </div>
            </div>
        </body>
        </html>
    ";

    // Send the email
    $mail->send();
    echo "Message has been sent successfully";
} catch (Exception $e) {
    echo "Message could not be sent. Mailer Error: {$mail->ErrorInfo}";
}
?>
