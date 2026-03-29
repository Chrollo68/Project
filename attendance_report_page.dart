import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AttendanceReportPage extends StatefulWidget {
  const AttendanceReportPage({Key? key}) : super(key: key);

  @override
  State<AttendanceReportPage> createState() => _AttendanceReportPageState();
}

class _AttendanceReportPageState extends State<AttendanceReportPage> {
  final String baseUrl = "http://localhost/cividesk_api";

  List<dynamic> labourList = [];
  int? selectedLabourId;
  DateTime? fromDate;
  DateTime? toDate;

  Map<String, dynamic>? reportData;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    loadLabours();
  }

  // Load all labour
  Future<void> loadLabours() async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/get_labour.php"));
      final data = json.decode(res.body);

      if (data["status"] == "success" && data["data"] != null) {
        setState(() {
          labourList = data["data"];
        });
      }
    } catch (e) {
      debugPrint("Error loading labour: $e");
    }
  }

  // Fetch attendance report for selected labour
  Future<void> fetchReport() async {
    if (selectedLabourId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please select a labour")));
      return;
    }

    setState(() => loading = true);

    try {
      String url = "$baseUrl/get_attendance_report.php?labour_id=$selectedLabourId";
      if (fromDate != null) {
        url += "&from_date=${fromDate.toString().split(" ")[0]}";
      }
      if (toDate != null) {
        url += "&to_date=${toDate.toString().split(" ")[0]}";
      }

      final res = await http.get(Uri.parse(url));
      final data = json.decode(res.body);

      if (data["status"] == "success") {
        setState(() {
          reportData = data;
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(data["message"] ?? "Error")));
      }
    } catch (e) {
      debugPrint("Error fetching report: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() => loading = false);
  }

  // Date picker
  Future<void> pickDate(bool isFromDate) async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (d != null) {
      setState(() {
        if (isFromDate) {
          fromDate = d;
        } else {
          toDate = d;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Labour Attendance Report"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ================= FILTERS =================
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Labour Dropdown
                    DropdownButtonFormField<int?>(
                      value: selectedLabourId,
                      items: [
                        const DropdownMenuItem<int?>(
                          value: null,
                          child: Text("Select Labour"),
                        ),
                        ...labourList.map<DropdownMenuItem<int?>>(
                          (labour) => DropdownMenuItem<int?>(
                            value: int.parse(labour["id"].toString()),
                            child: Text(labour["name"] ?? "Unknown"),
                          ),
                        ),
                      ],
                      onChanged: (val) {
                        setState(() => selectedLabourId = val);
                      },
                      decoration: const InputDecoration(labelText: "Labour"),
                    ),
                    const SizedBox(height: 12),

                    // Date Range
                    Row(
                      children: [
                        Expanded(
                          child: TextButton.icon(
                            onPressed: () => pickDate(true),
                            icon: const Icon(Icons.calendar_today),
                            label: Text(
                              fromDate == null
                                  ? "From Date"
                                  : fromDate.toString().split(" ")[0],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextButton.icon(
                            onPressed: () => pickDate(false),
                            icon: const Icon(Icons.calendar_today),
                            label: Text(
                              toDate == null
                                  ? "To Date"
                                  : toDate.toString().split(" ")[0],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Fetch Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: loading ? null : fetchReport,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                        ),
                        child: loading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Text("Fetch Report"),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ================= REPORT SECTION =================
            if (reportData != null) ...[
              // Summary Cards
              _buildSummary(),
              const SizedBox(height: 20),

              // Attendance Records
              const Text(
                "Attendance Records",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _buildRecordsList(),
              ),
            ] else if (!loading)
              Expanded(
                child: Center(
                  child: Text(
                    selectedLabourId == null
                        ? "Select a labour and click Fetch Report"
                        : "No data",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    final summary = reportData!["summary"] as Map<String, dynamic>;
    final labour = reportData!["labour"] as Map<String, dynamic>;

    return Column(
      children: [
        Text(
          "${labour["name"]} (${labour["role"]})",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _summaryCard(
              "Present Days",
              summary["total_present"].toString(),
              Colors.green,
            ),
            _summaryCard(
              "Absent Days",
              summary["total_absent"].toString(),
              Colors.red,
            ),
            _summaryCard(
              "Half Days",
              summary["total_half"].toString(),
              Colors.orange,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          color: Colors.blueGrey.shade50,
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Daily Wage",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      "₹${summary["wage_per_day"]}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Working Days",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      "${summary["total_working_days"]}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "Total Payable",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      "₹${summary["total_payable"]}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _summaryCard(String label, String value, Color color) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecordsList() {
    final records = reportData!["records"] as List<dynamic>;

    if (records.isEmpty) {
      return const Center(child: Text("No attendance records found"));
    }

    return ListView.builder(
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        final statusRaw = (record["status"] ?? "").toString().toLowerCase().trim();
        
        // Normalize status for display
        String statusDisplay = statusRaw;
        Color color = Colors.grey;
        String initial = "?";
        
        if (statusRaw == 'present' || statusRaw == 'p') {
          statusDisplay = 'Present';
          color = Colors.green;
          initial = 'P';
        } else if (statusRaw == 'absent' || statusRaw == 'a') {
          statusDisplay = 'Absent';
          color = Colors.red;
          initial = 'A';
        } else if (statusRaw == 'half' || statusRaw == 'half-day' || statusRaw == 'h') {
          statusDisplay = 'Half Day';
          color = Colors.orange;
          initial = 'H';
        }

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: color,
              child: Text(
                initial,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              record["att_date"] ?? "Unknown",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              statusDisplay.toUpperCase(),
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ),
        );
      },
    );
  }
}
