import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProjectExpensesPage extends StatefulWidget {
  final int projectId;

  const ProjectExpensesPage({Key? key, required this.projectId})
      : super(key: key);

  @override
  State<ProjectExpensesPage> createState() => _ProjectExpensesPageState();
}

class _ProjectExpensesPageState extends State<ProjectExpensesPage> {
  final String baseUrl = "http://localhost/cividesk_api";

  bool loading = true;
  List expenses = [];

  double budget = 0;
  double totalExpense = 0;
  double profit = 0;

  @override
  void initState() {
    super.initState();
    fetchProjectData();
  }

  Future<void> fetchProjectData() async {
    setState(() => loading = true);

    try {
      final res = await http.get(
        Uri.parse(
            "$baseUrl/get_project_expenses.php?project_id=${widget.projectId}"),
      );

      final body = json.decode(res.body);

      if (body["status"] == "success") {
        expenses = body["data"] ?? [];
        budget = double.tryParse(body["budget"].toString()) ?? 0;
        totalExpense = double.tryParse(body["total_expense"].toString()) ?? 0;
        profit = double.tryParse(body["profit"].toString()) ?? 0;
      }
    } catch (e) {
      debugPrint("Error fetching project data: $e");
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Project Financial Summary"),
        backgroundColor: Colors.blueGrey,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSummarySection(),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Expense Transactions",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(child: _buildExpenseList()),
                ],
              ),
            ),
    );
  }

  // ================= SUMMARY SECTION =================

  Widget _buildSummarySection() {
    return Row(
      children: [
        _summaryCard("Estimated Budget", budget, Colors.blue),
        _summaryCard("Total Expense", totalExpense, Colors.red),
        _summaryCard(
          profit >= 0 ? "Profit" : "Loss",
          profit,
          profit >= 0 ? Colors.green : Colors.orange,
        ),
      ],
    );
  }

  Widget _summaryCard(String title, double value, Color color) {
    return Expanded(
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "₹${value.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 18,
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

  // ================= EXPENSE LIST =================

  Widget _buildExpenseList() {
    if (expenses.isEmpty) {
      return const Center(child: Text("No expenses found for this project."));
    }

    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final e = expenses[index];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            title: Text(e["category"] ?? "No Category"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e["description"] ?? ""),
                const SizedBox(height: 4),
                Text(
                  "Date: ${e["transaction_date"] ?? ""}",
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  "Payment: ${e["payment_method"] ?? ""}",
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            trailing: Text(
              "₹${e["amount"]}",
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
