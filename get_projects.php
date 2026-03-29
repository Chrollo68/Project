<?php
header('Content-Type: application/json');
include 'db_config.php';

$sql = "SELECT * FROM projects ORDER BY created_at DESC";
$result = $conn->query($sql);

$data = [];
while ($row = $result->fetch_assoc()) {
  $data[] = $row;
}

echo json_encode([
  'status' => 'success',
  'data' => $data
]);
?>
