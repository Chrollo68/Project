<?php
include "db_config.php";

$id = $_GET['project_id'];

$res = $conn->query(
    "SELECT * FROM project_payments 
     WHERE project_id = $id 
     ORDER BY payment_date DESC"
);

$data = [];
while ($row = $res->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode($data);
