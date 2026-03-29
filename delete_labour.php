<?php
include "db_config.php";

$id = $_POST['id'] ?? 0;

if ($id <= 0) {
    echo json_encode(["status" => "error", "message" => "Invalid ID"]);
    exit;
}

$stmt = $conn->prepare("UPDATE labour SET status='deleted' WHERE id=?");
$stmt->bind_param("i", $id);

if ($stmt->execute()) {
    echo json_encode(["status" => "success", "message" => "Labour marked as deleted"]);
} else {
    echo json_encode(["status" => "error", "message" => "Failed to delete"]);
}
?>
