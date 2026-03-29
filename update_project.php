<?php
include "db_config.php";

header("Content-Type: application/json");

if (!$conn) {
    echo json_encode(["status" => "error", "message" => "DB connection failed"]);
    exit;
}

$id = isset($_POST['id']) ? intval($_POST['id']) : 0;
$project_name = $_POST['project_name'] ?? '';
$description = $_POST['description'] ?? '';
$location = $_POST['location'] ?? '';
$start_date = $_POST['start_date'] ?? null;
$end_date = $_POST['end_date'] ?? null;
$budget = isset($_POST['budget']) ? floatval($_POST['budget']) : 0;
$status = $_POST['status'] ?? 'ongoing';

if ($id <= 0) {
    echo json_encode(["status" => "error", "message" => "Invalid project id"]);
    exit;
}

$sql = "UPDATE projects SET
    project_name = ?,
    description = ?,
    location = ?,
    start_date = ?,
    end_date = ?,
    budget = ?,
    status = ?
    WHERE id = ?";

$stmt = $conn->prepare($sql);
if (!$stmt) {
    echo json_encode(["status" => "error", "message" => "Prepare failed: " . $conn->error]);
    exit;
}

// types: s s s s s d s i
$stmt->bind_param(
    "sssssdsi",
    $project_name,
    $description,
    $location,
    $start_date,
    $end_date,
    $budget,
    $status,
    $id
);

$ok = $stmt->execute();

echo json_encode([
    "status" => $ok ? "success" : "error",
    "message" => $ok ? "Project updated" : $stmt->error
]);

$stmt->close();
$conn->close();
