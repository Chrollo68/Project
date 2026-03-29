<?php
header('Content-Type: application/json');
include 'db_config.php';

$data = [];
$result = $conn->query("SELECT * FROM material_stock_status");
while ($row = $result->fetch_assoc()) {
  $data[] = $row;
}

echo json_encode([
  'status' => 'success',
  'data' => $data
]);
?>

