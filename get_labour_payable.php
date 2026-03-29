<?php
include "db_config.php";

$labour_id = $_GET['labour_id'];

$sql = "
SELECT 
    SUM(
        CASE 
            WHEN status='present' THEN 1
            WHEN status='half' THEN 0.5
            ELSE 0
        END
    ) as total_days
FROM attendance
WHERE labour_id=?
";

$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $labour_id);
$stmt->execute();

$res = $stmt->get_result()->fetch_assoc();

$total_days = $res['total_days'] ?? 0;

// Fetch wage
$wage_sql = $conn->prepare(
    "SELECT wage FROM labour WHERE id=?"
);
$wage_sql->bind_param("i", $labour_id);
$wage_sql->execute();

$wage = $wage_sql->get_result()->fetch_assoc()['wage'];

$total_payable = $total_days * $wage;

echo json_encode([
    "days"=>$total_days,
    "wage"=>$wage,
    "payable"=>$total_payable
]);
?>
