<?php
include "db_config.php";

$id = $_GET['project_id'];

$sql = "
SELECT l.*
FROM project_labours pl
JOIN labours l ON l.id = pl.labour_id
WHERE pl.project_id = $id
";

$res = $conn->query($sql);
$data = [];

while ($row = $res->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode($data);
