<?php
include 'db_config.php';

$query = "SELECT * FROM projects ORDER BY created_at DESC";
$result = mysqli_query($conn, $query);

$projects = [];

while ($row = mysqli_fetch_assoc($result)) {
    $projects[] = $row;
}

echo json_encode([
    "success" => true,
    "data" => $projects
]);
?>
