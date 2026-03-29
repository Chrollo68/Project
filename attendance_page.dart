import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final String baseUrl = "http://localhost/cividesk_api";

  DateTime selectedDate = DateTime.now();

  List labourList = [];
  Map<int, String> attendance = {};

  bool loading = true;
  bool saving = false;

  String get dateStr => selectedDate.toIso8601String().split("T")[0];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // ================= LOAD LABOUR + ATTENDANCE
  Future<void> loadData() async {
    try {
      // Load Labour
      final labourRes = await http.get(Uri.parse("$baseUrl/get_labour.php"));

      final labourData = json.decode(labourRes.body);
      if (labourData["status"] == "success" && labourData["data"] != null) {
        labourList = labourData["data"];
      } else {
        labourList = [];
      }

      // Load Attendance
      final attRes = await http
          .get(Uri.parse("$baseUrl/get_attendance.php?date=$dateStr"));

      final attData = json.decode(attRes.body);

      attendance.clear();

      attData.forEach((k, v) {
        attendance[int.parse(k)] = v;
      });
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() => loading = false);
  }

  // ================= SAVE
  Future<void> saveAttendance() async {
    setState(() => saving = true);

    try {
      // Convert int keys to strings for JSON encoding
      final attendanceMap = <String, String>{};
      attendance.forEach((k, v) {
        attendanceMap[k.toString()] = v;
      });

      print("Saving attendance for $dateStr");
      print("Records: $attendanceMap");

      final res = await http.post(Uri.parse("$baseUrl/save_attendance.php"),
          body: {"date": dateStr, "records": json.encode(attendanceMap)});

      print("Response status: ${res.statusCode}");
      print("Response body: ${res.body}");

      // Handle HTML error responses
      if (res.body.contains("<br") ||
          res.body.contains("<") ||
          !res.body.startsWith("{")) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Server error: ${res.body.replaceAll(RegExp(r'<[^>]*>'), '')}")),
        );
        setState(() => saving = false);
        return;
      }

      final body = json.decode(res.body);

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(body['message'] ?? "Saved")));

      setState(() => saving = false);
    } catch (e) {
      print("Error saving attendance: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
      setState(() => saving = false);
    }
  }

  // ================= DATE PICKER
  Future<void> pickDate() async {
    final d = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2100));

    if (d != null) {
      selectedDate = d;
      setState(() => loading = true);
      await loadData();
    }
  }

  // ================= UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Labour Attendance"),
        backgroundColor: Colors.blueGrey,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // HEADER
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Text(
                        "Date: $dateStr",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: pickDate,
                        icon: const Icon(Icons.calendar_today),
                        label: const Text("Change Date"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: saving ? null : saveAttendance,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        child: saving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white))
                            : const Text("Save"),
                      )
                    ],
                  ),
                ),

                const Divider(),

                // LIST
                Expanded(
                  child: ListView.builder(
                    itemCount: labourList.length,
                    itemBuilder: (_, i) {
                      final l = labourList[i];
                      final id = int.parse(l['id'].toString());

                      attendance.putIfAbsent(id, () => "absent");

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: ListTile(
                          title: Text(l['name']),
                          subtitle: Text("Role: ${l['role']}"),
                          trailing: DropdownButton<String>(
                            value: attendance[id],
                            items: const [
                              DropdownMenuItem(
                                  value: "present", child: Text("Present")),
                              DropdownMenuItem(
                                  value: "half", child: Text("Half Day")),
                              DropdownMenuItem(
                                  value: "absent", child: Text("Absent"))
                            ],
                            onChanged: (v) {
                              setState(() => attendance[id] = v!);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
    );
  }
}
