<?php
header("Content-Type: application/json");

include "db_config.php";

if (!$conn) {
    echo json_encode([
        "status" => "error",
        "message" => "Database connection failed"
    ]);
    exit;
}

$required = [
    'project_name',
    'description',
    'location',
    'start_date',
    'end_date',
    'budget',
    'status'
];

foreach ($required as $field) {
    if (!isset($_POST[$field]) || $_POST[$field] == "") {
        echo json_encode([
            "status" => "error",
            "message" => "Missing field: $field"
        ]);
        exit;
    }
}

$sql = "INSERT INTO projects 
(project_name, description, location, start_date, end_date, budget, status)
VALUES (?, ?, ?, ?, ?, ?, ?)";

$stmt = $conn->prepare($sql);

if (!$stmt) {
    echo json_encode([
        "status" => "error",
        "message" => "Prepare failed: " . $conn->error
    ]);
    exit;
}

$stmt->bind_param(
    "sssssss",   // ← changed to all string (SAFE)
    $_POST['project_name'],
    $_POST['description'],
    $_POST['location'],
    $_POST['start_date'],
    $_POST['end_date'],
    $_POST['budget'],
    $_POST['status']
);

if ($stmt->execute()) {
    echo json_encode([
        "status" => "success",
        "message" => "Project added successfully"
    ]);
} else {
    echo json_encode([
        "status" => "error",
        "message" => $stmt->error
    ]);
}

$stmt->close();
$conn->close();
?>