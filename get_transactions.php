<?php
include "db_config.php";

$sql = "SELECT 
    t.id,
    t.type,
    t.category,
    t.amount,
    t.payment_method,
    t.description,
    t.project_id,
    p.project_name,
    t.created_at
FROM transactions t
LEFT JOIN projects p ON t.project_id = p.id
ORDER BY t.created_at DESC";

$result = $conn->query($sql);

if (!$result) {
    echo json_encode([
        "success" => false,
        "message" => "Query failed: " . $conn->error
    ]);
    exit;
}

$transactions = [];

while ($row = $result->fetch_assoc()) {
    $transactions[] = $row;
}

echo json_encode([
    "success" => true,
    "data" => $transactions
]);
?>