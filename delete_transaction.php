<?php
include "db_config.php";

$data = json_decode(file_get_contents("php://input"), true);

$id = $data['id'];

// Validate required field
if (!$id) {
    echo json_encode([
        "status" => "error",
        "message" => "Transaction ID is required"
    ]);
    exit;
}

$sql = "DELETE FROM transactions WHERE id = ?";

$stmt = $conn->prepare($sql);

if (!$stmt) {
    echo json_encode([
        "status" => "error",
        "message" => "Prepare failed: " . $conn->error
    ]);
    exit;
}

$stmt->bind_param("i", $id);

if ($stmt->execute()) {
    if ($stmt->affected_rows > 0) {
        echo json_encode([
            "status" => "success",
            "message" => "Transaction deleted successfully"
        ]);
    } else {
        echo json_encode([
            "status" => "error",
            "message" => "Transaction not found"
        ]);
    }
} else {
    echo json_encode([
        "status" => "error",
        "message" => "Failed to delete transaction: " . $stmt->error
    ]);
}

$stmt->close();
?>
