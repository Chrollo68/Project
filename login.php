<?php
include "db_config.php";

$username = $_POST['username'] ?? '';
$password = $_POST['password'] ?? '';

if (empty($username) || empty($password)) {
    echo json_encode(["status"=>"error","message"=>"Missing fields"]);
    exit;
}

$stmt = $conn->prepare(
    "SELECT username, role FROM users WHERE username=? AND password=?"
);
$stmt->bind_param("ss", $username, $password);
$stmt->execute();
$res = $stmt->get_result();

if ($res->num_rows > 0) {
    $row = $res->fetch_assoc();
    echo json_encode([
        "status" => "success",
        "username" => $row['username'],
        "role" => $row['role']
    ]);
} else {
    echo json_encode(["status"=>"error","message"=>"Invalid credentials"]);
}
?>
