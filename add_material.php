<?php
header('Content-Type: application/json');
include 'db_config.php';

$name = $_POST['name'] ?? '';
$total_stock = floatval($_POST['total_stock'] ?? 0);
$quantity = $_POST['quantity'] ?? 0;
$unit = $_POST['unit'] ?? '';
$price_per_unit = $_POST['price_per_unit'] ?? 0;
$total_cost = $_POST['total_cost'] ?? 0;
$project_id = $_POST['project_id'] ?? null;

if (empty($name)) {
  echo json_encode(['status' => 'error', 'message' => 'Name required']);
  exit;
}

$stmt = $conn->prepare("INSERT INTO materials (name, total_stock, quantity, unit, price_per_unit, total_cost, project_id, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, NOW())");
if (!$stmt) {
  echo json_encode(['status' => 'error', 'message' => $conn->error]);
  exit;
}
$bind_ok = $stmt->bind_param("sddsddi", $name, $total_stock, $quantity, $unit, $price_per_unit, $total_cost, $project_id);
if (!$bind_ok) {
  echo json_encode(['status' => 'error', 'message' => $stmt->error]);
  exit;
}

if ($stmt->execute()) {
  $material_id = $conn->insert_id;
  echo json_encode(['status' => 'success', 'message' => 'Material added', 'material_id' => $material_id]);
} else {
  echo json_encode(['status' => 'error', 'message' => $stmt->error]);
}
?>

