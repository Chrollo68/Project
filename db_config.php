<?php
header('Content-Type: application/json');
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "cividesk_db";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
  echo json_encode(['status' => 'error', 'message' => 'DB Connection failed: ' . $conn->connect_error]);
  exit;
}
?>

