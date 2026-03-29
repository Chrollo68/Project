<?php
include "db_config.php";

header("Content-Type: application/json");

if (!$conn) {
	echo json_encode(["status" => "error", "message" => "DB connection failed"]);
	exit;
}

$id = isset($_POST['id']) ? intval($_POST['id']) : 0;
if ($id <= 0) {
	echo json_encode(["status" => "error", "message" => "Invalid id"]);
	exit;
}

// If projects table has is_deleted column, perform soft-delete, otherwise hard delete
$hasIsDeleted = false;
$check = mysqli_query($conn, "SHOW COLUMNS FROM projects LIKE 'is_deleted'");
if ($check && mysqli_num_rows($check) > 0) {
	$hasIsDeleted = true;
}

if ($hasIsDeleted) {
	$stmt = $conn->prepare("UPDATE projects SET is_deleted = 1, deleted_at = NOW() WHERE id = ?");
	$stmt->bind_param("i", $id);
	$ok = $stmt->execute();
	$stmt->close();
	echo json_encode(["status" => $ok ? "success" : "error", "message" => $ok ? "Project soft-deleted" : $conn->error]);
} else {
	$stmt = $conn->prepare("DELETE FROM projects WHERE id = ?");
	$stmt->bind_param("i", $id);
	$ok = $stmt->execute();
	$stmt->close();
	echo json_encode(["status" => $ok ? "success" : "error", "message" => $ok ? "Project deleted" : $conn->error]);
}

$conn->close();
