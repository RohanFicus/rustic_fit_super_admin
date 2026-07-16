import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = [
    'All',
    'New',
    'Assigned',
    'In Tailoring',
    'Ready',
    'Delivered',
  ];

  List<Map<String, dynamic>> _allOrders = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadOrders();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    try {
      final data = await SupabaseService().getOrders();
      setState(() {
        _allOrders = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load orders: $e'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter and search
    List<Map<String, dynamic>> filteredOrders = _allOrders.where((order) {
      final statusMatch = _selectedFilter == 'All' ||
          (order['status']?.toString().toLowerCase() ==
              _selectedFilter.toLowerCase());

      final customerObj = order['customers'];
      final customerName = customerObj is Map
          ? (customerObj['name']?.toString().toLowerCase() ?? '')
          : '';
      final orderNumber = order['order_number']?.toString().toLowerCase() ?? '';
      final itemDetails = order['item_details']?.toString().toLowerCase() ?? '';

      final searchMatch = _searchQuery.isEmpty ||
          customerName.contains(_searchQuery) ||
          orderNumber.contains(_searchQuery) ||
          itemDetails.contains(_searchQuery);

      return statusMatch && searchMatch;
    }).toList();

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
                const Text(
                  'Order Management',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                Text(
                  'Total ${filteredOrders.length} orders found',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildSearchBar(context),
                SizedBox(
                  width: MediaQuery.of(context).size.width < 600
                      ? double.infinity
                      : null,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add_rounded, size: 20),
                    label: const Text('Create Order'),
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
          ],
        ),
        const SizedBox(height: 25),

        // Filter & Summary Stats
        Wrap(
          spacing: 16,
          runSpacing: 16,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width < 1100
                  ? (MediaQuery.of(context).size.width < 600
                      ? double.infinity
                      : 400)
                  : 600,
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: FilterChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) =>
                          setState(() => _selectedFilter = filter),
                      backgroundColor: Colors.white,
                      selectedColor: const Color(0xFF6A1B9A).withOpacity(0.1),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? const Color(0xFF6A1B9A)
                            : Colors.grey[700],
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: isSelected
                              ? const Color(0xFF6A1B9A)
                              : Colors.grey[200]!,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.filter_list_rounded, size: 18, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    'Advanced Filters',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 25),

        // Orders Table
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _isLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(50.0),
                        child:
                            CircularProgressIndicator(color: Color(0xFF6A1B9A)),
                      ),
                    )
                  : filteredOrders.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(50.0),
                            child: Text('No orders found.'),
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
                                  dataRowHeight: 72,
                                  horizontalMargin: 24,
                                  columnSpacing: 24,
                                  headingRowColor: MaterialStateProperty.all(
                                    Colors.grey[50],
                                  ),
                                  columns: const [
                                    DataColumn(
                                      label: Text(
                                        'ORDER INFO',
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
                                        'ASSIGNED TAILOR',
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
                                        'ACTIONS',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: filteredOrders
                                      .map((order) => _buildOrderRow(order))
                                      .toList(),
                                ),
                              ),
                            );
                          },
                        ),
              // Pagination Placeholder
              Padding(
                padding: const EdgeInsets.all(20),
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Showing 1 to ${filteredOrders.length} of ${filteredOrders.length} entries',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildPageButton(Icons.chevron_left_rounded, false),
                        const SizedBox(width: 8),
                        _buildPageNumber(1, true),
                        const SizedBox(width: 8),
                        _buildPageButton(Icons.chevron_right_rounded, true),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width < 600 ? double.infinity : 320,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: 'Search by Order ID or Name...',
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
          prefixIcon: Icon(Icons.search_rounded, color: Colors.grey, size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
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

    final tailorObj = order['tailors'];
    final tailorName = tailorObj is Map
        ? (tailorObj['name']?.toString() ?? 'Unassigned')
        : 'Unassigned';

    final priority = order['priority']?.toString() ?? 'Medium';
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
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: const Color(0xFFF3E5F5),
                child: Text(
                  customerName.isNotEmpty ? customerName[0] : 'U',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A1B9A),
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
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                itemDetails,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (priority == 'High')
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'PRIORITY',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
        DataCell(
          tailorName == 'Unassigned'
              ? TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Assign Now',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Row(
                  children: [
                    const Icon(
                      Icons.person_outline_rounded,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(tailorName, style: const TextStyle(fontSize: 13)),
                  ],
                ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
          Text(
            '₹$amount',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.visibility_outlined,
                  size: 20,
                  color: Colors.grey,
                ),
                onPressed: () {},
                tooltip: 'View',
              ),
              IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 20,
                  color: Colors.grey,
                ),
                onPressed: () {},
                tooltip: 'Edit',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPageButton(IconData icon, bool enabled) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Icon(
        icon,
        size: 18,
        color: enabled ? Colors.black87 : Colors.grey[300],
      ),
    );
  }

  Widget _buildPageNumber(int number, bool isSelected) {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF6A1B9A) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? const Color(0xFF6A1B9A) : Colors.grey[200]!,
        ),
      ),
      child: Text(
        '$number',
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}
