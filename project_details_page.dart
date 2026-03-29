import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProjectDetailsPage extends StatefulWidget {
  final int projectId;

  const ProjectDetailsPage({Key? key, required this.projectId})
    : super(key: key);

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  final String baseUrl = "http://localhost/cividesk_api";
  Map<String, dynamic>? project;
  List<dynamic> payments = [];

  final _amount = TextEditingController();
  final _note = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    final res = await http.get(
      Uri.parse("$baseUrl/get_project_details.php?id=${widget.projectId}"),
    );
    final body = json.decode(res.body);
    project = body["project"];
    payments = body["payments"] ?? [];
    setState(() {});
  }

  Future<void> _addPayment() async {
    await http.post(
      Uri.parse("$baseUrl/add_project_payment.php"),
      body: {
        "project_id": widget.projectId.toString(),
        "amount": _amount.text,
        "note": _note.text,
      },
    );
    _amount.clear();
    _note.clear();
    _loadDetails();
  }

  @override
  Widget build(BuildContext context) {
    if (project == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(project!["name"]),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Budget: ₹${project!["budget"]} | Received: ₹${project!["received"]} | Balance: ₹${project!["balance"]}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: payments.map((p) {
                  return Card(
                    child: ListTile(
                      title: Text("₹${p["amount"]}"),
                      subtitle: Text(
                        "${p["payment_date"]} • ${p["note"] ?? ""}",
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amount,
                    decoration: const InputDecoration(
                      labelText: "Payment Amount",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _note,
                    decoration: const InputDecoration(labelText: "Note"),
                  ),
                ),
                ElevatedButton(
                  onPressed: _addPayment,
                  child: const Text("Add Payment"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
