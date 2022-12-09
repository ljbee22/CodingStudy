<?php
include '../connection.php';

$userEmail = $_POST['user_email'];

$sqlQuery = "SELECT * FROM user_table WHERE user_email = '$userEmail'";

$resultQuery = $connection -> query($sqlQuery);

if($resultQuery -> num_rows > 0) {
  echo json_encode(array("existEmail" => true));
} else {
  echo json_encode(array("existEmail" => false));
}