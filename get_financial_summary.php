<?php
include "db_config.php";

$incomeQuery = "SELECT SUM(amount) as total_income 
                FROM transactions WHERE type='income'";
$expenseQuery = "SELECT SUM(amount) as total_expense 
                 FROM transactions WHERE type='expense'";

$incomeResult = $conn->query($incomeQuery)->fetch_assoc();
$expenseResult = $conn->query($expenseQuery)->fetch_assoc();

$total_income = $incomeResult['total_income'] ?? 0;
$total_expense = $expenseResult['total_expense'] ?? 0;
$profit = $total_income - $total_expense;

echo json_encode([
    "status" => "success",
    "total_income" => $total_income,
    "total_expense" => $total_expense,
    "profit" => $profit
]);
?>