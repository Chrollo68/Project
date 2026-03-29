<?php
header('Content-Type: application/json');
include 'db_config.php';

$id = $_POST['id'] ?? 0;
$name = $_POST['name'] ?? '';
$quantity = $_POST['quantity'] ?? 0;
$unit = $_POST['unit'] ?? '';
$price_per_unit = $_POST['price_per_unit'] ?? 0;
$total_cost = $_POST['total_cost'] ?? 0;
$project_id = $_POST['project_id'] ?? null;

if (empty($id) || empty($name)) {
  echo json_encode(['status' => 'error', 'message' => 'ID and name required']);
  exit;
}

$stmt = $conn->prepare("UPDATE materials SET name = ?, quantity = ?, unit = ?, price_per_unit = ?, total_cost = ?, project_id = ? WHERE id = ?");
if (!$stmt) {
  echo json_encode(['status' => 'error', 'message' => $conn->error]);
  exit;
}
$bind_ok = $stmt->bind_param("ssdiddi", $name, $quantity, $unit, $price_per_unit, $total_cost, $project_id, $id);
if (!$bind_ok) {
  echo json_encode(['status' => 'error', 'message' => $stmt->error]);
  exit;
}

if ($stmt->execute()) {
  echo json_encode(['status' => 'success', 'message' => 'Material updated', 'material_id' => $id]);
} else {
  echo json_encode(['status' => 'error', 'message' => 'Update failed']);
}
?>

