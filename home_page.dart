import 'package:flutter/material.dart';
import 'labour_page.dart';
import 'attendance_page.dart';
import 'attendance_report_page.dart';
import 'projects_page.dart';
import 'login_page.dart';
import 'financial_page.dart';
import 'materials_page.dart';
//import 'stock_management_page.dart';

class HomePage extends StatefulWidget {
  final String? username;
  // const HomePage({Key? key, this.username, required role}) : super(key: key);
  final String? role;
  const HomePage({Key? key, this.username, this.role}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // recent activity text; blank initially
  String recentActivity = "";

  // current page area; default dashboard
  Widget currentPage = Container();

  @override
  void initState() {
    super.initState();
    currentPage = _buildDashboard();
  }

  Future<void> _openLabourPage() async {
    // Open LabourPage and wait for a returned activity message (if any)
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LabourPage()),
    );

    if (result != null && result is String && result.isNotEmpty) {
      setState(() {
        recentActivity = result; // show message in Recent Activities
        currentPage =
            _buildDashboard(); // refresh dashboard view to show updated activity
      });
    }
  }

  void _openAttendancePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AttendancePage()),
    );
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }

  void _openProjectsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProjectsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // --- Sidebar (unchanged style) ---
          Container(
            width: 220,
            color: Colors.blueGrey.shade900,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "CiviDesk",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildSidebarItem(Icons.dashboard, "Dashboard", () {
                  setState(() {
                    currentPage = _buildDashboard();
                  });
                }),
                _buildSidebarItem(Icons.people, "Labour", () {
                  _openLabourPage();
                }),
                _buildSidebarItem(Icons.fact_check, "Attendance", () {
                  _openAttendancePage();
                }),
                _buildSidebarItem(Icons.assessment, "Attendance Report", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AttendanceReportPage()),
                  );
                }),
                _buildSidebarItem(Icons.work, "Projects", () {
                  _openProjectsPage();

                  // placeholder - keep design
                }),
                _buildSidebarItem(Icons.check_circle_outline, "Financials", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FinancialPage()),
                  );
                }),
                _buildSidebarItem(Icons.assignment, "Materials", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MaterialsPage()),
                  );
                }),
                /* Temporarily hidden Stock Management
                _buildSidebarItem(Icons.inventory_2, "Stock Management", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => StockManagementPage()),
                  );
                }),
                */
              ],
            ),
          ),

          // --- Main Content ---
          Expanded(
            child: Column(
              children: [
                // Topbar
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  color: Colors.grey.shade100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Dashboard",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.person, color: Colors.blueGrey),
                        onSelected: (value) {
                          if (value == "logout") _logout();
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: "user",
                            child: Text(
                              "Logged in as ${widget.username ?? 'User'}",
                            ),
                          ),
                          const PopupMenuItem(
                            value: "logout",
                            child: Text("Logout"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Dynamic content area
                Expanded(child: currentPage),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }

  // Dashboard with Recent Activities on top and modules below
  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent Activities + Notifications row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _buildInfoCard(
                  "Recent Activities",
                  // If recentActivity is blank, show nothing (as requested)
                  recentActivity.isEmpty
                      ? "No recent activity"
                      : recentActivity,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoCard("Notifications", "No new notifications"),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Modules Grid (kept original look)
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildDashboardCard("Projects", Icons.work, onTap: () {}),
              _buildDashboardCard(
                "Financials",
                Icons.currency_rupee,
                onTap: () {},
              ),
              _buildDashboardCard(
                "Labour",
                Icons.people,
                onTap: _openLabourPage,
              ),
              _buildDashboardCard("Materials", Icons.assignment, onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MaterialsPage()),
                );
              }),
              _buildDashboardCard(
                "Quotation",
                Icons.request_quote,
                onTap: () {},
              ),
              _buildDashboardCard("Reports", Icons.bar_chart, onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String content) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(content, style: TextStyle(color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    String title,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: Colors.blueGrey),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
