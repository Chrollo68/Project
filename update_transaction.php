<?php
include "db_config.php";

$data = json_decode(file_get_contents("php://input"), true);

$id = $data['id'];
$type = $data['type'];
$category = $data['category'];
$amount = $data['amount'];
$payment_method = $data['payment_method'];
$description = $data['description'];
$project_id = isset($data['project_id']) && $data['project_id'] !== null ? $data['project_id'] : null;

// Validate required fields
if (!$id || !$type || !$category || !$amount) {
    echo json_encode([
        "status" => "error",
        "message" => "Missing required fields"
    ]);
    exit;
}

$sql = "UPDATE transactions 
SET type = ?, category = ?, amount = ?, payment_method = ?, description = ?, project_id = ?
WHERE id = ?";

$stmt = $conn->prepare($sql);

if (!$stmt) {
    echo json_encode([
        "status" => "error",
        "message" => "Prepare failed: " . $conn->error
    ]);
    exit;
}

$stmt->bind_param("ssdssii", 
    $type,
    $category,
    $amount,
    $payment_method,
    $description,
    $project_id,
    $id
);

if ($stmt->execute()) {
    if ($stmt->affected_rows > 0) {
        echo json_encode([
            "status" => "success",
            "message" => "Transaction updated successfully"
        ]);
    } else {
        echo json_encode([
            "status" => "error",
            "message" => "Transaction not found"
        ]);
    }
} else {
    echo json_encode([
        "status" => "error",
        "message" => "Failed to update transaction: " . $stmt->error
    ]);
}

$stmt->close();
?>
