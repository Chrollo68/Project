<?php
header('Content-Type: application/json');
include 'db_config.php';

$project_id = $_GET['project_id'] ?? null;

$sql = "SELECT m.*, p.project_name as project_name FROM materials m 
LEFT JOIN projects p ON m.project_id = p.id ORDER BY m.created_at DESC";
if ($project_id) {
  $sql = "SELECT m.*, p.project_name as project_name FROM materials m 
LEFT JOIN projects p ON m.project_id = p.id WHERE m.project_id = ? ORDER BY m.created_at DESC";
  $stmt = $conn->prepare($sql);
  $stmt->bind_param("i", $project_id);
  $stmt->execute();
  $result = $stmt->get_result();
} else {
  $result = $conn->query($sql);
}

$data = [];
while ($row = $result->fetch_assoc()) {
  $data[] = $row;
}

echo json_encode([
  'status' => 'success',
  'data' => $data
]);
?>

