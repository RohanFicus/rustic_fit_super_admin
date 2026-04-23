import 'package:flutter/material.dart';

class TailorsScreen extends StatefulWidget {
  const TailorsScreen({super.key});

  @override
  State<TailorsScreen> createState() => _TailorsScreenState();
}

class _TailorsScreenState extends State<TailorsScreen> {
  final List<Map<String, dynamic>> _tailors = [
    {
      'id': 'T001',
      'name': 'Master Ji',
      'specialization': 'Men\'s Suits, Sherwanis',
      'experience': '15 Years',
      'active_orders': 4,
      'rating': 4.9,
      'status': 'Active',
      'image': 'https://i.pravatar.cc/150?u=T001',
    },
    {
      'id': 'T002',
      'name': 'Anita Devi',
      'specialization': 'Lehengas, Blouses',
      'experience': '8 Years',
      'active_orders': 2,
      'rating': 4.7,
      'status': 'Active',
      'image': 'https://i.pravatar.cc/150?u=T002',
    },
    {
      'id': 'T003',
      'name': 'Rajesh Tailor',
      'specialization': 'Shirts, Trousers',
      'experience': '10 Years',
      'active_orders': 0,
      'rating': 4.5,
      'status': 'On Leave',
      'image': 'https://i.pravatar.cc/150?u=T003',
    },
    {
      'id': 'T004',
      'name': 'Sunita Wilson',
      'specialization': 'Evening Gowns',
      'experience': '6 Years',
      'active_orders': 3,
      'rating': 4.8,
      'status': 'Active',
      'image': 'https://i.pravatar.cc/150?u=T004',
    },
    {
      'id': 'T005',
      'name': 'Vikram Singh',
      'specialization': 'Uniforms',
      'experience': '5 Years',
      'active_orders': 1,
      'rating': 4.2,
      'status': 'Active',
      'image': 'https://i.pravatar.cc/150?u=T005',
    },
    {
      'id': 'T004',
      'name': 'Sunita Wilson',
      'specialization': 'Evening Gowns',
      'experience': '6 Years',
      'active_orders': 3,
      'rating': 4.8,
      'status': 'Active',
      'image': 'https://i.pravatar.cc/150?u=T004',
    },
    {
      'id': 'T005',
      'name': 'Vikram Singh',
      'specialization': 'Uniforms',
      'experience': '5 Years',
      'active_orders': 1,
      'rating': 4.2,
      'status': 'Active',
      'image': 'https://i.pravatar.cc/150?u=T005',
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
                  'Tailor Management',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                Text(
                  'Manage your workshop team and capacity',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () => _showAddTailorDialog(context),
              icon: const Icon(Icons.person_add_rounded, size: 20),
              label: const Text('Add New Tailor'),
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
                ? 6
                : (constraints.maxWidth > 900 ? 4 : 3);
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.4,
              ),
              itemCount: _tailors.length,
              itemBuilder: (context, index) {
                return _buildTailorCard(_tailors[index]);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildTailorCard(Map<String, dynamic> tailor) {
    bool isActive = tailor['status'] == 'Active';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(tailor['image']),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tailor['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tailor['specialization'],
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive ? Colors.green[50] : Colors.orange[50],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tailor['status'].toUpperCase(),
                  style: TextStyle(
                    color: isActive ? Colors.green : Colors.orange,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Exp', tailor['experience']),
                _buildStatItem('Orders', tailor['active_orders'].toString()),
                _buildStatItem('Rating', '⭐ ${tailor['rating']}'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: Colors.grey[200]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Profile',
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: const Color(0xFF6A1B9A).withOpacity(0.1),
                    foregroundColor: const Color(0xFF6A1B9A),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Manage',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Color(0xFF333333),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showAddTailorDialog(BuildContext context) {
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
                width: 500,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
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
                          top: Radius.circular(20),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.person_add_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                          SizedBox(width: 16),
                          Text(
                            'Add New Tailor',
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
                          _buildDialogField(
                            Icons.person_outline_rounded,
                            'Full Name',
                            'e.g. Master Ji',
                          ),
                          const SizedBox(height: 16),
                          _buildDialogField(
                            Icons.star_outline_rounded,
                            'Specialization',
                            'e.g. Suits, Lehengas',
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildDialogField(
                                  Icons.history_rounded,
                                  'Experience',
                                  'Years',
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildDialogField(
                                  Icons.phone_iphone_rounded,
                                  'Phone',
                                  '+91',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'Discard',
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
                                  'Register Tailor',
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

  Widget _buildDialogField(IconData icon, String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
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
              size: 20,
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
