<?php
include "db_config.php";

if (!empty($_POST['name']) && !empty($_POST['role']) && !empty($_POST['wage']) && !empty($_POST['contact'])) {
    $name = $_POST['name'];
    $role = $_POST['role'];
    $wage = $_POST['wage'];
    $contact = $_POST['contact'];

    // Insert into your actual table columns
    $stmt = $conn->prepare("INSERT INTO labour (name, role, wage, contact) VALUES (?, ?, ?, ?)");
    $stmt->bind_param("ssss", $name, $role, $wage, $contact);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Labour added successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to insert data: " . $conn->error]);
    }

    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "Missing fields"]);
}

$conn->close();
?>
