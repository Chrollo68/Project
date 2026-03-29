<?php
include 'db_config.php';

$project_id = $_GET['project_id'];

$query = "
SELECT *
FROM transactions
WHERE project_id = '$project_id'
ORDER BY created_at DESC
";

$result = mysqli_query($conn, $query);

$transactions = [];

while ($row = mysqli_fetch_assoc($result)) {
    $transactions[] = $row;
}

echo json_encode([
    "success" => true,
    "data" => $transactions
]);
?>
