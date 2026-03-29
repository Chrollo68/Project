<?php
header("Content-Type: application/json");
include "db_config.php";

if (!isset($_GET['project_id'])) {
    echo json_encode(["status"=>"error","message"=>"Missing project_id"]);
    exit;
}

$project_id = intval($_GET['project_id']);


// 1️⃣ Get Project Budget
$budgetQuery = $conn->prepare("SELECT budget FROM projects WHERE id = ?");
$budgetQuery->bind_param("i", $project_id);
$budgetQuery->execute();
$budgetResult = $budgetQuery->get_result();
$project = $budgetResult->fetch_assoc();
$budget = $project['budget'] ?? 0;


// 2️⃣ Get Expenses
$sql = "SELECT id, category, description, amount, transaction_date, payment_method
        FROM transactions
        WHERE project_id = ?
        AND type = 'expense'
        ORDER BY transaction_date DESC";

$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $project_id);
$stmt->execute();
$result = $stmt->get_result();

$expenses = [];
$totalExpense = 0;

while ($row = $result->fetch_assoc()) {
    $expenses[] = $row;
    $totalExpense += $row['amount'];
}


// 3️⃣ Calculate Profit
$profit = $budget - $totalExpense;


echo json_encode([
    "status" => "success",
    "budget" => $budget,
    "total_expense" => $totalExpense,
    "profit" => $profit,
    "data" => $expenses
]);

$stmt->close();
$conn->close();
?>