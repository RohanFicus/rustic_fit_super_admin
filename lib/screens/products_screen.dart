import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final List<Map<String, dynamic>> _products = [
    {
      'id': 'PROD-001',
      'name': 'Slim Fit Business Suit',
      'category': 'Men\'s Wear',
      'price': '₹8,500',
      'description': 'High-quality wool blend slim fit suit for professionals.',
      'fabric': 'Wool Blend',
      'sizes': ['S', 'M', 'L', 'XL'],
      'tags': ['Men', 'Best Design'],
      'isEnabled': true,
      'images': 3,
    },
    {
      'id': 'PROD-002',
      'name': 'Floral Summer Dress',
      'category': 'Women\'s Wear',
      'price': '₹3,200',
      'description':
          'Breathable cotton floral dress perfect for summer outings.',
      'fabric': 'Premium Cotton',
      'sizes': ['XS', 'S', 'M', 'L'],
      'tags': ['Women', 'Trending'],
      'isEnabled': true,
      'images': 5,
    },
    {
      'id': 'PROD-003',
      'name': 'Silk Wedding Lehenga',
      'category': 'Wedding Collection',
      'price': '₹24,500',
      'description': 'Handcrafted silk lehenga with intricate gold embroidery.',
      'fabric': 'Pure Silk',
      'sizes': ['Custom'],
      'tags': ['Women', 'Wedding Collection'],
      'isEnabled': false,
      'images': 8,
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
                  'Catalog Management',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                Text(
                  'Control your product visibility and inventory',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () => _showProductDialog(),
              icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
              label: const Text('Add New Product'),
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
                        dataRowHeight: 88,
                        horizontalMargin: 24,
                        columnSpacing: 24,
                        headingRowColor: MaterialStateProperty.all(
                          Colors.grey[50],
                        ),
                        columns: const [
                          DataColumn(
                            label: Text(
                              'PRODUCT INFO',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'CATEGORY',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'PRICE',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'PROPERTIES',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'VISIBILITY',
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
                        rows: _products
                            .asMap()
                            .entries
                            .map(
                              (entry) =>
                                  _buildProductRow(entry.value, entry.key),
                            )
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

  DataRow _buildProductRow(Map<String, dynamic> product, int index) {
    bool isEnabled = product['isEnabled'];

    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: NetworkImage('https://via.placeholder.com/100'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    product['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product['id'],
                    style: TextStyle(color: Colors.grey[500], fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF3E5F5),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              product['category'],
              style: const TextStyle(
                color: Color(0xFF6A1B9A),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        DataCell(
          Text(
            product['price'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF333333),
            ),
          ),
        ),
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Fabric: ${product['fabric']}',
                style: const TextStyle(fontSize: 11),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                children: (product['tags'] as List<String>)
                    .map(
                      (tag) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            fontSize: 9,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
        DataCell(
          Switch(
            value: isEnabled,
            onChanged: (val) =>
                setState(() => _products[index]['isEnabled'] = val),
            activeColor: const Color(0xFF6A1B9A),
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.edit_note_rounded,
                  size: 22,
                  color: Colors.grey,
                ),
                onPressed: () =>
                    _showProductDialog(product: product, index: index),
                tooltip: 'Edit Product',
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  size: 22,
                  color: Colors.redAccent,
                ),
                onPressed: () => _confirmDelete(index),
                tooltip: 'Remove',
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showProductDialog({Map<String, dynamic>? product, int? index}) {
    final isEditing = product != null;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
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
                width: 750,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: SingleChildScrollView(
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
                                  ? Icons.edit_rounded
                                  : Icons.add_box_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              isEditing
                                  ? 'Modify Product Listing'
                                  : 'Create New Product',
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
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left Side: Basic Info
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      _buildField(
                                        'Product Title',
                                        'e.g. Premium Silk Lehenga',
                                        icon: Icons.title_rounded,
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _buildField(
                                              'Base Price',
                                              '₹0.00',
                                              icon: Icons.payments_outlined,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: _buildDropdown('Category'),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      _buildField(
                                        'Description',
                                        'Provide detailed craftsmanship details...',
                                        isLong: true,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 32),
                                // Right Side: Media & Fabric
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Product Images',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Container(
                                        height: 160,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey[200]!,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons
                                                  .add_photo_alternate_outlined,
                                              color: const Color(
                                                0xFF6A1B9A,
                                              ).withOpacity(0.5),
                                              size: 40,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Upload Images',
                                              style: TextStyle(
                                                color: Colors.grey[500],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      _buildField(
                                        'Fabric Details',
                                        'e.g. 100% Cotton',
                                        icon: Icons.texture_rounded,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            const Divider(),
                            const SizedBox(height: 24),
                            const Text(
                              'Available Sizes',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children:
                                  ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'Custom']
                                      .map(
                                        (size) => FilterChip(
                                          label: Text(size),
                                          selected: false,
                                          onSelected: (val) {},
                                          selectedColor: const Color(
                                            0xFF6A1B9A,
                                          ).withOpacity(0.1),
                                          checkmarkColor: const Color(
                                            0xFF6A1B9A,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                            const SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 20,
                                    ),
                                  ),
                                  child: Text(
                                    'Discard',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF6A1B9A),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 40,
                                      vertical: 20,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    isEditing
                                        ? 'Update Listing'
                                        : 'Publish Product',
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
          ),
        );
      },
    );
  }

  Widget _buildField(
    String label,
    String hint, {
    IconData? icon,
    bool isLong = false,
  }) {
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
          maxLines: isLong ? 4 : 1,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
            prefixIcon: icon != null
                ? Icon(
                    icon,
                    size: 18,
                    color: const Color(0xFF6A1B9A).withOpacity(0.5),
                  )
                : null,
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.all(16),
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

  Widget _buildDropdown(String label) {
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
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
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
          ),
          value: 'Men\'s Wear',
          items:
              [
                    'Men\'s Wear',
                    'Women\'s Wear',
                    'Wedding Collection',
                    'Kids Wear',
                  ]
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, style: const TextStyle(fontSize: 13)),
                    ),
                  )
                  .toList(),
          onChanged: (v) {},
        ),
      ],
    );
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Product?'),
        content: Text(
          'Are you sure you want to permanently remove "${_products[index]['name']}" from the catalog?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _products.removeAt(index));
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
