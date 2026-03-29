<?php
header('Content-Type: application/json');
include 'db_config.php';

$id = $_POST['id'] ?? 0;

if (empty($id)) {
  echo json_encode(['status' => 'error', 'message' => 'ID required']);
  exit;
}

$stmt = $conn->prepare("DELETE FROM materials WHERE id = ?");
if (!$stmt) {
  echo json_encode(['status' => 'error', 'message' => $conn->error]);
  exit;
}
$bind_ok = $stmt->bind_param("i", $id);
if (!$bind_ok) {
  echo json_encode(['status' => 'error', 'message' => $stmt->error]);
  exit;
}

if ($stmt->execute()) {
  echo json_encode(['status' => 'success', 'message' => 'Material deleted']);
} else {
  echo json_encode(['status' => 'error', 'message' => 'Delete failed']);
}
?>

