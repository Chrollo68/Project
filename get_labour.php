<?php
include "db_config.php";

$result = $conn->query("SELECT * FROM labour WHERE status='active' ORDER BY id DESC");

$data = [];
while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode(["status" => "success", "data" => $data]);
?>
