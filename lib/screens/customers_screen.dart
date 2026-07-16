import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  List<Map<String, dynamic>> _customers = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadCustomers();
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

  Future<void> _loadCustomers() async {
    setState(() => _isLoading = true);
    try {
      final data = await SupabaseService().getCustomers();
      setState(() {
        _customers = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load customers: $e'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _toggleBlockStatus(
      Map<String, dynamic> customer, bool isBlocked) async {
    try {
      await SupabaseService().updateCustomer(customer['id'].toString(), {
        'is_blocked': isBlocked,
      });
      _loadCustomers();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update status: $e'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _deleteCustomer(Map<String, dynamic> customer) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Customer Profile?'),
        content: Text(
            'Are you sure you want to delete profile for "${customer['name']}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await SupabaseService().deleteCustomer(customer['id'].toString());
                _loadCustomers();
                if (mounted) Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to delete customer: $e'),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Search filter
    List<Map<String, dynamic>> filteredCustomers = _customers.where((cust) {
      final name = cust['name']?.toString().toLowerCase() ?? '';
      final email = cust['email']?.toString().toLowerCase() ?? '';
      final phone = cust['phone']?.toString().toLowerCase() ?? '';
      return _searchQuery.isEmpty ||
          name.contains(_searchQuery) ||
          email.contains(_searchQuery) ||
          phone.contains(_searchQuery);
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
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width < 600
                      ? double.infinity
                      : 320,
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
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search by Name, Email or Phone...',
                      hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                      prefixIcon: Icon(Icons.search_rounded,
                          color: Colors.grey, size: 18),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 11),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width < 600
                      ? double.infinity
                      : null,
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddCustomerDialog(context),
                    icon: const Icon(Icons.person_add_rounded, size: 20),
                    label: const Text('Add Customer'),
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
        const SizedBox(height: 30),

        // Customer Table
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 15,
                offset: const Offset(0, 8),
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
                  : filteredCustomers.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(50.0),
                            child: Text('No customers found.'),
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
                                  dataRowHeight: 76,
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
                                        'CONTACT INFO',
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
                                  rows: filteredCustomers
                                      .map((cust) => _buildCustomerRow(cust))
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

  DataRow _buildCustomerRow(Map<String, dynamic> customer) {
    bool isBlocked = customer['is_blocked'] ?? false;
    final name = customer['name'] ?? '';
    final email = customer['email'] ?? 'N/A';
    final phone = customer['phone'] ?? 'N/A';
    final rawDate = customer['created_at']?.toString() ?? '';
    final joinedDate = rawDate.length >= 10 ? rawDate.substring(0, 10) : 'Recent';

    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor:
                    isBlocked ? Colors.red[50] : const Color(0xFFF3E5F5),
                child: Text(
                  name.isNotEmpty ? name[0] : 'U',
                  style: TextStyle(
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
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Joined: $joinedDate',
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
                email,
                style: const TextStyle(fontSize: 13),
              ),
              Text(
                phone,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
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
                onPressed: () => _toggleBlockStatus(customer, !isBlocked),
                tooltip: isBlocked ? 'Unblock' : 'Block',
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  size: 20,
                  color: Colors.redAccent,
                ),
                onPressed: () => _deleteCustomer(customer),
                tooltip: 'Delete',
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showCustomerDetailsDialog(
      BuildContext context, Map<String, dynamic> customer) {
    bool isBlocked = customer['is_blocked'] ?? false;
    final name = customer['name'] ?? '';
    final email = customer['email'] ?? 'N/A';
    final phone = customer['phone'] ?? 'N/A';
    final address = customer['address'] ?? 'N/A';
    final rawDate = customer['created_at']?.toString() ?? '';
    final joinedDate = rawDate.length >= 10 ? rawDate.substring(0, 10) : 'Recent';

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
            content: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              constraints: const BoxConstraints(maxWidth: 500),
              child: SingleChildScrollView(
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
                              backgroundColor: isBlocked
                                  ? Colors.red[50]
                                  : const Color(0xFFE3F2FD),
                              child: Text(
                                name.isNotEmpty ? name[0] : 'U',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isBlocked ? Colors.red : Colors.blue[700],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          _detailItem(
                            Icons.alternate_email_rounded,
                            'Email Address',
                            email,
                          ),
                          _detailItem(
                            Icons.phone_android_rounded,
                            'Phone Number',
                            phone,
                          ),
                          _detailItem(
                            Icons.location_on_outlined,
                            'Primary Address',
                            address,
                          ),
                          _detailItem(
                            Icons.calendar_today_rounded,
                            'Registration Date',
                            joinedDate,
                          ),
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
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

  void _showAddCustomerDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final countryCodeController = TextEditingController(text: '+91');
    final phoneController = TextEditingController();
    final addressController = TextEditingController();

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
                width: MediaQuery.of(context).size.width * 0.9,
                constraints: const BoxConstraints(maxWidth: 500),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
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
                              Icons.person_add_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                            SizedBox(width: 16),
                            Text(
                              'Add New Customer',
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
                              'e.g. Rahul Sharma',
                              nameController,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 110,
                                  child: _buildDialogField(
                                    Icons.public_rounded,
                                    'Code',
                                    '+91',
                                    countryCodeController,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildDialogField(
                                    Icons.phone_iphone_rounded,
                                    'Phone Number',
                                    'XXXXX XXXXX',
                                    phoneController,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildDialogField(
                              Icons.location_on_outlined,
                              'Primary Address',
                              'Full Address',
                              addressController,
                            ),
                            const SizedBox(height: 16),
                            _buildDialogField(
                              Icons.alternate_email_rounded,
                              'Email Address (Credentials)',
                              'customer@example.com',
                              emailController,
                            ),
                            const SizedBox(height: 16),
                            _buildDialogField(
                              Icons.lock_outline_rounded,
                              'Password (Credentials)',
                              '••••••••',
                              passwordController,
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
                                  onPressed: () async {
                                    if (nameController.text.isNotEmpty &&
                                        emailController.text.isNotEmpty &&
                                        passwordController.text.isNotEmpty) {
                                      try {
                                        // 1. Register Auth credentials
                                        final uid = await SupabaseService()
                                            .registerUserCredentials(
                                          emailController.text.trim(),
                                          passwordController.text,
                                        );

                                        // 2. Create customer profile linked via uid
                                        final payload = {
                                          'id': uid,
                                          'name': nameController.text.trim(),
                                          'email': emailController.text.trim(),
                                          'phone': '${countryCodeController.text.trim()}${phoneController.text.trim()}',
                                          'address': addressController.text.trim(),
                                          'is_blocked': false,
                                        };
                                        await SupabaseService()
                                            .createCustomer(payload);
                                        _loadCustomers();
                                        if (mounted) Navigator.pop(context);
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Failed to register customer credentials: $e'),
                                            backgroundColor: Colors.redAccent,
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Name, Email and Password are required.'),
                                          backgroundColor: Colors.orangeAccent,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    }
                                  },
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
                                    'Register Customer',
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
          ),
        );
      },
    );
  }

  Widget _buildDialogField(
      IconData icon, String label, String hint, TextEditingController ctrl) {
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
          controller: ctrl,
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
