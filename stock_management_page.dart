import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StockManagementPage extends StatefulWidget {
  const StockManagementPage({Key? key}) : super(key: key);

  @override
  State<StockManagementPage> createState() => _StockManagementPageState();
}

class _StockManagementPageState extends State<StockManagementPage> {
  final String baseUrl = "http://localhost/cividesk_api";
  List<dynamic> materials = [];
  List<dynamic> projects = [];
  bool loading = true;
  String selectedMaterialId = '';
  String selectedProjectId = '';
  double qty = 0.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => loading = true);
    await Future.wait([_loadMaterials(), _loadProjects()]);
    setState(() => loading = false);
  }

  Future<void> _loadMaterials() async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/get_materials.php"));
      if (res.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('HTTP ${res.statusCode}: ${res.body.substring(0, 100)}')));
        return;
      }
      if (!res.body.trim().startsWith('{')) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Non-JSON: ${res.body.substring(0, 100)}')));
        return;
      }
      final body = json.decode(res.body);
      if (body['status'] == 'success') {
        setState(() => materials = body['data'] ?? []);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('API Error: ${body['message']}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Materials load error: $e')));
    }
  }

  Future<void> _loadProjects() async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/get_projects.php"));
      if (res.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('HTTP ${res.statusCode}: ${res.body.substring(0, 100)}')));
        return;
      }
      if (!res.body.trim().startsWith('{')) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Non-JSON: ${res.body.substring(0, 100)}')));
        return;
      }
      final body = json.decode(res.body);
      if (body['status'] == 'success') {
        setState(() => projects = body['data'] ?? []);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('API Error: ${body['message']}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Projects load error: $e')));
    }
  }

  Future<void> _allocateStock() async {
    if (selectedMaterialId.isEmpty || selectedProjectId.isEmpty || qty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Select material, project and qty')));
      return;
    }

    try {
      final res = await http.post(
        Uri.parse("$baseUrl/allocate_material_stock.php"),
        body: {
          'material_id': selectedMaterialId,
          'project_id': selectedProjectId,
          'qty': qty.toString(),
        },
      );

      String cleanBody = res.body.trim();
      final body = json.decode(cleanBody);
      if (body['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(body['message'] ?? 'Allocated')));
        _loadData();
        setState(() {
          selectedMaterialId = '';
          selectedProjectId = '';
          qty = 0.0;
        });
      } else {
        throw Exception(body['message'] ?? 'Server error');
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Allocate error: $e')));
    }
  }

  Future<void> _loadStockStatus() async {
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Management'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStockStatus,
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Allocate Stock',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value:
                        selectedMaterialId.isEmpty ? null : selectedMaterialId,
                    decoration: const InputDecoration(
                      labelText: 'Material',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem(
                          value: null, child: Text('Select Material')),
                      ...materials.map((m) => DropdownMenuItem(
                            value: m['id'].toString(),
                            child: Text(m['name'] ?? ''),
                          )),
                    ],
                    onChanged: (value) {
                      setState(() => selectedMaterialId = value ?? '');
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedProjectId.isEmpty ? null : selectedProjectId,
                    decoration: const InputDecoration(
                      labelText: 'Project',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem(
                          value: null, child: Text('Select Project')),
                      ...projects.map((p) => DropdownMenuItem(
                            value: p['id'].toString(),
                            child: Text(
                                p['project_name'] ?? p['name'] ?? 'Unknown'),
                          )),
                    ],
                    onChanged: (value) {
                      setState(() => selectedProjectId = value ?? '');
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      qty = double.tryParse(value) ?? 0.0;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _allocateStock,
                    icon: const Icon(Icons.add),
                    label: const Text('Allocate Stock'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Expanded(
                    child: _buildStatusList(),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatusList() {
    return FutureBuilder(
      future: http.get(Uri.parse("$baseUrl/get_material_stock_status.php")),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text('Status load error'));
        }
        final res = snapshot.data as http.Response;
        if (res.statusCode != 200 || !res.body.trim().startsWith('{')) {
          return const Center(child: Text('Server error'));
        }
        final body = json.decode(res.body);
        final statusList = body['data'] ?? [];
        if (statusList.isEmpty) {
          return const Center(child: Text('No stock status'));
        }
        return ListView.builder(
          itemCount: statusList.length,
          itemBuilder: (context, index) {
            final item = statusList[index];
            return Card(
              child: ListTile(
                title: Text(item['name'] ?? 'Unknown'),
                subtitle: Text(
                    'Total: ${item['total_stock']} | Remaining: ${item['remaining_stock']}'),
                trailing: Text('₹${item['total_cost']}'),
              ),
            );
          },
        );
      },
    );
  }
}
