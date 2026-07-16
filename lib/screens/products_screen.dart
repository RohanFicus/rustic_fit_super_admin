import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/supabase_service.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final productsData = await SupabaseService().getProducts();
      final categoriesData = await SupabaseService().getCategories();
      setState(() {
        _products = productsData;
        _categories = categoriesData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load catalog data: $e'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _toggleProductEnabled(
      Map<String, dynamic> product, bool value) async {
    try {
      await SupabaseService().updateProduct(product['id'].toString(), {
        'is_enabled': value,
      });
      _loadData();
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

  Future<void> _deleteProduct(Map<String, dynamic> product) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Product?'),
        content: Text(
          'Are you sure you want to permanently remove "${product['name']}" from the catalog?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await SupabaseService().deleteProduct(product['id'].toString());
                _loadData();
                if (mounted) Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to remove product: $e'),
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

  Color _parseColor(String colorStr) {
    if (colorStr.trim().startsWith('#')) {
      final hex = colorStr.trim().replaceFirst('#', '');
      try {
        if (hex.length == 6) {
          return Color(int.parse('FF$hex', radix: 16));
        } else if (hex.length == 8) {
          return Color(int.parse(hex, radix: 16));
        }
      } catch (_) {}
    }
    final name = colorStr.toLowerCase();
    if (name.contains('black')) return Colors.black;
    if (name.contains('white')) return Colors.white;
    if (name.contains('red')) return Colors.red;
    if (name.contains('blue')) return Colors.blue;
    if (name.contains('green')) return Colors.green;
    if (name.contains('yellow')) return Colors.yellow;
    if (name.contains('grey') || name.contains('gray')) return Colors.grey;
    if (name.contains('purple')) return Colors.purple;
    if (name.contains('orange')) return Colors.orange;
    if (name.contains('pink')) return Colors.pink;
    if (name.contains('brown')) return Colors.brown;
    return Colors.transparent;
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
            SizedBox(
              width: MediaQuery.of(context).size.width < 600
                  ? double.infinity
                  : null,
              child: ElevatedButton.icon(
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
            : _products.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(50.0),
                      child: Text('No products in catalog.'),
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
                          mainAxisExtent: isMobile ? 340 : 380,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          return _buildProductCard(_products[index]);
                        },
                      );
                    },
                  ),
      ],
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    bool isEnabled = product['is_enabled'] ?? true;
    final isMobile = MediaQuery.of(context).size.width < 600;
    final categoryName = product['categories'] != null
        ? (product['categories']['name'] ?? 'Uncategorized')
        : 'Uncategorized';
    final priceStr = product['price']?.toString() ?? '0';
    final imageUrl = product['image_url']?.toString() ?? '';
    final colorVal = product['color']?.toString() ?? '';
    final typeVal = product['type']?.toString() ?? '';

    return Container(
      decoration: BoxDecoration(
        color: isEnabled ? Colors.white : Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildFallbackImage(),
                            )
                          : _buildFallbackImage(),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: PopupMenuButton<String>(
                      onSelected: (val) {
                        if (val == 'edit') {
                          _showProductDialog(product: product);
                        } else if (val == 'delete') {
                          _deleteProduct(product);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit Product'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete Product',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                      icon: const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 16,
                        child: Icon(Icons.more_vert,
                            color: Colors.grey, size: 18),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '₹$priceStr',
                        style: const TextStyle(
                          color: Color(0xFF6A1B9A),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 12.0 : 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        categoryName.toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF6A1B9A),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product['name'] ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Type and Color info
                      Row(
                        children: [
                          if (typeVal.isNotEmpty) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                typeVal.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          if (colorVal.isNotEmpty) ...[
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _parseColor(colorVal),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.grey[300]!, width: 0.5),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              colorVal,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        product['description'] ?? 'No description available.',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isEnabled ? 'Listed' : 'Paused',
                        style: TextStyle(
                          color: isEnabled ? Colors.green : Colors.grey,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Transform.scale(
                        scale: 0.7,
                        child: Switch(
                          value: isEnabled,
                          onChanged: (val) =>
                              _toggleProductEnabled(product, val),
                          activeColor: const Color(0xFF6A1B9A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      color: const Color(0xFF6A1B9A).withOpacity(0.05),
      child: Center(
        child: Icon(
          Icons.checkroom_rounded,
          size: 50,
          color: const Color(0xFF6A1B9A).withOpacity(0.2),
        ),
      ),
    );
  }

  void _showProductDialog({Map<String, dynamic>? product}) {
    final isEditing = product != null;
    final nameController = TextEditingController(
      text: isEditing ? product['name'] : '',
    );
    final priceController = TextEditingController(
      text: isEditing ? product['price']?.toString() : '',
    );
    final descController = TextEditingController(
      text: isEditing ? product['description'] : '',
    );
    final fabricController = TextEditingController(
      text: isEditing ? product['fabric'] : '',
    );
    final imageController = TextEditingController(
      text: isEditing ? product['image_url'] ?? '' : '',
    );
    final colorController = TextEditingController(
      text: isEditing ? product['color'] ?? '' : '',
    );
    final typeController = TextEditingController(
      text: isEditing ? product['type'] ?? '' : '',
    );

    String? selectedCategoryId = isEditing
        ? product['category_id']?.toString()
        : (_categories.isNotEmpty ? _categories.first['id'].toString() : null);

    List<String> selectedSizes =
        isEditing ? List<String>.from(product['sizes'] ?? []) : [];

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
              content: StatefulBuilder(
                builder: (context, setDialogState) {
                  // Listen to image URL changes to update preview
                  imageController.addListener(() {
                    if (mounted) {
                      setDialogState(() {});
                    }
                  });

                  return Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    constraints: const BoxConstraints(maxWidth: 800),
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
                            child: Row(
                              children: [
                                Icon(
                                  isEditing
                                      ? Icons.edit_note_rounded
                                      : Icons.add_circle_outline_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  isEditing
                                      ? 'Edit Product'
                                      : 'Add New Product',
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flex(
                                  direction:
                                      MediaQuery.of(context).size.width < 900
                                          ? Axis.vertical
                                          : Axis.horizontal,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: MediaQuery.of(context).size.width <
                                              900
                                          ? 0
                                          : 1,
                                      child: Column(
                                        children: [
                                          _buildField(
                                            'Product Title',
                                            'e.g. Slim Fit Blazer',
                                            nameController,
                                            icon: Icons.title_rounded,
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: _buildField(
                                                  'Price (INR)',
                                                  'e.g. 5500',
                                                  priceController,
                                                  icon: Icons.payments_outlined,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Category',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xFF333333),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    DropdownButtonFormField<
                                                        String>(
                                                      decoration:
                                                          InputDecoration(
                                                        filled: true,
                                                        fillColor:
                                                            Colors.grey[50],
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 16,
                                                          vertical: 12,
                                                        ),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .grey[200]!),
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .grey[200]!),
                                                        ),
                                                      ),
                                                      value: selectedCategoryId,
                                                      items: _categories
                                                          .map(
                                                            (c) =>
                                                                DropdownMenuItem<
                                                                    String>(
                                                              value: c['id']
                                                                  .toString(),
                                                              child: Text(
                                                                c['name'] ?? '',
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            13),
                                                              ),
                                                            ),
                                                          )
                                                          .toList(),
                                                      onChanged: (val) {
                                                        setDialogState(() {
                                                          selectedCategoryId =
                                                              val;
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: _buildField(
                                                  'Garment Type',
                                                  'e.g. Blazer, Shirt, Lehenga',
                                                  typeController,
                                                  icon: Icons.checkroom_outlined,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: _buildField(
                                                  'Color (Name or Hex)',
                                                  'e.g. Navy Blue, #000080',
                                                  colorController,
                                                  icon: Icons.palette_outlined,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          _buildField(
                                            'Description',
                                            'Craftsmanship details...',
                                            descController,
                                            isLong: true,
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (MediaQuery.of(context).size.width >=
                                        900)
                                      const SizedBox(width: 32),
                                    if (MediaQuery.of(context).size.width < 900)
                                      const SizedBox(height: 24),
                                    Flexible(
                                      flex: MediaQuery.of(context).size.width <
                                              900
                                          ? 0
                                          : 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildField(
                                            'Fabric Details',
                                            'e.g. 100% Wool',
                                            fabricController,
                                            icon: Icons.texture_rounded,
                                          ),
                                          const SizedBox(height: 16),
                                          _buildField(
                                            'Product Image URL',
                                            'https://images.unsplash.com/...',
                                            imageController,
                                            icon: Icons.image_rounded,
                                          ),
                                          const SizedBox(height: 8),
                                          TextButton.icon(
                                            onPressed: () async {
                                              try {
                                                final picker = ImagePicker();
                                                final XFile? image = await picker.pickImage(
                                                  source: ImageSource.gallery,
                                                  imageQuality: 85,
                                                );
                                                if (image != null) {
                                                  final bytes = await image.readAsBytes();
                                                  if (mounted) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(
                                                        content: Text('Uploading selected image to storage...'),
                                                        duration: Duration(seconds: 2),
                                                      ),
                                                    );
                                                  }
                                                  final publicUrl = await SupabaseService()
                                                      .uploadProductImage(image.name, bytes);
                                                  imageController.text = publicUrl;
                                                  setDialogState(() {});
                                                }
                                              } catch (e) {
                                                if (mounted) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text('Failed to pick/upload image: $e'),
                                                      backgroundColor: Colors.redAccent,
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                            icon: const Icon(Icons.photo_library_outlined, size: 16),
                                            label: const Text('Or Upload from Gallery', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                            style: TextButton.styleFrom(
                                              foregroundColor: const Color(0xFF6A1B9A),
                                              padding: EdgeInsets.zero,
                                              minimumSize: Size.zero,
                                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            ),
                                          ),
                                          if (imageController.text.trim().isNotEmpty) ...[
                                            const SizedBox(height: 12),
                                            const Text(
                                              'Image Preview',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: Image.network(
                                                imageController.text.trim(),
                                                height: 100,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                                errorBuilder: (ctx, err, stack) => Container(
                                                  height: 100,
                                                  color: Colors.grey[100],
                                                  child: const Center(
                                                    child: Icon(Icons.broken_image_outlined, color: Colors.grey),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
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
                                            children: [
                                              'XS',
                                              'S',
                                              'M',
                                              'L',
                                              'XL',
                                              'XXL',
                                              'Custom'
                                            ].map((size) {
                                              final isSelected =
                                                  selectedSizes.contains(size);
                                              return FilterChip(
                                                label: Text(size),
                                                selected: isSelected,
                                                onSelected: (val) {
                                                  setDialogState(() {
                                                    if (val) {
                                                      selectedSizes.add(size);
                                                    } else {
                                                      selectedSizes
                                                          .remove(size);
                                                    }
                                                  });
                                                },
                                                selectedColor:
                                                    const Color(0xFF6A1B9A)
                                                        .withOpacity(0.1),
                                                checkmarkColor: const Color(
                                                  0xFF6A1B9A,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 32),
                                const Divider(),
                                const SizedBox(height: 24),
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
                                        style:
                                            TextStyle(color: Colors.grey[600]),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (nameController.text.isNotEmpty &&
                                            selectedCategoryId != null) {
                                          final payload = {
                                            'name': nameController.text.trim(),
                                            'price': double.tryParse(
                                                    priceController.text) ??
                                                0.0,
                                            'category_id': selectedCategoryId,
                                            'description':
                                                descController.text.trim(),
                                            'fabric':
                                                fabricController.text.trim(),
                                            'image_url':
                                                imageController.text.trim(),
                                            'color':
                                                colorController.text.trim(),
                                            'type':
                                                typeController.text.trim(),
                                            'sizes': selectedSizes,
                                            'is_enabled': isEditing
                                                ? (product['is_enabled'] ??
                                                    true)
                                                : true,
                                          };
                                          try {
                                            if (isEditing) {
                                              await SupabaseService()
                                                  .updateProduct(
                                                      product['id'].toString(),
                                                      payload);
                                            } else {
                                              await SupabaseService()
                                                  .createProduct(payload);
                                            }
                                            _loadData();
                                            if (mounted) {
                                              Navigator.pop(context);
                                            }
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Failed to save product: $e'),
                                                backgroundColor:
                                                    Colors.redAccent,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF6A1B9A),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 40,
                                          vertical: 20,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildField(
    String label,
    String hint,
    TextEditingController controller, {
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
          controller: controller,
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
}
