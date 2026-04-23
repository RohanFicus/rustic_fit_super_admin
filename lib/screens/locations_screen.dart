import 'package:flutter/material.dart';

class LocationsScreen extends StatefulWidget {
  const LocationsScreen({super.key});

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  final List<Map<String, dynamic>> _locations = [
    {
      'id': 'LOC001',
      'city': 'Mumbai',
      'state': 'Maharashtra',
      'status': 'Active',
      'isEnabled': true,
      'hubs': 12,
      'pincodes': 45,
    },
    {
      'id': 'LOC002',
      'city': 'Delhi',
      'state': 'Delhi NCR',
      'status': 'Active',
      'isEnabled': true,
      'hubs': 8,
      'pincodes': 32,
    },
    {
      'id': 'LOC003',
      'city': 'Bangalore',
      'state': 'Karnataka',
      'status': 'Active',
      'isEnabled': true,
      'hubs': 15,
      'pincodes': 58,
    },
    {
      'id': 'LOC004',
      'city': 'Pune',
      'state': 'Maharashtra',
      'status': 'Maintenance',
      'isEnabled': false,
      'hubs': 5,
      'pincodes': 14,
    },
    {
      'id': 'LOC005',
      'city': 'Hyderabad',
      'state': 'Telangana',
      'status': 'Active',
      'isEnabled': true,
      'hubs': 10,
      'pincodes': 28,
    },
    {
      'id': 'LOC006',
      'city': 'Chennai',
      'state': 'Tamil Nadu',
      'status': 'Active',
      'isEnabled': true,
      'hubs': 9,
      'pincodes': 35,
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
                  'Service Locations',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                Text(
                  'Manage city-wise operations and service availability',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () => _showLocationDialog(),
              icon: const Icon(Icons.add_location_alt_rounded, size: 20),
              label: const Text('Add Service City'),
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

        LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = constraints.maxWidth > 1400
                ? 4
                : (constraints.maxWidth > 900 ? 3 : 2);
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.6,
              ),
              itemCount: _locations.length,
              itemBuilder: (context, index) {
                return _buildLocationCard(_locations[index], index);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildLocationCard(Map<String, dynamic> location, int index) {
    bool isEnabled = location['isEnabled'];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isEnabled ? const Color(0xFFF3E5F5) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.location_city_rounded,
                  color: isEnabled ? const Color(0xFF6A1B9A) : Colors.grey,
                  size: 24,
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (val) {
                  if (val == 'edit')
                    _showLocationDialog(location: location, index: index);
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit Details', style: TextStyle(fontSize: 13)),
                  ),
                  const PopupMenuItem(
                    value: 'settings',
                    child: Text('Hub Settings', style: TextStyle(fontSize: 13)),
                  ),
                ],
                icon: const Icon(Icons.more_horiz, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            location['city'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: isEnabled ? const Color(0xFF333333) : Colors.grey[600],
            ),
          ),
          Text(
            location['state'],
            style: TextStyle(color: Colors.grey[500], fontSize: 13),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMiniStat('Hubs', location['hubs'].toString()),
                Container(width: 1, height: 16, color: Colors.grey[200]),
                _buildMiniStat('Pincodes', location['pincodes'].toString()),
                Container(width: 1, height: 16, color: Colors.grey[200]),
                _buildMiniStat(
                  'Status',
                  location['status'],
                  color: _getStatusColor(location['status']),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Accepting Orders',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 24,
                child: Switch(
                  value: isEnabled,
                  onChanged: (val) {
                    setState(() {
                      _locations[index]['isEnabled'] = val;
                      _locations[index]['status'] = val ? 'Active' : 'Disabled';
                    });
                  },
                  activeColor: const Color(0xFF6A1B9A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, {Color? color}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: color ?? const Color(0xFF333333),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[500],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Maintenance':
        return Colors.orange;
      case 'Disabled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showLocationDialog({Map<String, dynamic>? location, int? index}) {
    final isEditing = location != null;
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
                borderRadius: BorderRadius.circular(24),
              ),
              contentPadding: EdgeInsets.zero,
              content: Container(
                width: 500,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: Color(0xFF6A1B9A),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isEditing
                                ? Icons.edit_location_alt_rounded
                                : Icons.add_location_alt_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            isEditing
                                ? 'Modify Service City'
                                : 'Add New Service City',
                            style: const TextStyle(
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
                          _buildDialogField(
                            Icons.location_city_rounded,
                            'City Name',
                            'e.g. Hyderabad',
                          ),
                          const SizedBox(height: 16),
                          _buildDialogField(
                            Icons.map_rounded,
                            'State / Region',
                            'e.g. Telangana',
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildDialogField(
                                  Icons.hub_rounded,
                                  'Operational Hubs',
                                  'No. of hubs',
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Initial Status',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey[50],
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.grey[200]!,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.grey[200]!,
                                          ),
                                        ),
                                      ),
                                      value: isEditing
                                          ? location['status']
                                          : 'Active',
                                      items:
                                          ['Active', 'Maintenance', 'Inactive']
                                              .map(
                                                (s) => DropdownMenuItem(
                                                  value: s,
                                                  child: Text(
                                                    s,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                      onChanged: (v) {},
                                    ),
                                  ],
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
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  isEditing ? 'Save Changes' : 'Enable Service',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
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
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
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
