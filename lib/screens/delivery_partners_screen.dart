import 'package:flutter/material.dart';

class DeliveryPartnersScreen extends StatefulWidget {
  const DeliveryPartnersScreen({super.key});

  @override
  State<DeliveryPartnersScreen> createState() => _DeliveryPartnersScreenState();
}

class _DeliveryPartnersScreenState extends State<DeliveryPartnersScreen> {
  final List<Map<String, dynamic>> _partners = [
    {
      'id': 'DP001',
      'name': 'Suresh Kumar',
      'vehicle': 'Hero Splendor (Bike)',
      'number': 'DL 3S AB 1234',
      'phone': '+91 9876543210',
      'address': 'H.No 123, Sector 15, Rohini, Delhi',
      'status': 'On Duty',
      'orders_today': 8,
      'rating': 4.8,
      'isBlocked': false,
    },
    {
      'id': 'DP002',
      'name': 'Mohit Verma',
      'vehicle': 'Honda Activa (Scooter)',
      'number': 'DL 8C XY 5678',
      'phone': '+91 9876543211',
      'address': 'Plot 45, Gali No 2, Laxmi Nagar, Delhi',
      'status': 'Off Duty',
      'orders_today': 0,
      'rating': 4.5,
      'isBlocked': false,
    },
    {
      'id': 'DP003',
      'name': 'Rahul Yadav',
      'vehicle': 'Mahindra Treo (Auto)',
      'number': 'DL 1G PQ 9012',
      'phone': '+91 9876543212',
      'address': 'B-42, Janakpuri, New Delhi',
      'status': 'On Duty',
      'orders_today': 5,
      'rating': 4.9,
      'isBlocked': true,
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
                  'Delivery Partners',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                Text(
                  'Manage your logistics fleet and tracking',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () => _showAddPartnerDialog(context),
              icon: const Icon(Icons.person_add_alt_1_rounded, size: 20),
              label: const Text('Add Delivery Partner'),
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
                              'PARTNER INFO',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'VEHICLE DETAILS',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'CONTACT',
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
                              'PERFORMANCE',
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
                        rows: _partners
                            .map((partner) => _buildPartnerRow(partner))
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
    );
  }

  DataRow _buildPartnerRow(Map<String, dynamic> partner) {
    bool isOnDuty = partner['status'] == 'On Duty';
    bool isBlocked = partner['isBlocked'];

    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: isBlocked
                    ? Colors.red[50]
                    : const Color(0xFFF3E5F5),
                child: Text(
                  partner['name'][0],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isBlocked ? Colors.red : const Color(0xFF6A1B9A),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    partner['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    partner['id'],
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
              Text(
                partner['vehicle'],
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                partner['number'],
                style: TextStyle(color: Colors.grey[500], fontSize: 11),
              ),
            ],
          ),
        ),
        DataCell(Text(partner['phone'], style: const TextStyle(fontSize: 13))),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isBlocked
                  ? Colors.red[50]
                  : (isOnDuty ? Colors.green[50] : Colors.grey[100]),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isBlocked ? 'BLOCKED' : partner['status'].toUpperCase(),
              style: TextStyle(
                color: isBlocked
                    ? Colors.red
                    : (isOnDuty ? Colors.green : Colors.grey[600]),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        DataCell(
          Row(
            children: [
              const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text(
                partner['rating'].toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(${partner['orders_today']} today)',
                style: TextStyle(color: Colors.grey[500], fontSize: 11),
              ),
            ],
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
                onPressed: () => _showPartnerDetailsDialog(context, partner),
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
                  setState(() => partner['isBlocked'] = !isBlocked);
                },
                tooltip: isBlocked ? 'Unblock' : 'Block',
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAddPartnerDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, anim1, anim2) => Container(),
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: CurvedAnimation(
            parent: anim1,
            curve: Curves.easeOutBack,
          ).value.clamp(0.8, 1.0),
          child: FadeTransition(
            opacity: anim1,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: EdgeInsets.zero,
              content: Container(
                width: 600,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: Color(0xFF6A1B9A),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.local_shipping_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                          SizedBox(width: 16),
                          Text(
                            'Register Delivery Partner',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildDialogField(
                                  Icons.person_outline_rounded,
                                  'Full Name',
                                  'Name',
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildDialogField(
                                  Icons.phone_iphone_rounded,
                                  'Phone Number',
                                  '+91',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildDialogField(
                            Icons.location_on_outlined,
                            'Residence Address',
                            'Full Address',
                          ),
                          const SizedBox(height: 24),
                          const Row(
                            children: [
                              Expanded(child: Divider()),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'VEHICLE INFORMATION',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: _buildDialogField(
                                  Icons.directions_bike_rounded,
                                  'Vehicle Type',
                                  'e.g. Bike',
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildDialogField(
                                  Icons.badge_outlined,
                                  'Registration No.',
                                  'DL XX XXXX',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF6A1B9A),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Add Partner',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showPartnerDetailsDialog(
    BuildContext context,
    Map<String, dynamic> partner,
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
              width: 450,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: partner['isBlocked']
                        ? Colors.red[50]
                        : const Color(0xFFF3E5F5),
                    child: Text(
                      partner['name'][0],
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: partner['isBlocked']
                            ? Colors.red
                            : const Color(0xFF6A1B9A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    partner['name'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    partner['id'],
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _detailRow(Icons.phone, 'Contact', partner['phone']),
                        _detailRow(
                          Icons.location_on,
                          'Address',
                          partner['address'],
                        ),
                        _detailRow(
                          Icons.directions_car,
                          'Vehicle',
                          '${partner['vehicle']} (${partner['number']})',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statItem(
                        'Orders Today',
                        partner['orders_today'].toString(),
                      ),
                      _statItem('Rating', '⭐ ${partner['rating']}'),
                      _statItem('Total Jobs', '452'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A1B9A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Close Details'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF6A1B9A)),
          const SizedBox(width: 12),
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
                    fontSize: 13,
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

  Widget _buildDialogField(IconData icon, String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            prefixIcon: Icon(
              icon,
              size: 18,
              color: const Color(0xFF6A1B9A).withOpacity(0.5),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF6A1B9A),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
