import 'package:flutter/material.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final List<Map<String, dynamic>> _customers = [
    {
      'id': 'CUST-1001',
      'name': 'Rahul Sharma',
      'email': 'rahul.s@example.com',
      'phone': '+91 9988776655',
      'address': 'D-45, 2nd Floor, Hauz Khas, New Delhi',
      'orders': 12,
      'spent': '₹42,500',
      'joined': '12 Jan 2023',
      'isBlocked': false,
    },
    {
      'id': 'CUST-1002',
      'name': 'Priya Singh',
      'email': 'priya.singh@example.com',
      'phone': '+91 9988776644',
      'address': 'Flat 204, Sky High Apartments, Gurgaon',
      'orders': 5,
      'spent': '₹18,200',
      'joined': '05 Mar 2023',
      'isBlocked': false,
    },
    {
      'id': 'CUST-1003',
      'name': 'Amit Verma',
      'email': 'amit.v@example.com',
      'phone': '+91 9988776633',
      'address': 'Sector 15, Block B, Noida, UP',
      'orders': 2,
      'spent': '₹3,400',
      'joined': '20 Sep 2023',
      'isBlocked': true,
    },
    {
      'id': 'CUST-1004',
      'name': 'Anjali Gupta',
      'email': 'anjali.g@example.com',
      'phone': '+91 9988776622',
      'address': 'Greater Kailash II, New Delhi',
      'orders': 24,
      'spent': '₹85,000',
      'joined': '15 Nov 2022',
      'isBlocked': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
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
                  'Customer Directory',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                Text(
                  'Manage user profiles, activity and restrictions',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            Container(
              width: 350,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search by name, email or ID...',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    size: 20,
                    color: Color(0xFF6A1B9A),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),

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
                              'CONTACT DETAILS',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'ENGAGEMENT',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'TOTAL SPEND',
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
                              'ACTIONS',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                        rows: _customers
                            .map((customer) => _buildCustomerRow(customer))
                            .toList(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),
        // Pagination Placeholder
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Showing 1 to 4 of 1,240 customers',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            Row(
              children: [
                _buildPageButton(Icons.chevron_left_rounded, false),
                const SizedBox(width: 8),
                _buildPageButton(null, true, text: '1'),
                const SizedBox(width: 8),
                _buildPageButton(null, false, text: '2'),
                const SizedBox(width: 8),
                _buildPageButton(null, false, text: '3'),
                const SizedBox(width: 8),
                _buildPageButton(Icons.chevron_right_rounded, true),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPageButton(IconData? icon, bool isActive, {String? text}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF6A1B9A) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? const Color(0xFF6A1B9A) : Colors.grey[300]!,
        ),
      ),
      child: Center(
        child: icon != null
            ? Icon(
                icon,
                size: 18,
                color: isActive ? Colors.white : Colors.grey[600],
              )
            : Text(
                text!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.white : Colors.grey[600],
                ),
              ),
      ),
    );
  }

  DataRow _buildCustomerRow(Map<String, dynamic> customer) {
    bool isBlocked = customer['isBlocked'];

    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: isBlocked
                    ? Colors.red[50]
                    : const Color(0xFFE3F2FD),
                child: Text(
                  customer['name'][0],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isBlocked ? Colors.red : Colors.blue[700],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    customer['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    customer['id'],
                    style: TextStyle(color: Colors.grey[500], fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(customer['phone'], style: const TextStyle(fontSize: 13)),
              Text(
                customer['email'],
                style: TextStyle(color: Colors.grey[500], fontSize: 11),
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
                '${customer['orders']} Orders',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Since ${customer['joined']}',
                style: TextStyle(color: Colors.grey[500], fontSize: 11),
              ),
            ],
          ),
        ),
        DataCell(
          Text(
            customer['spent'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
              fontSize: 13,
            ),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isBlocked ? Colors.red[50] : Colors.green[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isBlocked ? 'BLOCKED' : 'ACTIVE',
              style: TextStyle(
                color: isBlocked ? Colors.red : Colors.green[700],
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
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
                onPressed: () => _showCustomerDetailsDialog(context, customer),
                tooltip: 'View Profile',
              ),
              IconButton(
                icon: Icon(
                  isBlocked
                      ? Icons.check_circle_outline_rounded
                      : Icons.block_flipped,
                  size: 20,
                  color: isBlocked ? Colors.green : Colors.redAccent,
                ),
                onPressed: () {
                  setState(() => customer['isBlocked'] = !isBlocked);
                },
                tooltip: isBlocked ? 'Unblock' : 'Block',
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showCustomerDetailsDialog(
    BuildContext context,
    Map<String, dynamic> customer,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) => Container(),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: SizedBox(
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 100,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF3E5F5),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: customer['isBlocked']
                                ? Colors.red[50]
                                : const Color(0xFFE3F2FD),
                            child: Text(
                              customer['name'][0],
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: customer['isBlocked']
                                    ? Colors.red
                                    : Colors.blue[700],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    customer['name'],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Customer ID: ${customer['id']}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        _detailItem(
                          Icons.alternate_email_rounded,
                          'Email Address',
                          customer['email'],
                        ),
                        _detailItem(
                          Icons.phone_android_rounded,
                          'Phone Number',
                          customer['phone'],
                        ),
                        _detailItem(
                          Icons.location_on_outlined,
                          'Primary Address',
                          customer['address'],
                        ),
                        _detailItem(
                          Icons.calendar_today_rounded,
                          'Registration Date',
                          customer['joined'],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _statItem(
                          'Total Orders',
                          customer['orders'].toString(),
                        ),
                        _statItem('LTV', customer['spent']),
                        _statItem('Reward Pts', '450'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Close'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6A1B9A),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('View Full History'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _detailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF6A1B9A)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF6A1B9A),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
