import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class MeasurementsScreen extends StatefulWidget {
  const MeasurementsScreen({super.key});

  @override
  State<MeasurementsScreen> createState() => _MeasurementsScreenState();
}

class _MeasurementsScreenState extends State<MeasurementsScreen> {
  List<Map<String, dynamic>> _measurementTemplates = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }

  Future<void> _loadTemplates() async {
    setState(() => _isLoading = true);
    try {
      final data = await SupabaseService().getMeasurementTemplates();
      setState(() {
        _measurementTemplates = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load templates: $e'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _toggleTemplateActive(
      Map<String, dynamic> template, bool value) async {
    try {
      await SupabaseService().updateMeasurementTemplate(
          template['id'].toString(), {
        'is_active': value,
      });
      _loadTemplates();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update template status: $e'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _deleteTemplate(Map<String, dynamic> template) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Template?'),
        content: const Text(
            'This will remove this measurement template permanently.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              try {
                await SupabaseService()
                    .deleteMeasurementTemplate(template['id'].toString());
                _loadTemplates();
                if (mounted) Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to delete template: $e'),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
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
                  'Measurement Parameters',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                Text(
                  'Define and manage measurement fields for different garment types',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width < 600
                  ? double.infinity
                  : null,
              child: ElevatedButton.icon(
                onPressed: () => _showTemplateDialog(),
                icon: const Icon(Icons.add_chart_rounded, size: 20),
                label: const Text('Add New Template'),
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
            : _measurementTemplates.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(50.0),
                      child: Text('No measurement templates found.'),
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
                          mainAxisExtent: isMobile ? 320 : 360,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        itemCount: _measurementTemplates.length,
                        itemBuilder: (context, index) {
                          return _buildTemplateCard(
                              _measurementTemplates[index]);
                        },
                      );
                    },
                  ),
      ],
    );
  }

  Widget _buildTemplateCard(Map<String, dynamic> template) {
    bool isActive = template['is_active'] ?? true;
    final isMobile = MediaQuery.of(context).size.width < 600;
    final category = template['category'] ?? 'General';
    final parameters = List<dynamic>.from(template['parameters'] ?? []);

    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF6A1B9A),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    template['name'] ?? '',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              PopupMenuButton<String>(
                onSelected: (val) {
                  if (val == 'edit') {
                    _showTemplateDialog(template: template);
                  } else if (val == 'delete') {
                    _deleteTemplate(template);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit Template'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete Template',
                        style: TextStyle(color: Colors.red)),
                  ),
                ],
                icon: const Icon(Icons.more_vert, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: parameters.map((param) {
                final name = param['name'] ?? '';
                final isRequired = param['required'] == true;
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isRequired
                        ? const Color(0xFF6A1B9A).withOpacity(0.06)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isRequired
                          ? const Color(0xFF6A1B9A).withOpacity(0.1)
                          : Colors.grey[200]!,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 12,
                          color: isRequired
                              ? const Color(0xFF6A1B9A)
                              : Colors.black87,
                          fontWeight: isRequired
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      if (isRequired) ...[
                        const SizedBox(width: 4),
                        const Text(
                          '*',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ]
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isActive ? 'ACTIVE' : 'INACTIVE',
                style: TextStyle(
                  color: isActive ? Colors.green : Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
              Transform.scale(
                scale: 0.7,
                child: Switch(
                  value: isActive,
                  onChanged: (val) => _toggleTemplateActive(template, val),
                  activeColor: const Color(0xFF6A1B9A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showTemplateDialog({Map<String, dynamic>? template}) {
    final isEditing = template != null;
    final nameController = TextEditingController(
      text: isEditing ? template['name'] : '',
    );
    String selectedCategory = isEditing
        ? (template['category'] ?? 'Men\'s Wear')
        : 'Men\'s Wear';

    // Parameters builder list
    List<Map<String, dynamic>> tempParams = isEditing
        ? List<Map<String, dynamic>>.from(template['parameters'] ?? [])
        : [
            {'name': 'Collar', 'unit': 'Inches', 'required': true},
            {'name': 'Chest', 'unit': 'Inches', 'required': true},
          ];

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
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    constraints: const BoxConstraints(maxWidth: 600),
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
                                const Icon(
                                  Icons.add_chart_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  isEditing ? 'Edit Template' : 'New Template',
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
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildField(
                                          'Template Name',
                                          'e.g. Men\'s Suit',
                                          nameController),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildDropdown(
                                        'Category',
                                        selectedCategory,
                                        (v) {
                                          if (v != null) {
                                            setDialogState(() {
                                              selectedCategory = v;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                const Text(
                                  'Parameters',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ...tempParams.asMap().entries.map((entry) {
                                  final idx = entry.key;
                                  final param = entry.value;
                                  final ctrlName = TextEditingController(
                                      text: param['name'] ?? '');
                                  final ctrlUnit = TextEditingController(
                                      text: param['unit'] ?? 'Inches');

                                  ctrlName.addListener(() {
                                    param['name'] = ctrlName.text;
                                  });
                                  ctrlUnit.addListener(() {
                                    param['unit'] = ctrlUnit.text;
                                  });

                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: TextField(
                                            controller: ctrlName,
                                            decoration: InputDecoration(
                                              hintText: 'Parameter Name',
                                              isDense: true,
                                              filled: true,
                                              fillColor: Colors.grey[50],
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: TextField(
                                            controller: ctrlUnit,
                                            decoration: InputDecoration(
                                              hintText: 'Unit',
                                              isDense: true,
                                              filled: true,
                                              fillColor: Colors.grey[50],
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                            ),
                                          ),
                                        ),
                                        Checkbox(
                                          value: param['required'] == true,
                                          onChanged: (v) {
                                            setDialogState(() {
                                              param['required'] = v;
                                            });
                                          },
                                          activeColor: const Color(0xFF6A1B9A),
                                        ),
                                        const Text('Req',
                                            style: TextStyle(fontSize: 12)),
                                        IconButton(
                                          onPressed: () {
                                            setDialogState(() {
                                              tempParams.removeAt(idx);
                                            });
                                          },
                                          icon: const Icon(
                                              Icons
                                                  .remove_circle_outline_rounded,
                                              color: Colors.redAccent,
                                              size: 20),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                const SizedBox(height: 12),
                                TextButton.icon(
                                  onPressed: () {
                                    setDialogState(() {
                                      tempParams.add({
                                        'name': '',
                                        'unit': 'Inches',
                                        'required': true,
                                      });
                                    });
                                  },
                                  icon: const Icon(Icons.add_circle_outline),
                                  label: const Text('Add Parameter'),
                                  style: TextButton.styleFrom(
                                      foregroundColor: const Color(0xFF6A1B9A)),
                                ),
                                const SizedBox(height: 32),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        'Cancel',
                                        style:
                                            TextStyle(color: Colors.grey[600]),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (nameController.text.isNotEmpty) {
                                          final payload = {
                                            'name': nameController.text.trim(),
                                            'category': selectedCategory,
                                            'parameters': tempParams,
                                            'is_active': isEditing
                                                ? (template['is_active'] ??
                                                    true)
                                                : true,
                                          };

                                          try {
                                            if (isEditing) {
                                              await SupabaseService()
                                                  .updateMeasurementTemplate(
                                                      template['id'].toString(),
                                                      payload);
                                            } else {
                                              await SupabaseService()
                                                  .createMeasurementTemplate(
                                                      payload);
                                            }
                                            _loadTemplates();
                                            if (mounted) {
                                              Navigator.pop(context);
                                            }
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Failed to save template: $e'),
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
                                            horizontal: 32, vertical: 16),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                      ),
                                      child: const Text('Save Template'),
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
      String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333))),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[200]!)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[200]!)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
      String label, String selected, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333))),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[200]!)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[200]!)),
          ),
          value: selected,
          items: ['Men\'s Wear', 'Women\'s Wear', 'Wedding Collection']
              .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, style: const TextStyle(fontSize: 14))))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
