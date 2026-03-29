import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MaterialsPage extends StatefulWidget {
  const MaterialsPage({Key? key}) : super(key: key);

  @override
  State<MaterialsPage> createState() => _MaterialsPageState();
}

class _MaterialsPageState extends State<MaterialsPage> {
  final String baseUrl = "http://localhost/cividesk_api";

  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitController = TextEditingController();
  final _priceController = TextEditingController();
  final _totalStockController = TextEditingController();
  final _totalController = TextEditingController();

  int? editingId;
  String? selectedProjectId;

  bool loading = false;
  List<dynamic> materials = [];
  List<dynamic> projects = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => loading = true);
    await Future.wait([_loadProjects(), _loadMaterials()]);
    setState(() => loading = false);
  }

  Future<void> _loadProjects() async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/get_projects.php"));
      if (res.statusCode != 200) {
        throw Exception(
            'HTTP ${res.statusCode}: ${res.body.substring(0, 200)}');
      }
      if (!res.body.trim().startsWith('{')) {
        throw Exception('Non-JSON response: ${res.body.substring(0, 200)}');
      }
      final body = json.decode(res.body);
      setState(() => projects = body["data"] ?? []);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Projects load error: $e")));
    }
  }

  Future<void> _loadMaterials() async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/get_materials.php"));
      if (res.statusCode != 200) {
        throw Exception(
            'HTTP ${res.statusCode}: ${res.body.substring(0, 200)}');
      }
      if (!res.body.trim().startsWith('{')) {
        throw Exception('Non-JSON response: ${res.body.substring(0, 200)}');
      }
      final body = json.decode(res.body);
      if (body["status"] == "success") {
        setState(() => materials = List<dynamic>.from(body["data"] ?? []));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error loading materials: $e")));
    }
  }

  void _calculateTotal() {
    final qty = double.tryParse(_quantityController.text) ?? 0.0;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    _totalController.text = (qty * price).toStringAsFixed(2);
  }

  Future<void> _saveMaterial() async {
    final url = editingId == null
        ? "$baseUrl/add_material.php"
        : "$baseUrl/update_material.php";

    final bodyMap = {
      if (editingId != null) "id": editingId.toString(),
      "total_stock": _totalStockController.text.isEmpty
          ? "1000"
          : _totalStockController.text.trim(),
      "name": _nameController.text.trim(),
      "quantity": _quantityController.text.trim(),
      "unit": _unitController.text.trim(),
      "price_per_unit": _priceController.text.trim(),
      "total_cost": _totalController.text,
      if (selectedProjectId != null) "project_id": selectedProjectId!,
    };

    try {
      final res = await http.post(Uri.parse(url), body: bodyMap);
      if (res.statusCode != 200) {
        throw Exception(
            'HTTP ${res.statusCode}: ${res.body.substring(0, 200)}');
      }
      if (!res.body.trim().startsWith('{')) {
        throw Exception('Non-JSON response: ${res.body.substring(0, 200)}');
      }
      final body = json.decode(res.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(body["message"] ??
                (editingId == null ? "Material added" : "Material updated"))),
      );
      _resetForm();
      _loadMaterials();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Save error: $e")));
    }
  }

  Future<void> _deleteMaterial(String id) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/delete_material.php"),
        body: {"id": id},
      );
      if (res.statusCode != 200) {
        throw Exception(
            'HTTP ${res.statusCode}: ${res.body.substring(0, 200)}');
      }
      if (!res.body.trim().startsWith('{')) {
        throw Exception('Non-JSON response: ${res.body.substring(0, 200)}');
      }
      final body = json.decode(res.body);
      if (body['status'] != 'success') {
        throw Exception('Delete failed: ${body['message'] ?? 'Unknown error'}');
      }
      _loadMaterials();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(body['message'] ?? 'Material deleted')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Delete error: $e")));
    }
  }

  void _resetForm() {
    _nameController.clear();
    _quantityController.clear();
    _unitController.clear();
    _priceController.clear();
    _totalStockController.clear();
    _totalController.clear();
    selectedProjectId = null;
    editingId = null;
    setState(() {});
  }

  void _startEdit(dynamic item) {
    setState(() {
      editingId = int.parse(item['id'].toString());
      _nameController.text = item['name'] ?? '';
      _totalStockController.text = item['total_stock']?.toString() ?? '';
      _quantityController.text = item['quantity'] ?? '';
      _unitController.text = item['unit'] ?? '';
      _priceController.text = item['price_per_unit'] ?? '';
      _totalController.text = item['total_cost'] ?? '';
      selectedProjectId = item['project_id']?.toString();
    });
    _calculateTotal();
  }

  double _getTotalCost() {
    return materials.fold<double>(
        0.0,
        (sum, m) =>
            sum + (double.tryParse(m['total_cost']?.toString() ?? '0') ?? 0.0));
  }

  @override
  Widget build(BuildContext context) {
    final totalCost = _getTotalCost();
    final count = materials.length.toDouble();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Materials Management'),
        backgroundColor: Colors.blueGrey,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildForm(),
                  const SizedBox(height: 20),
                  _buildSummaryCards(count, totalCost),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _buildListView(),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildForm() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                _textField(_nameController, 'Material Name'),
                _textField(_quantityController, 'Quantity', isNumber: true),
                _textField(_unitController, 'Unit (kg, bags, etc.)'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _priceField(),
                _textField(_totalStockController, 'Total Stock',
                    isNumber: true),
                Expanded(
                  child: TextField(
                    controller: _totalController,
                    decoration: const InputDecoration(
                      labelText: 'Total Cost (₹)',
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: DropdownButtonFormField<String?>(
                    value: selectedProjectId,
                    decoration: const InputDecoration(
                      labelText: 'Project',
                      border: OutlineInputBorder(),
                    ),
                    isExpanded: true,
                    items: [
                      const DropdownMenuItem(
                          value: null, child: Text('No Project')),
                      ...projects.map<DropdownMenuItem<String?>>((p) =>
                          DropdownMenuItem(
                            value: p['id'].toString(),
                            child: Text(
                                p['project_name'] ?? p['name'] ?? 'Unknown'),
                          )),
                    ],
                    onChanged: (value) =>
                        setState(() => selectedProjectId = value),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _saveMaterial,
                  child: Text(editingId == null ? 'Add Material' : 'Update'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey),
                ),
                const SizedBox(width: 8),
                TextButton(onPressed: _resetForm, child: const Text('Reset')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(double count, double total) {
    return Row(
      children: [
        Expanded(
          child: _summaryCard(
              'Total Materials', count.toInt().toString(), Colors.blueGrey),
        ),
        Expanded(
          child: _summaryCard(
              'Total Cost', '₹${total.toStringAsFixed(2)}', Colors.green),
        ),
      ],
    );
  }

  Widget _buildListView() {
    if (materials.isEmpty) {
      return const Center(child: Text('No materials added yet'));
    }
    return ListView.builder(
      itemCount: materials.length,
      itemBuilder: (context, index) {
        final material = materials[index];
        final projectName = projects.firstWhere(
              (p) => p['id'].toString() == material['project_id']?.toString(),
              orElse: () => {'project_name': 'No Project'},
            )['project_name'] ??
            'No Project';
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            title: Text(material['name'] ?? 'Unknown'),
            subtitle: Text(
              '${material['quantity']} ${material['unit']} @ ₹${material['price_per_unit']}/unit = ₹${material['total_cost']} | Project: $projectName',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    _startEdit(material);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteMaterial(material['id'].toString()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _textField(
    TextEditingController controller,
    String label, {
    bool isNumber = false,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: TextField(
          controller: controller,
          keyboardType: isNumber
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget _priceField() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: TextField(
          controller: _priceController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Price per Unit (₹)',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _calculateTotal(),
        ),
      ),
    );
  }

  Widget _summaryCard(String title, String value, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
