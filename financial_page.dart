import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FinancialPage extends StatefulWidget {
  const FinancialPage({Key? key}) : super(key: key);

  @override
  State<FinancialPage> createState() => _FinancialPageState();
}

class _FinancialPageState extends State<FinancialPage> {
  final _formKey = GlobalKey<FormState>();

  // ✅ WINDOWS DESKTOP
  String baseUrl = "http://127.0.0.1/cividesk_api";

  String type = "expense";
  String category = "Labour";
  String paymentMethod = "Cash";
  int? selectedProjectId;
  int? editingTransactionId;

  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List projects = [];
  List transactions = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchProjects();
    fetchTransactions();
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // ================= FETCH PROJECTS =================

  Future<void> fetchProjects() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/get_projects.php"));

      final data = jsonDecode(response.body);

      // Support APIs returning either { "status": "success", "data": [...] }
      // or { "success": true, "data": [...] }
      final bool ok = (data["success"] == true) || (data["status"] == "success");
      if (ok && data["data"] != null) {
        setState(() {
          projects = List.from(data["data"]);
          // normalize: ensure each project has both `project_name` and `name` keys
          for (var i = 0; i < projects.length; i++) {
            final p = projects[i] as Map<String, dynamic>;
            final pname = p["project_name"] ?? p["name"] ?? "";
            p["project_name"] = pname;
            p["name"] = pname;
            projects[i] = p;
          }
        });
      } else {
        print("Failed to fetch projects: ${response.body}");
      }
    } catch (e) {
      print("Project Fetch Error: $e");
    }
  }

  // ================= FETCH TRANSACTIONS =================

  Future<void> fetchTransactions() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response =
          await http.get(Uri.parse("$baseUrl/get_transactions.php"));

      final data = jsonDecode(response.body);

      if (data["success"] == true) {
        setState(() {
          transactions = data["data"] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Fetch Transactions Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // ================= ADD/UPDATE TRANSACTION =================

  Future<void> saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final url = editingTransactionId != null
          ? "$baseUrl/update_transaction.php"
          : "$baseUrl/add_transaction.php";

      final body = {
        "type": type,
        "category": category,
        "amount": double.tryParse(amountController.text) ?? 0,
        "payment_method": paymentMethod,
        "description": descriptionController.text,
        "project_id": selectedProjectId,
      };

      if (editingTransactionId != null) {
        body["id"] = editingTransactionId;
      }

      print("Saving Transaction: $body");

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      print("Response: ${response.body}");

      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (data["status"] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(editingTransactionId != null
                ? "Transaction Updated"
                : "Transaction Added Successfully"),
          ),
        );

        resetForm();
        await fetchTransactions();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Operation failed")),
        );
      }
    } catch (e) {
      print("Save Transaction Error: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  // ================= EDIT TRANSACTION =================

  void editTransaction(Map transaction) {
    setState(() {
      editingTransactionId = int.parse(transaction["id"].toString());
      type = transaction["type"];
      category = transaction["category"];
      paymentMethod = transaction["payment_method"];
      selectedProjectId = transaction["project_id"] != null
          ? int.parse(transaction["project_id"].toString())
          : null;
      amountController.text = transaction["amount"].toString();
      descriptionController.text = transaction["description"] ?? "";
    });

    print("Editing transaction - Selected Project ID: $selectedProjectId");

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text("Editing transaction... Scroll up to save changes")),
      );
    }
  }

  // ================= DELETE TRANSACTION =================

  Future<void> deleteTransaction(int transactionId) async {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text("Delete Transaction"),
        content: const Text("Are you sure you want to delete this transaction?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                final response = await http.post(
                  Uri.parse("$baseUrl/delete_transaction.php"),
                  headers: {
                    "Content-Type": "application/json",
                  },
                  body: jsonEncode({
                    "id": transactionId,
                  }),
                );

                print("Delete Response: ${response.body}");

                final data = jsonDecode(response.body);

                if (!mounted) return;

                if (data["status"] == "success") {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Transaction Deleted")),
                  );
                  await fetchTransactions();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(data["message"] ?? "Failed to delete")),
                  );
                }
              } catch (e) {
                print("Delete Error: $e");
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: $e")),
                );
              }
            },
            child:
                const Text("Delete", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  void resetForm() {
    setState(() {
      editingTransactionId = null;
      type = "expense";
      category = "Labour";
      paymentMethod = "Cash";
      selectedProjectId = null;
      amountController.clear();
      descriptionController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> expenseCategories = [
      "Labour",
      "Material",
      "Transport",
      "Equipment",
      "Miscellaneous"
    ];

    List<String> incomeCategories = [
      "Client Payment",
      "Advance",
      "Extra Work",
      "Other"
    ];

    List<String> currentCategories =
        type == "expense" ? expenseCategories : incomeCategories;

    return Scaffold(
      appBar: AppBar(title: const Text("Financial Module")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ================= FORM SECTION =================
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    /// FORM TITLE
                    Text(
                      editingTransactionId != null
                          ? "Edit Transaction"
                          : "Add New Transaction",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),

                    /// TYPE
                    DropdownButtonFormField<String>(
                      value: type,
                      items: ["income", "expense"]
                          .map<DropdownMenuItem<String>>(
                              (e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(e.toUpperCase()),
                                  ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          type = val!;
                          category = type == "expense"
                              ? expenseCategories.first
                              : incomeCategories.first;
                        });
                      },
                      decoration: const InputDecoration(labelText: "Type"),
                    ),

                    const SizedBox(height: 10),

                    /// CATEGORY
                    DropdownButtonFormField<String>(
                      value: category,
                      items: currentCategories
                          .map<DropdownMenuItem<String>>(
                              (e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(e),
                                  ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          category = val!;
                        });
                      },
                      decoration: const InputDecoration(labelText: "Category"),
                    ),

                    const SizedBox(height: 10),

                    /// AMOUNT
                    TextFormField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter amount";
                        }
                        if (double.tryParse(value) == null) {
                          return "Enter valid number";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: "Amount"),
                    ),

                    const SizedBox(height: 10),

                    /// PAYMENT METHOD
                    DropdownButtonFormField<String>(
                      value: paymentMethod,
                      items: ["Cash", "UPI", "Bank Transfer", "Cheque"]
                          .map<DropdownMenuItem<String>>(
                              (e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(e),
                                  ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          paymentMethod = val!;
                        });
                      },
                      decoration:
                          const InputDecoration(labelText: "Payment Method"),
                    ),

                    const SizedBox(height: 10),

                    /// PROJECT DROPDOWN
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: DropdownButton<int?>(
                        value: selectedProjectId,
                        isExpanded: true,
                        underline: const SizedBox(),
                        hint: const Text("Select Project (Optional)"),
                        items: [
                          const DropdownMenuItem<int?>(
                            value: null,
                            child: Text("No Project (Optional)"),
                          ),
                          ...projects
                              .map<DropdownMenuItem<int?>>(
                                  (project) => DropdownMenuItem<int?>(
                                        value: int.parse(
                                            project["id"].toString()),
                                        child: Text(
                                            project["project_name"] ?? ""),
                                      ))
                              .toList(),
                        ],
                        onChanged: (val) {
                          setState(() {
                            selectedProjectId = val;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// DESCRIPTION
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration:
                          const InputDecoration(labelText: "Description"),
                    ),

                    const SizedBox(height: 20),

                    /// BUTTONS
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: saveTransaction,
                            child: Text(editingTransactionId != null
                                ? "Update Transaction"
                                : "Add Transaction"),
                          ),
                        ),
                        if (editingTransactionId != null) ...[
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: resetForm,
                              child: const Text("Cancel Edit"),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const Divider(thickness: 2),

            // ================= TRANSACTIONS LIST SECTION =================
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Transaction History",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: fetchTransactions,
                        tooltip: "Refresh",
                      )
                    ],
                  ),
                  Expanded(
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : transactions.isEmpty
                            ? const Center(
                                child: Text("No transactions yet"),
                              )
                            : ListView.builder(
                                itemCount: transactions.length,
                                itemBuilder: (context, index) {
                                  final transaction = transactions[index];
                                  final isExpense =
                                      transaction["type"] == "expense";
                                  final projectName = transaction[
                                              "project_name"] !=
                                          null
                                      ? " • ${transaction["project_name"]}"
                                      : "";

                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8),
                                    child: ListTile(
                                      leading: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: isExpense
                                              ? Colors.redAccent
                                              : Colors.greenAccent,
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: Center(
                                          child: Text(
                                            isExpense ? "-" : "+",
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        transaction["category"],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        "${transaction["payment_method"]}$projectName\n${transaction["description"] ?? "No description"}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      trailing: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "₹${transaction["amount"]}",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: isExpense
                                                  ? Colors.redAccent
                                                  : Colors.greenAccent,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              InkWell(
                                                onTap: () =>
                                                    editTransaction(transaction),
                                                child: const Icon(Icons.edit,
                                                    size: 20,
                                                    color: Colors.blue),
                                              ),
                                              const SizedBox(width: 10),
                                              InkWell(
                                                onTap: () => deleteTransaction(
                                                    int.parse(transaction["id"]
                                                        .toString())),
                                                child: const Icon(Icons.delete,
                                                    size: 20,
                                                    color: Colors.redAccent),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
