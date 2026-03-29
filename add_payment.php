<?php
include "db_config.php";

$sql = "INSERT INTO project_payments
(project_id, amount, payment_date, remarks)
VALUES (?, ?, ?, ?)";

$stmt = $conn->prepare($sql);
$stmt->bind_param(
    "idss",
    $_POST['project_id'],
    $_POST['amount'],
    $_POST['payment_date'],
    $_POST['remarks']
);

echo json_encode([
    "status" => $stmt->execute() ? "success" : "error"
]);
