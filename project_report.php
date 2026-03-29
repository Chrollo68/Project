<?php
include 'db_config.php';

$project_id = $_GET['project_id'];

# Get project info
$projectQuery = "SELECT * FROM projects WHERE id = '$project_id'";
$projectResult = mysqli_query($conn, $projectQuery);
$project = mysqli_fetch_assoc($projectResult);

# Get total expense
$expenseQuery = "
SELECT IFNULL(SUM(amount),0) as total_expense
FROM transactions
WHERE project_id = '$project_id'
AND type = 'expense'
";
$expenseResult = mysqli_query($conn, $expenseQuery);
$expenseData = mysqli_fetch_assoc($expenseResult);

# Get total income
$incomeQuery = "
SELECT IFNULL(SUM(amount),0) as total_income
FROM transactions
WHERE project_id = '$project_id'
AND type = 'income'
";
$incomeResult = mysqli_query($conn, $incomeQuery);
$incomeData = mysqli_fetch_assoc($incomeResult);

$total_expense = $expenseData['total_expense'];
$total_income = $incomeData['total_income'];

$budget = $project['budget'];

$budget_remaining = $budget - $total_expense;
$profit = $total_income - $total_expense;

echo json_encode([
    "success" => true,
    "project" => $project,
    "summary" => [
        "total_expense" => $total_expense,
        "total_income" => $total_income,
        "budget_remaining" => $budget_remaining,
        "profit" => $profit
    ]
]);
?>
