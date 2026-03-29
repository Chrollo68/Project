<?php
include "db_config.php";

$data = json_decode(file_get_contents("php://input"), true);

$type = $data['type']; // income / expense
$category = $data['category'];
$amount = $data['amount'];
$payment_method = $data['payment_method'];
$description = $data['description'];
$project_id = isset($data['project_id']) && $data['project_id'] !== null ? $data['project_id'] : null;

$sql = "INSERT INTO transactions 
(type, category, amount, payment_method, description, project_id, created_at)
VALUES (?, ?, ?, ?, ?, ?, NOW())";

$stmt = $conn->prepare($sql);
$stmt->bind_param("ssdssi", 
    $type,
    $category,
    $amount,
    $payment_method,
    $description,
    $project_id
);

if ($stmt->execute()) {
    echo json_encode([
        "status" => "success",
        "message" => "Transaction added successfully",
        "id" => $stmt->insert_id
    ]);
} else {
    echo json_encode([
        "status" => "error",
        "message" => "Failed to add transaction: " . $stmt->error
    ]);
}
$stmt->close();
?>