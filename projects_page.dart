import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'project_expenses_page.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({Key? key}) : super(key: key);

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final String baseUrl = "http://localhost/cividesk_api";

  final _name = TextEditingController();
  final _location = TextEditingController();
  final _description = TextEditingController();
  final _budget = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;
  String status = "ongoing";
  int? editingProjectId;

  bool loading = true;
  List<dynamic> projects = [];

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    setState(() => loading = true);
    try {
      final res = await http.get(Uri.parse("$baseUrl/get_projects.php"));
      final body = json.decode(res.body);
      projects = body["data"] ?? [];
    } catch (e) {
      debugPrint("Load error: $e");
    }
    setState(() => loading = false);
  }

  Future<void> _saveProject() async {
    final url = editingProjectId == null
        ? "$baseUrl/add_project.php"
        : "$baseUrl/update_project.php";

    final res = await http.post(
      Uri.parse(url),
      body: {
        if (editingProjectId != null) "id": editingProjectId.toString(),
        "project_name": _name.text,
        "location": _location.text,
        "description": _description.text,
        "budget": _budget.text,
        "status": status,
        "start_date": startDate?.toString().split(" ")[0] ?? "",
        "end_date": endDate?.toString().split(" ")[0] ?? "",
      },
    );

    final body = json.decode(res.body);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(body["message"] ?? "Done")));

    _resetForm();
    _loadProjects();
  }

  Future<void> _deleteProject(int id) async {
    await http.post(
      Uri.parse("$baseUrl/delete_project.php"),
      body: {"id": id.toString()},
    );
    _loadProjects();
  }

  void _resetForm() {
    _name.clear();
    _location.clear();
    _description.clear();
    _budget.clear();
    startDate = null;
    endDate = null;
    status = "ongoing";
    editingProjectId = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Projects Management"),
        backgroundColor: Colors.blueGrey,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildProjectForm(),
                  const SizedBox(height: 20),
                  _buildSummaryCards(),
                  const SizedBox(height: 20),
                  Expanded(child: _buildProjectsList()),
                ],
              ),
            ),
    );
  }

  Widget _buildProjectForm() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                _field(_name, "Project Name"),
                _field(_location, "Location"),
                _dateField("Start Date", startDate, (d) => startDate = d),
                _dateField("End Date", endDate, (d) => endDate = d),
                _field(_budget, "Budget (₹)", isNumber: true),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: status,
                  onChanged: (v) => setState(() => status = v!),
                  items: const [
                    DropdownMenuItem(value: "ongoing", child: Text("Ongoing")),
                    DropdownMenuItem(
                        value: "completed", child: Text("Completed")),
                  ],
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _saveProject,
                  child:
                      Text(editingProjectId == null ? "Add Project" : "Update"),
                ),
                TextButton(onPressed: _resetForm, child: const Text("Reset")),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _description,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    double totalBudget = 0;
    int ongoing = 0;

    for (var p in projects) {
      totalBudget += double.tryParse(p["budget"].toString()) ?? 0;
      if (p["status"] == "ongoing") ongoing++;
    }

    return Row(
      children: [
        _summaryCard(
            "Total Projects", projects.length.toDouble(), Colors.blueGrey),
        _summaryCard("Ongoing Projects", ongoing.toDouble(), Colors.orange),
        _summaryCard("Total Budget", totalBudget, Colors.green),
      ],
    );
  }

  Widget _buildProjectsList() {
    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (_, i) {
        final p = projects[i];

        return Card(
          child: ListTile(
            title: Text(p["name"] ?? ""),
            subtitle: Text(
              "Budget: ₹${p["budget"]}\n"
              "Location: ${p["location"]}\n"
              "Status: ${p["status"]}",
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProjectExpensesPage(
                                  projectId: int.parse(p["id"].toString()),
                                )));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      editingProjectId = int.parse(p["id"].toString());
                      _name.text = p["name"] ?? "";
                      _location.text = p["location"] ?? "";
                      _description.text = p["description"] ?? "";
                      _budget.text = p["budget"] ?? "";
                      status = p["status"] ?? "ongoing";
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () =>
                      _deleteProject(int.parse(p["id"].toString())),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _field(TextEditingController c, String label,
      {bool isNumber = false}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: TextField(
          controller: c,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(labelText: label),
        ),
      ),
    );
  }

  Widget _dateField(String label, DateTime? value, Function(DateTime) onPick) {
    return Expanded(
      child: TextButton(
        onPressed: () async {
          final d = await showDatePicker(
            context: context,
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
            initialDate: DateTime.now(),
          );
          if (d != null) setState(() => onPick(d));
        },
        child: Text(
          value == null ? label : "$label\n${value.toString().split(" ")[0]}",
        ),
      ),
    );
  }

  Widget _summaryCard(String title, double value, Color color) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                title == "Total Budget"
                    ? "₹${value.toStringAsFixed(2)}"
                    : value.toInt().toString(),
                style: TextStyle(color: color, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
