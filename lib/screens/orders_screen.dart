import 'package:flutter/material.dart';

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

  final List<Map<String, dynamic>> _allOrders = [
    {
      'id': '#ORD-7241',
      'customer': 'Rahul Sharma',
      'item': 'Slim Fit Suit',
      'status': 'In Tailoring',
      'amount': '₹8,500',
      'date': '24 Oct, 2023',
      'tailor': 'Master Ji',
      'priority': 'High',
    },
    {
      'id': '#ORD-7242',
      'customer': 'Priya Singh',
      'item': 'Silk Lehenga',
      'status': 'Assigned',
      'amount': '₹12,400',
      'date': '24 Oct, 2023',
      'tailor': 'Anita Devi',
      'priority': 'Medium',
    },
    {
      'id': '#ORD-7243',
      'customer': 'Amit Verma',
      'item': 'Cotton Shirt',
      'status': 'New',
      'amount': '₹1,200',
      'date': '25 Oct, 2023',
      'tailor': 'Unassigned',
      'priority': 'Low',
    },
    {
      'id': '#ORD-7244',
      'customer': 'Sanya Malhotra',
      'item': 'Evening Gown',
      'status': 'Ready',
      'amount': '₹15,000',
      'date': '23 Oct, 2023',
      'tailor': 'Rajesh Tailor',
      'priority': 'High',
    },
    {
      'id': '#ORD-7245',
      'customer': 'Vikram Rao',
      'item': 'Wedding Sherwani',
      'status': 'Delivered',
      'amount': '₹22,000',
      'date': '20 Oct, 2023',
      'tailor': 'Master Ji',
      'priority': 'Medium',
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredOrders = _selectedFilter == 'All'
        ? _allOrders
        : _allOrders
              .where((order) => order['status'] == _selectedFilter)
              .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            Row(
              children: [
                _buildSearchBar(),
                const SizedBox(width: 16),
                ElevatedButton.icon(
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
              ],
            ),
          ],
        ),
        const SizedBox(height: 25),

        // Filter & Summary Stats
        Row(
          children: [
            Expanded(
              child: SizedBox(
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
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: const Row(
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
              LayoutBuilder(
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Showing 1 to ${filteredOrders.length} of ${filteredOrders.length} entries',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    Row(
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

  Widget _buildSearchBar() {
    return Container(
      width: 320,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: const TextField(
        decoration: InputDecoration(
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
    switch (order['status']) {
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

    return DataRow(
      cells: [
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                order['id'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A1B9A),
                ),
              ),
              Text(
                order['date'],
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
                  order['customer'][0],
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A1B9A),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                order['customer'],
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
                order['item'],
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (order['priority'] == 'High')
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
          order['tailor'] == 'Unassigned'
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
                    Text(order['tailor'], style: const TextStyle(fontSize: 13)),
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
              order['status'],
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
            order['amount'],
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
