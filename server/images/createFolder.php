<?php

if (isset($_POST['carId'])){
$carId = $_POST['carId'];

$link1 = "uploads/".$carId;


if (!file_exists($link1)) {
    mkdir($link1, 0777, true);
    echo "car created";
}

}else{
echo "Error";
}



?>