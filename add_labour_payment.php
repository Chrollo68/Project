<?php
include "db_config.php";

$data = json_decode(file_get_contents("php://input"), true);

$labour_id = $data['labour_id'];
$from_date = $data['from_date'];
$to_date = $data['to_date'];
$total_days = $data['total_days'];
$daily_wage = $data['daily_wage'];
$total_amount = $data['total_amount'];

$conn->begin_transaction();

try {

    // Insert into labour_payments
    $sql1 = "INSERT INTO labour_payments 
    (labour_id, from_date, to_date, total_days, daily_wage, total_amount, payment_status)
    VALUES (?, ?, ?, ?, ?, ?, 'paid')";

    $stmt1 = $conn->prepare($sql1);
    $stmt1->bind_param("issddd",
        $labour_id,
        $from_date,
        $to_date,
        $total_days,
        $daily_wage,
        $total_amount
    );

    $stmt1->execute();
    $payment_id = $conn->insert_id;

    // Insert into transactions as expense
    $sql2 = "INSERT INTO transactions 
    (type, category, reference_id, amount, payment_method, description)
    VALUES ('expense', 'labour', ?, ?, 'cash', 'Labour Payment')";

    $stmt2 = $conn->prepare($sql2);
    $stmt2->bind_param("id",
        $payment_id,
        $total_amount
    );

    $stmt2->execute();

    $conn->commit();

    echo json_encode([
        "status" => "success",
        "message" => "Labour payment recorded"
    ]);

} catch (Exception $e) {
    $conn->rollback();
    echo json_encode([
        "status" => "error",
        "message" => "Transaction failed"
    ]);
}
?>