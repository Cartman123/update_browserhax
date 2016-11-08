<?php

if(file_exists("3dsbrowserhax_auto_qrcode.png"))
{
    die('QR code already generated');
}

$url  = isset($_SERVER['HTTPS']) ? 'https://' : 'http://';
//$url .= $_SERVER['SERVER_NAME']; // we want to use whatever the host header is
$url .= $_SERVER['HTTP_HOST'];
$url .= $_SERVER['REQUEST_URI'];

file_put_contents("3dsbrowserhax_auto_qrcode.png", fopen("https://chart.googleapis.com/chart?cht=qr&chs=150x150&chl=" . rawurlencode(dirname($url) . '/3dsbrowserhax_auto.php'), 'r'));
echo 'QR code generated';

?>
