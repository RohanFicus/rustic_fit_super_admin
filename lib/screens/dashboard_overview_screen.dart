import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class DashboardOverviewScreen extends StatefulWidget {
  final Function(String) onMenuSelected;

  const DashboardOverviewScreen({super.key, required this.onMenuSelected});

  @override
  State<DashboardOverviewScreen> createState() =>
      _DashboardOverviewScreenState();
}

class _DashboardOverviewScreenState extends State<DashboardOverviewScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _staggerController;
  bool _isLoading = true;

  int _totalOrders = 0;
  double _totalRevenue = 0.0;
  int _activeTailors = 0;
  int _newCustomers = 0;
  List<Map<String, dynamic>> _recentOrders = [];

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _loadDashboardData();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    try {
      final orders = await SupabaseService().getOrders();
      final tailors = await SupabaseService().getTailors();
      final customers = await SupabaseService().getCustomers();

      double revenue = 0.0;
      for (var order in orders) {
        final amt = double.tryParse(order['amount']?.toString() ?? '0') ?? 0.0;
        revenue += amt;
      }

      final activeTailorCount =
          tailors.where((t) => t['status']?.toString() == 'Active').length;

      setState(() {
        _totalOrders = orders.length;
        _totalRevenue = revenue;
        _activeTailors = activeTailorCount;
        _newCustomers = customers.length;
        // Take top 5 orders
        _recentOrders = orders.take(5).toList();
        _isLoading = false;
      });

      _staggerController.forward();
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load dashboard data: $e'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  List<Map<String, dynamic>> get _metrics => [
        {
          'title': 'Total Orders',
          'value': '$_totalOrders',
          'icon': Icons.shopping_bag_rounded,
          'color': Colors.blue,
          'trend': '+12%',
        },
        {
          'title': 'Revenue',
          'value': '₹${_totalRevenue.toStringAsFixed(0)}',
          'icon': Icons.account_balance_wallet_rounded,
          'color': Colors.green,
          'trend': '+8%',
        },
        {
          'title': 'Active Tailors',
          'value': '$_activeTailors',
          'icon': Icons.content_cut_rounded,
          'color': Colors.orange,
          'trend': '0%',
        },
        {
          'title': 'New Customers',
          'value': '$_newCustomers',
          'icon': Icons.group_rounded,
          'color': Colors.purple,
          'trend': '+24%',
        },
      ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, Admin',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Dashboard Overview',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width < 600
                  ? double.infinity
                  : null,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download_rounded),
                label: const Text('Download Report'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A1B9A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),

        _isLoading
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(50.0),
                  child: CircularProgressIndicator(color: Color(0xFF6A1B9A)),
                ),
              )
            : Column(
                children: [
                  // Metrics Grid
                  LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = constraints.maxWidth > 1400
                          ? 4
                          : (constraints.maxWidth > 1100
                              ? 2
                              : (constraints.maxWidth > 600 ? 2 : 1));

                      double childAspectRatio = constraints.maxWidth > 1400
                          ? 2.2
                          : (constraints.maxWidth > 600 ? 2.5 : 3.5);

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: childAspectRatio,
                        ),
                        itemCount: _metrics.length,
                        itemBuilder: (context, index) {
                          return _buildMetricCard(index);
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Recent Orders Table
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6A1B9A),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Recent Orders',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            TextButton.icon(
                              onPressed: () => widget.onMenuSelected('Orders'),
                              icon: const Icon(Icons.arrow_forward_rounded,
                                  size: 18),
                              label: const Text('View All Activities'),
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF6A1B9A),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _recentOrders.isEmpty
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(30.0),
                                  child: Text('No recent orders.'),
                                ),
                              )
                            : LayoutBuilder(
                                builder: (context, constraints) {
                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minWidth: constraints.maxWidth,
                                      ),
                                      child: DataTable(
                                        headingRowHeight: 56,
                                        dataRowHeight: 70,
                                        horizontalMargin: 20,
                                        columnSpacing: 40,
                                        headingRowColor:
                                            MaterialStateProperty.all(
                                          Colors.grey[50],
                                        ),
                                        columns: const [
                                          DataColumn(
                                            label: Text(
                                              'ORDER ID',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'CUSTOMER',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'ITEM DETAILS',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'STATUS',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'AMOUNT',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'ACTION',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ],
                                        rows: _recentOrders
                                            .map((order) =>
                                                _buildOrderRow(order))
                                            .toList(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                ],
              ),
      ],
    );
  }

  Widget _buildMetricCard(int index) {
    final metric = _metrics[index];
    final animation = CurvedAnimation(
      parent: _staggerController,
      curve: Interval(
        (index / _metrics.length) * 0.5,
        ((index + 1) / _metrics.length) * 0.5 + 0.5,
        curve: Curves.easeOutBack,
      ),
    );

    return ScaleTransition(
      scale: animation,
      child: FadeTransition(
        opacity: animation,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: metric['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      metric['icon'],
                      color: metric['color'],
                      size: 20,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: metric['trend'].contains('+')
                          ? Colors.green[50]
                          : Colors.grey[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          metric['trend'].contains('+')
                              ? Icons.trending_up_rounded
                              : Icons.trending_flat_rounded,
                          size: 12,
                          color: metric['trend'].contains('+')
                              ? Colors.green
                              : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          metric['trend'],
                          style: TextStyle(
                            color: metric['trend'].contains('+')
                               ? Colors.green
                                : Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                metric['value'],
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                metric['title'],
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DataRow _buildOrderRow(Map<String, dynamic> order) {
    Color statusColor;
    final status = order['status']?.toString() ?? 'New';
    switch (status) {
      case 'New':
        statusColor = Colors.blue;
        break;
      case 'Assigned':
        statusColor = Colors.orange;
        break;
      case 'In Tailoring':
        statusColor = Colors.purple;
        break;
      case 'Ready':
        statusColor = Colors.teal;
        break;
      case 'Delivered':
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.grey;
    }

    final orderNumber = order['order_number'] ?? '#ORD-0000';
    final rawDate = order['created_at']?.toString() ?? '';
    final dateStr = rawDate.length >= 10 ? rawDate.substring(0, 10) : 'Recent';

    final customerObj = order['customers'];
    final customerName = customerObj is Map
        ? (customerObj['name']?.toString() ?? 'Unknown')
        : 'Unknown';

    final itemDetails = order['item_details']?.toString() ?? '';
    final amount = order['amount']?.toString() ?? '0';

    return DataRow(
      cells: [
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                orderNumber,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A1B9A),
                ),
              ),
              Text(
                dateStr,
                style: TextStyle(fontSize: 11, color: Colors.grey[400]),
              ),
            ],
          ),
        ),
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: Colors.grey[100],
                child: Text(
                  customerName.isNotEmpty ? customerName[0] : 'U',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                customerName,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        DataCell(Text(itemDetails)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        DataCell(
          Text('₹$amount', style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataCell(
          IconButton(
            icon: const Icon(
              Icons.open_in_new_rounded,
              size: 20,
              color: Colors.grey,
            ),
            onPressed: () {},
            tooltip: 'View Details',
          ),
        ),
      ],
    );
  }
}
