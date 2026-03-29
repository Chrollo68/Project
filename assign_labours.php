<?php
include "db_config.php";

$project_id = $_POST['project_id'];
$labours = json_decode($_POST['labour_ids'], true);

$conn->query("DELETE FROM project_labours WHERE project_id = $project_id");

foreach ($labours as $labour_id) {
    $conn->query(
        "INSERT INTO project_labours (project_id, labour_id)
         VALUES ($project_id, $labour_id)"
    );
}

echo json_encode(["status" => "success"]);
