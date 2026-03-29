<?php
include "db_config.php";

$id = $_GET['project_id'];

$project = $conn->query(
    "SELECT * FROM projects WHERE id = $id"
)->fetch_assoc();

$payments = [];
$res = $conn->query(
    "SELECT * FROM project_payments WHERE project_id = $id ORDER BY payment_date DESC"
);

$total = 0;
while ($p = $res->fetch_assoc()) {
    $total += $p['amount'];
    $payments[] = $p;
}

echo json_encode([
    "project" => $project,
    "payments" => $payments,
    "total_received" => $total,
    "balance" => $project['budget'] - $total
]);
