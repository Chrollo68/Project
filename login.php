<?php
include "db_config.php";

$username = $_POST['username'] ?? '';
$password = $_POST['password'] ?? '';

if (empty($username) || empty($password)) {
    echo json_encode(["status"=>"error","message"=>"Missing fields"]);
    exit;
}

// Fetch user by username only (do not compare plaintext passwords in SQL)
$stmt = $conn->prepare("SELECT username, password, role FROM users WHERE username=?");
$stmt->bind_param("s", $username);
$stmt->execute();
$res = $stmt->get_result();

if ($res->num_rows > 0) {
    $row = $res->fetch_assoc();
    $hash = $row['password'];

    if (password_verify($password, $hash)) {
        echo json_encode([
            "status" => "success",
            "username" => $row['username'],
            "role" => $row['role']
        ]);
    } else {
        echo json_encode(["status"=>"error","message"=>"Invalid credentials"]);
    }
} else {
    echo json_encode(["status"=>"error","message"=>"Invalid credentials"]);
}
?>
