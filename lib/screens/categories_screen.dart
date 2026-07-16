import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() => _isLoading = true);
    try {
      final data = await SupabaseService().getCategories();
      setState(() {
        _categories = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load categories: $e'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'checkroom':
        return Icons.checkroom;
      case 'dry_cleaning':
        return Icons.dry_cleaning;
      case 'style':
        return Icons.style;
      case 'man_rounded':
        return Icons.man_rounded;
      case 'woman_rounded':
        return Icons.woman_rounded;
      case 'celebration_rounded':
        return Icons.celebration_rounded;
      case 'watch_rounded':
        return Icons.watch_rounded;
      case 'business_center_rounded':
        return Icons.business_center_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  String _getIconName(IconData icon) {
    if (icon == Icons.shopping_bag) return 'shopping_bag';
    if (icon == Icons.checkroom) return 'checkroom';
    if (icon == Icons.dry_cleaning) return 'dry_cleaning';
    if (icon == Icons.style) return 'style';
    if (icon == Icons.man_rounded) return 'man_rounded';
    if (icon == Icons.woman_rounded) return 'woman_rounded';
    if (icon == Icons.celebration_rounded) return 'celebration_rounded';
    if (icon == Icons.watch_rounded) return 'watch_rounded';
    if (icon == Icons.business_center_rounded) return 'business_center_rounded';
    return 'category_rounded';
  }

  Color _getColor(String hex) {
    try {
      final hexColor = hex.replaceAll('#', '');
      return Color(int.parse('FF$hexColor', radix: 16));
    } catch (e) {
      return Colors.purple;
    }
  }

  String _getHexColor(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  Future<void> _toggleEnabled(Map<String, dynamic> category, bool value) async {
    try {
      await SupabaseService().updateCategory(category['id'].toString(), {
        'is_enabled': value,
      });
      _loadCategories();
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
            const Text(
              'Category Management',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width < 600
                  ? double.infinity
                  : null,
              child: ElevatedButton.icon(
                onPressed: () => _showCategoryDialog(),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add Category'),
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
            : _categories.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(50.0),
                      child: Text('No categories found.'),
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final isMobile = constraints.maxWidth < 600;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 400,
                          mainAxisExtent: isMobile ? 160 : 200,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          return _buildCategoryCard(_categories[index]);
                        },
                      );
                    },
                  ),
      ],
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    final isEnabled = category['is_enabled'] ?? true;
    final isMobile = MediaQuery.of(context).size.width < 600;
    final color = _getColor(category['color_hex'] ?? '9C27B0');
    final icon = _getIconData(category['icon_name'] ?? 'shopping_bag');
    final itemsCount = category['items_count'] ?? 0;

    return Container(
      padding: EdgeInsets.all(isMobile ? 15 : 20),
      decoration: BoxDecoration(
        color: isEnabled ? Colors.white : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: isEnabled ? null : Border.all(color: Colors.grey[300]!),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: isMobile ? 22 : 26,
                    ),
                  ),
                  SizedBox(height: isMobile ? 10 : 15),
                  Text(
                    category['name'] ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isMobile ? 14 : 16,
                      color: isEnabled ? Colors.black87 : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$itemsCount Items',
                    style: TextStyle(
                        color: Colors.grey[500], fontSize: isMobile ? 11 : 13),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEnabled ? 'Active' : 'Disabled',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isEnabled ? Colors.green : Colors.red,
                    ),
                  ),
                  Transform.scale(
                    scale: isMobile ? 0.7 : 0.8,
                    child: Switch(
                      value: isEnabled,
                      onChanged: (value) => _toggleEnabled(category, value),
                      activeColor: const Color(0xFF6A1B9A),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: isMobile ? -5 : -10,
            right: isMobile ? -5 : -10,
            child: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _showCategoryDialog(category: category);
                } else if (value == 'delete') {
                  _confirmDelete(category);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  height: 35,
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, size: 16),
                      SizedBox(width: 8),
                      Text('Edit', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  height: 35,
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, size: 16, color: Colors.red),
                      SizedBox(width: 8),
                      Text(
                        'Delete',
                        style: TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
              icon: Icon(Icons.more_vert,
                  color: Colors.grey, size: isMobile ? 16 : 18),
            ),
          ),
        ],
      ),
    );
  }

  void _showCategoryDialog({Map<String, dynamic>? category}) {
    final isEditing = category != null;
    final nameController = TextEditingController(
      text: isEditing ? category['name'] : '',
    );

    IconData selectedIcon = isEditing
        ? _getIconData(category['icon_name'] ?? 'shopping_bag')
        : Icons.shopping_bag;
    Color selectedColor = isEditing
        ? _getColor(category['color_hex'] ?? '9C27B0')
        : Colors.purple;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, anim1, anim2) => const SizedBox(),
      transitionBuilder: (context, anim1, anim2, child) {
        final curve = Curves.fastOutSlowIn.transform(anim1.value);
        return Transform.scale(
          scale: 0.8 + (curve * 0.2),
          child: Opacity(
            opacity: anim1.value,
            child: StatefulBuilder(
              builder: (context, setDialogState) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  titlePadding: EdgeInsets.zero,
                  title: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Color(0xFF6A1B9A),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isEditing
                              ? Icons.edit_calendar_rounded
                              : Icons.add_circle_outline_rounded,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          isEditing ? 'Update Category' : 'Create Category',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  content: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    constraints: const BoxConstraints(maxWidth: 450),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Category Details',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: 'Category Name',
                              hintText: 'e.g. Traditional Wear',
                              prefixIcon: const Icon(
                                Icons.category_outlined,
                                color: Color(0xFF6A1B9A),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFF6A1B9A),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          const Text(
                            'Select Visual Identity',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 15),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _enhancedIconPicker(
                                  Icons.shopping_bag,
                                  Colors.purple,
                                  selectedIcon == Icons.shopping_bag,
                                  () => setDialogState(() {
                                    selectedIcon = Icons.shopping_bag;
                                    selectedColor = Colors.purple;
                                  }),
                                ),
                                const SizedBox(width: 10),
                                _enhancedIconPicker(
                                  Icons.checkroom,
                                  Colors.blue,
                                  selectedIcon == Icons.checkroom,
                                  () => setDialogState(() {
                                    selectedIcon = Icons.checkroom;
                                    selectedColor = Colors.blue;
                                  }),
                                ),
                                const SizedBox(width: 10),
                                _enhancedIconPicker(
                                  Icons.dry_cleaning,
                                  Colors.pink,
                                  selectedIcon == Icons.dry_cleaning,
                                  () => setDialogState(() {
                                    selectedIcon = Icons.dry_cleaning;
                                    selectedColor = Colors.pink;
                                  }),
                                ),
                                const SizedBox(width: 10),
                                _enhancedIconPicker(
                                  Icons.style,
                                  Colors.orange,
                                  selectedIcon == Icons.style,
                                  () => setDialogState(() {
                                    selectedIcon = Icons.style;
                                    selectedColor = Colors.orange;
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Discard',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        if (nameController.text.isNotEmpty) {
                          final payload = {
                            'name': nameController.text.trim(),
                            'icon_name': _getIconName(selectedIcon),
                            'color_hex': _getHexColor(selectedColor),
                            'is_enabled': isEditing
                                ? (category['is_enabled'] ?? true)
                                : true,
                          };

                          try {
                            if (isEditing) {
                              await SupabaseService().updateCategory(
                                  category['id'].toString(), payload);
                            } else {
                              await SupabaseService().createCategory(payload);
                            }
                            _loadCategories();
                            if (mounted) Navigator.pop(context);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error saving category: $e'),
                                backgroundColor: Colors.redAccent,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A1B9A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        isEditing ? 'Update Changes' : 'Create Category',
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _enhancedIconPicker(
    IconData icon,
    Color color,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? color : Colors.grey[200]!,
            width: 2,
          ),
        ),
        child: Icon(
          icon,
          color: isSelected ? color : Colors.grey[400],
          size: 28,
        ),
      ),
    );
  }

  void _confirmDelete(Map<String, dynamic> category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category?'),
        content: Text(
          'Are you sure you want to delete "${category['name']}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await SupabaseService()
                    .deleteCategory(category['id'].toString());
                _loadCategories();
                if (mounted) Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to delete category: $e'),
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
}
