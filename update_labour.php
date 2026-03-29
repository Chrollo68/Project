<?php
include "db_config.php";

$id = $_POST['id'] ?? '';
$name = $_POST['name'] ?? '';
$role = $_POST['role'] ?? '';
$wage = $_POST['wage'] ?? '';
$contact = $_POST['contact'] ?? '';

if (empty($id) || empty($name) || empty($role) || empty($wage) || empty($contact)) {
    echo json_encode(["status" => "error", "message" => "Missing fields"]);
    exit;
}

$stmt = $conn->prepare("UPDATE labour SET name=?, role=?, wage=?, contact=? WHERE id=?");
$stmt->bind_param("ssssi", $name, $role, $wage, $contact, $id);

if ($stmt->execute()) {
    echo json_encode(["status" => "success", "message" => "Labour updated successfully"]);
} else {
    echo json_encode(["status" => "error", "message" => "Failed to update labour"]);
}
?>
