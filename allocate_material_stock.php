<?php
header('Content-Type: application/json');
include 'db_config.php';

$material_id = $_POST['material_id'] ?? 0;
$project_id = $_POST['project_id'] ?? 0;
$qty = floatval($_POST['qty'] ?? 0);

if (!$material_id || !$project_id || $qty <= 0) {
  echo json_encode(['status' => 'error', 'message' => 'Invalid parameters']);
  exit;
}

$conn->autocommit(false);

try {
  // Lock & check remaining
  $stmt = $conn->prepare("SELECT remaining_stock FROM material_stock_status WHERE id = ? FOR UPDATE");
  $stmt->bind_param("i", $material_id);
  $stmt->execute();
  $result = $stmt->get_result();
  $row = $result->fetch_assoc();
  $remaining = $row['remaining_stock'] ?? 0;

  if ($qty > $remaining) {
    $conn->rollback();
    echo json_encode(['status' => 'error', 'message' => "Insufficient stock. Available: $remaining"]);
    exit;
  }

  // Upsert allocation
  $stmt = $conn->prepare("INSERT INTO material_allocations (material_id, project_id, allocated_qty) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE allocated_qty = allocated_qty + VALUES(allocated_qty)");
  $stmt->bind_param("iid", $material_id, $project_id, $qty);
  $stmt->execute();

  $conn->commit();
  echo json_encode(['status' => 'success', 'message' => 'Stock allocated to project']);
} catch (Exception $e) {
  $conn->rollback();
  echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
} finally {
  $conn->autocommit(true);
}
?>
</xai:function_call name="create_file"> 

<xai:function_call name="create_file">
<parameter name="absolute_path">cividesk_api/add_material.php
