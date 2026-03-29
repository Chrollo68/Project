<?php
header("Content-Type: application/json");
include "db_config.php";

if (!$conn) {
    echo json_encode(["success" => false, "message" => "DB connection failed"]);
    exit;
}

$date = $_POST['date'] ?? '';
$records = json_decode($_POST['records'] ?? '{}', true);

if (empty($date) || empty($records)) {
    echo json_encode(["success" => false, "message" => "Missing date or records"]);
    exit;
}

foreach ($records as $labour_id => $status) {
    $labour_id = intval($labour_id); // Cast to int since JSON keys are strings

    // Check existing
    $check = $conn->prepare(
        "SELECT id FROM attendance WHERE labour_id=? AND att_date=?"
    );
    if (!$check) {
        echo json_encode(["success" => false, "message" => "Prepare failed: " . $conn->error]);
        exit;
    }
    $check->bind_param("is", $labour_id, $date);
    $check->execute();
    $res = $check->get_result();

    if ($res->num_rows > 0) {
        // Update
        $update = $conn->prepare(
            "UPDATE attendance SET status=? WHERE labour_id=? AND att_date=?"
        );
        if (!$update) {
            echo json_encode(["success" => false, "message" => "Update prepare failed: " . $conn->error]);
            exit;
        }
        $update->bind_param("sis", $status, $labour_id, $date);
        $update->execute();
        $update->close();
    } else {
        // Insert
        $insert = $conn->prepare(
            "INSERT INTO attendance (labour_id, att_date, status)
             VALUES (?,?,?)"
        );
        if (!$insert) {
            echo json_encode(["success" => false, "message" => "Insert prepare failed: " . $conn->error]);
            exit;
        }
        $insert->bind_param("iss", $labour_id, $date, $status);
        $insert->execute();
        $insert->close();
    }
    $check->close();
}

echo json_encode(["success" => true, "message" => "Attendance Saved"]);
$conn->close();
?>
