import 'dart:convert';

//import 'attendance_page.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LabourPage extends StatefulWidget {
  const LabourPage({Key? key}) : super(key: key);

  @override
  _LabourPageState createState() => _LabourPageState();
}

class _LabourPageState extends State<LabourPage> {
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  final _wageController = TextEditingController();
  final _contactController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<dynamic> _labourList = [];
  bool _loading = false;
  String _lastActivity = "";

  final String _baseUrl = "http://localhost/cividesk_api";

  @override
  void initState() {
    super.initState();
    _fetchLabour();
  }

  Future<void> _fetchLabour() async {
    setState(() => _loading = true);
    try {
      final resp = await http.get(Uri.parse("$_baseUrl/get_labour.php"));
      if (resp.statusCode == 200) {
        final body = json.decode(resp.body);
        setState(() => _labourList = body["data"] ?? []);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error loading labour: $e")));
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _addLabour() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final resp = await http.post(
        Uri.parse("$_baseUrl/add_labour.php"),
        body: {
          "name": _nameController.text.trim(),
          "role": _roleController.text.trim(),
          "wage": _wageController.text.trim(),
          "contact": _contactController.text.trim(),
        },
      );

      final body = json.decode(resp.body);
      if (body["status"] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Labour added successfully")),
        );
        _lastActivity = "New labour added: ${_nameController.text}";
        _nameController.clear();
        _roleController.clear();
        _wageController.clear();
        _contactController.clear();
        _fetchLabour();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(body["message"] ?? "Failed to add labour")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> _updateLabour(
    String id,
    String name,
    String role,
    String wage,
    String contact,
  ) async {
    try {
      final resp = await http.post(
        Uri.parse("$_baseUrl/update_labour.php"),
        body: {
          "id": id,
          "name": name,
          "role": role,
          "wage": wage,
          "contact": contact,
        },
      );
      final body = json.decode(resp.body);
      if (body["status"] == "success") {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Labour updated")));
        _lastActivity = "Labour updated: $name";
        _fetchLabour();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(body["message"] ?? "Failed to update")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> _softDelete(String id) async {
    try {
      final resp = await http.post(
        Uri.parse("$_baseUrl/delete_labour.php"),
        body: {"id": id},
      );
      final body = json.decode(resp.body);
      if (body["status"] == "success") {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Labour removed")));
        _lastActivity = "Labour removed";
        _fetchLabour();
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  void _showEditDialog(dynamic item) {
    final editName = TextEditingController(text: item["name"]);
    final editRole = TextEditingController(text: item["role"]);
    final editWage = TextEditingController(text: item["wage"]);
    final editContact = TextEditingController(text: item["contact"]);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Labour"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: editName,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: editRole,
              decoration: const InputDecoration(labelText: "Role"),
            ),
            TextField(
              controller: editWage,
              decoration: const InputDecoration(labelText: "Wage"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: editContact,
              decoration: const InputDecoration(labelText: "Contact"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _updateLabour(
                item["id"].toString(),
                editName.text,
                editRole.text,
                editWage.text,
                editContact.text,
              );
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context, _lastActivity);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: const Text("Labour Management"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, _lastActivity),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: "Name",
                            ),
                            validator: (v) => v!.isEmpty ? "Enter name" : null,
                            onFieldSubmitted: (_) => _addLabour(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _roleController,
                            decoration: const InputDecoration(
                              labelText: "Role",
                            ),
                            validator: (v) => v!.isEmpty ? "Enter role" : null,
                            onFieldSubmitted: (_) => _addLabour(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _wageController,
                            decoration: const InputDecoration(
                              labelText: "Wage",
                            ),
                            keyboardType: TextInputType.number,
                            validator: (v) => v!.isEmpty ? "Enter wage" : null,
                            onFieldSubmitted: (_) => _addLabour(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _contactController,
                            decoration: const InputDecoration(
                              labelText: "Contact",
                            ),
                            validator: (v) =>
                                v!.isEmpty ? "Enter contact" : null,
                            onFieldSubmitted: (_) => _addLabour(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: _addLabour,
                          icon: const Icon(Icons.add),
                          label: const Text("Add Labour"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 18,
                            ),
                          ),
                        ),
                        // const SizedBox(width: 12),
                        // ElevatedButton.icon(
                        //   onPressed: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (_) => const AttendancePage(),
                        //       ),
                        //     );
                        //   },
                        //   icon: const Icon(Icons.check_circle_outline),
                        //   label: const Text("Mark Attendance"),
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: Colors.green,
                        //     padding: const EdgeInsets.symmetric(
                        //       horizontal: 18,
                        //       vertical: 16,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Available Labour",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade800,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _labourList.isEmpty
                    ? const Center(child: Text("No labour data available"))
                    : ListView.builder(
                        itemCount: _labourList.length,
                        itemBuilder: (context, index) {
                          final item = _labourList[index];
                          return Card(
                            child: ListTile(
                              title: Text("${item["name"]} (${item["role"]})"),
                              subtitle: Text(
                                "Wage: ₹${item["wage"]} | Contact: ${item["contact"]}",
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blueGrey,
                                    ),
                                    onPressed: () => _showEditDialog(item),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () =>
                                        _softDelete(item["id"].toString()),
                                  ),
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
      ),
    );
  }
}
