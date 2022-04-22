<?php
$con=mysqli_connect( $_ENV['MYSQL_ROOT_HOST'], $_ENV['MYSQL_ROOT_USERNAME'], $_ENV['MYSQL_ROOT_PASSWORD'],"ecommerce");
if (!$con) {
    die("Connection failed: " . mysqli_connect_error());
}
