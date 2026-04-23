import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final List<Map<String, dynamic>> _categories = [
    {
      'id': 'CAT001',
      'name': 'Men\'s Wear',
      'items': 124,
      'icon': Icons.man_rounded,
      'color': Colors.blue,
      'isEnabled': true,
    },
    {
      'id': 'CAT002',
      'name': 'Women\'s Wear',
      'items': 256,
      'icon': Icons.woman_rounded,
      'color': Colors.pink,
      'isEnabled': true,
    },
    {
      'id': 'CAT003',
      'name': 'Wedding Collection',
      'items': 45,
      'icon': Icons.celebration_rounded,
      'color': Colors.amber,
      'isEnabled': true,
    },
    {
      'id': 'CAT004',
      'name': 'Accessories',
      'items': 89,
      'icon': Icons.watch_rounded,
      'color': Colors.orange,
      'isEnabled': true,
    },
    {
      'id': 'CAT005',
      'name': 'Corporate Uniforms',
      'items': 32,
      'icon': Icons.business_center_rounded,
      'color': Colors.teal,
      'isEnabled': false,
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
            const Text(
              'Category Management',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
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
          ],
        ),
        const SizedBox(height: 30),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.2,
          ),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            return _buildCategoryCard(_categories[index], index);
          },
        ),
      ],
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category, int index) {
    bool isEnabled = category['isEnabled'];

    return Container(
      padding: const EdgeInsets.all(20),
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
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (category['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  category['icon'],
                  color: category['color'],
                  size: 26,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                category['name'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isEnabled ? Colors.black87 : Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${category['items']} Items',
                style: TextStyle(color: Colors.grey[500], fontSize: 13),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEnabled ? 'Active' : 'Disabled',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isEnabled ? Colors.green : Colors.red,
                    ),
                  ),
                  SizedBox(
                    height: 24,
                    width: 40,
                    child: Switch(
                      value: isEnabled,
                      onChanged: (value) {
                        setState(() {
                          _categories[index]['isEnabled'] = value;
                        });
                      },
                      activeColor: const Color(0xFF6A1B9A),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: -10,
            right: -10,
            child: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _showCategoryDialog(category: category, index: index);
                } else if (value == 'delete') {
                  _confirmDelete(index);
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
              icon: const Icon(Icons.more_vert, color: Colors.grey, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  void _showCategoryDialog({Map<String, dynamic>? category, int? index}) {
    final isEditing = category != null;
    final nameController = TextEditingController(
      text: isEditing ? category['name'] : '',
    );

    IconData selectedIcon = isEditing ? category['icon'] : Icons.shopping_bag;
    Color selectedColor = isEditing ? category['color'] : Colors.purple;

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
                  content: SizedBox(
                    width: 450,
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
                        Row(
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
                            _enhancedIconPicker(
                              Icons.checkroom,
                              Colors.blue,
                              selectedIcon == Icons.checkroom,
                              () => setDialogState(() {
                                selectedIcon = Icons.checkroom;
                                selectedColor = Colors.blue;
                              }),
                            ),
                            _enhancedIconPicker(
                              Icons.dry_cleaning,
                              Colors.pink,
                              selectedIcon == Icons.dry_cleaning,
                              () => setDialogState(() {
                                selectedIcon = Icons.dry_cleaning;
                                selectedColor = Colors.pink;
                              }),
                            ),
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
                      ],
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
                      onPressed: () {
                        if (nameController.text.isNotEmpty) {
                          setState(() {
                            if (isEditing) {
                              _categories[index!]['name'] = nameController.text;
                              _categories[index]['icon'] = selectedIcon;
                              _categories[index]['color'] = selectedColor;
                            } else {
                              _categories.add({
                                'id': 'CAT00${_categories.length + 1}',
                                'name': nameController.text,
                                'items': 0,
                                'icon': selectedIcon,
                                'color': selectedColor,
                                'isEnabled': true,
                              });
                            }
                          });
                          Navigator.pop(context);
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

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category?'),
        content: Text(
          'Are you sure you want to delete "${_categories[index]['name']}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _categories.removeAt(index);
              });
              Navigator.pop(context);
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
