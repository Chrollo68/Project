<?php
header("Content-Type: application/json");
include "db_config.php";

if (!isset($_GET['labour_id'])) {
    echo json_encode(["status" => "error", "message" => "Missing labour_id"]);
    exit;
}

$labour_id = intval($_GET['labour_id']);
$from_date = $_GET['from_date'] ?? null;
$to_date = $_GET['to_date'] ?? null;

// Get labour details (name, wage, role)
$labourer = $conn->prepare("SELECT id, name, role, wage FROM labour WHERE id = ?");
$labourer->bind_param("i", $labour_id);
$labourer->execute();
$labResult = $labourer->get_result();
$labour = $labResult->fetch_assoc();

if (!$labour) {
    echo json_encode(["status" => "error", "message" => "Labour not found"]);
    exit;
}

$labourer->close();

// Build query for attendance records
$where = "WHERE labour_id = ?";
$params = [$labour_id];
$types = "i";

if ($from_date) {
    $where .= " AND att_date >= ?";
    $params[] = $from_date;
    $types .= "s";
}

if ($to_date) {
    $where .= " AND att_date <= ?";
    $params[] = $to_date;
    $types .= "s";
}

$sql = "SELECT id, labour_id, att_date, status, created_at FROM attendance $where ORDER BY att_date DESC";
$stmt = $conn->prepare($sql);

if (!$stmt) {
    echo json_encode(["status" => "error", "message" => "Prepare failed: " . $conn->error]);
    exit;
}

// Bind parameters dynamically
if (count($params) > 0) {
    $stmt->bind_param($types, ...$params);
}

$stmt->execute();
$records = [];
$result = $stmt->get_result();

$totalPresent = 0;
$totalAbsent = 0;
$totalHalf = 0;
$seenDates = []; // Track which dates we've already processed to avoid duplicates

while ($row = $result->fetch_assoc()) {
    $date = $row['att_date'];
    // Only add the first record for each date (in case of duplicates)
    if (!in_array($date, $seenDates)) {
        $records[] = $row;
        $seenDates[] = $date;
        
        // Normalize status for counting
        $status = strtolower(trim($row['status']));
        
        if ($status === 'present' || $status === 'p') {
            $totalPresent++;
        } elseif ($status === 'absent' || $status === 'a') {
            $totalAbsent++;
        } elseif ($status === 'half' || $status === 'half-day' || $status === 'h') {
            $totalHalf++;
        }
    }
}

// Calculate salary
$wage = doubleval($labour['wage'] ?? 0);
$presentDays = $totalPresent + ($totalHalf * 0.5);
$totalSalary = $wage * $presentDays;

echo json_encode([
    "status" => "success",
    "labour" => $labour,
    "records" => $records,
    "summary" => [
        "total_present" => $totalPresent,
        "total_absent" => $totalAbsent,
        "total_half" => $totalHalf,
        "total_working_days" => $presentDays,
        "wage_per_day" => $wage,
        "total_payable" => round($totalSalary, 2)
    ]
]);

$stmt->close();
$conn->close();
?>
