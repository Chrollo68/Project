<?php
include "db_config.php";

$date = $_GET['date'];

$sql = "SELECT labour_id, status FROM attendance WHERE date=?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $date);
$stmt->execute();

$result = $stmt->get_result();

$data = [];

while($row = $result->fetch_assoc()){
    $data[$row['labour_id']] = $row['status'];
}

echo json_encode($data);
?>
