<?php
if (isset($_FILES['image']['name']) && isset($_GET['carId'])){
$image = $_FILES['image']['name'];
$carId = $_GET['carId'];

$imagePath = "uploads/".$carId."/".$image;

move_uploaded_file($_FILES['image']['tmp_name'],$imagePath);

echo "Car Id : ".$carId;
echo "<br>uploads/".$carId."/".$folder."/";

}else{
echo "Error";
}

?>

