import 'package:flutter/material.dart';

import 'screens/categories_screen.dart';
import 'screens/customers_screen.dart';
import 'screens/dashboard_overview_screen.dart';
import 'screens/delivery_partners_screen.dart';
import 'screens/locations_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/products_screen.dart';
import 'screens/tailors_screen.dart';
import 'screens/transactions_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  String _selectedMenu = 'Dashboard';
  late AnimationController _contentAnimationController;

  final List<Map<String, dynamic>> _menuItems = [
    {'title': 'Dashboard', 'icon': Icons.dashboard_rounded},
    {'title': 'Orders', 'icon': Icons.shopping_bag_rounded},
    {'title': 'Tailors', 'icon': Icons.content_cut_rounded},
    {'title': 'Delivery Partners', 'icon': Icons.local_shipping_rounded},
    {'title': 'Customers', 'icon': Icons.group_rounded},
    {'title': 'Transactions', 'icon': Icons.account_balance_wallet_rounded},
    {'title': 'Categories', 'icon': Icons.category_rounded},
    {'title': 'Products', 'icon': Icons.inventory_2_rounded},
    {'title': 'Locations', 'icon': Icons.location_on_rounded},
  ];

  @override
  void initState() {
    super.initState();
    _contentAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _contentAnimationController.forward();
  }

  @override
  void dispose() {
    _contentAnimationController.dispose();
    super.dispose();
  }

  void _onMenuSelected(String title) {
    if (_selectedMenu == title) return;
    setState(() {
      _selectedMenu = title;
    });
    _contentAnimationController.reset();
    _contentAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(0xFF6A1B9A);
    const sidebarColor = Color(0xFF2D2D2D);

    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: sidebarColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(5, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 40,
                    horizontal: 20,
                  ),
                  child: Column(
                    children: [
                      Hero(
                        tag: 'logo',
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 60,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.admin_panel_settings,
                                color: themeColor,
                                size: 50,
                              ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'RUSCFIT ADMIN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white10, height: 1),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: _menuItems.length,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemBuilder: (context, index) {
                      final item = _menuItems[index];
                      final isSelected = _selectedMenu == item['title'];
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: isSelected ? themeColor : Colors.transparent,
                        ),
                        child: ListTile(
                          onTap: () => _onMenuSelected(item['title'] as String),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          leading: Icon(
                            item['icon'],
                            color: isSelected ? Colors.white : Colors.white60,
                            size: 22,
                          ),
                          title: Text(
                            item['title'],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.white70,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(color: Colors.white10, height: 1),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed('/');
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    leading: const Icon(
                      Icons.logout_rounded,
                      color: Colors.redAccent,
                      size: 22,
                    ),
                    title: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Custom App Bar
                // Container(
                //   height: 70,
                //   padding: const EdgeInsets.symmetric(horizontal: 30),
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     border: Border(
                //       bottom: BorderSide(color: Colors.grey[100]!, width: 1),
                //     ),
                //   ),
                //   child: Row(
                //     children: [
                //       Text(
                //         _selectedMenu,
                //         style: const TextStyle(
                //           fontSize: 20,
                //           fontWeight: FontWeight.bold,
                //           color: Color(0xFF333333),
                //         ),
                //       ),
                //       const Spacer(),
                //       IconButton(
                //         onPressed: () {},
                //         icon: const Icon(
                //           Icons.search_rounded,
                //           color: Colors.grey,
                //         ),
                //       ),
                //       const SizedBox(width: 10),
                //       Stack(
                //         children: [
                //           IconButton(
                //             onPressed: () {},
                //             icon: const Icon(
                //               Icons.notifications_none_rounded,
                //               color: Colors.grey,
                //             ),
                //           ),
                //           Positioned(
                //             right: 12,
                //             top: 12,
                //             child: Container(
                //               width: 8,
                //               height: 8,
                //               decoration: const BoxDecoration(
                //                 color: Colors.red,
                //                 shape: BoxShape.circle,
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //       const SizedBox(width: 20),
                //       VerticalDivider(
                //         indent: 20,
                //         endIndent: 20,
                //         color: Colors.grey[200],
                //       ),
                //       const SizedBox(width: 20),
                //       const Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         crossAxisAlignment: CrossAxisAlignment.end,
                //         children: [
                //           Text(
                //             'Akash Singh',
                //             style: TextStyle(
                //               fontSize: 14,
                //               fontWeight: FontWeight.bold,
                //             ),
                //           ),
                //           Text(
                //             'Super Admin',
                //             style: TextStyle(fontSize: 12, color: Colors.grey),
                //           ),
                //         ],
                //       ),
                //       const SizedBox(width: 15),
                //       const CircleAvatar(
                //         radius: 18,
                //         backgroundColor: Color(0xFFF3E5F5),
                //         child: Icon(
                //           Icons.person_rounded,
                //           color: themeColor,
                //           size: 20,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // Content with Animation
                Expanded(
                  child: FadeTransition(
                    opacity: _contentAnimationController,
                    child: SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(0, 0.02),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: _contentAnimationController,
                              curve: Curves.easeOut,
                            ),
                          ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(30.0),
                        child: _buildCurrentScreen(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_selectedMenu) {
      case 'Dashboard':
        return DashboardOverviewScreen(onMenuSelected: _onMenuSelected);
      case 'Orders':
        return const OrdersScreen();
      case 'Tailors':
        return const TailorsScreen();
      case 'Delivery Partners':
        return const DeliveryPartnersScreen();
      case 'Customers':
        return const CustomersScreen();
      case 'Transactions':
        return const TransactionsScreen();
      case 'Categories':
        return const CategoriesScreen();
      case 'Products':
        return const ProductsScreen();
      case 'Locations':
        return const LocationsScreen();
      default:
        return _buildPlaceholderContent();
    }
  }

  Widget _buildPlaceholderContent() {
    const themeColor = Color(0xFF6A1B9A);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back, Admin',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 30),
        Container(
          height: 400,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _menuItems.firstWhere(
                    (e) => e['title'] == _selectedMenu,
                  )['icon'],
                  size: 100,
                  color: themeColor.withOpacity(0.1),
                ),
                const SizedBox(height: 20),
                Text(
                  '$_selectedMenu Overview',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'You are currently viewing the $_selectedMenu section.',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
