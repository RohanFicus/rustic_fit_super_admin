import 'package:flutter/material.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> transactions = [
      {
        'payment_id': 'PAY-8821942',
        'order_id': '#ORD-7241',
        'customer': 'Rahul Sharma',
        'amount': '₹8,500',
        'method': 'UPI (GPay)',
        'status': 'Success',
        'date': '24 Oct 2023',
        'time': '02:30 PM',
      },
      {
        'payment_id': 'PAY-8821943',
        'order_id': '#ORD-7242',
        'customer': 'Priya Singh',
        'amount': '₹12,400',
        'method': 'Credit Card',
        'status': 'Success',
        'date': '24 Oct 2023',
        'time': '11:15 AM',
      },
      {
        'payment_id': 'PAY-8821944',
        'order_id': '#ORD-7243',
        'customer': 'Amit Verma',
        'amount': '₹1,200',
        'method': 'Cash on Delivery',
        'status': 'Pending',
        'date': '25 Oct 2023',
        'time': '09:45 AM',
      },
      {
        'payment_id': 'PAY-8821945',
        'order_id': '#ORD-7244',
        'customer': 'Sanya Malhotra',
        'amount': '₹15,000',
        'method': 'Net Banking',
        'status': 'Failed',
        'date': '25 Oct 2023',
        'time': '04:20 PM',
      },
    ];

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
                  'Transaction History',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                Text(
                  'Monitor all incoming and outgoing payments',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list_rounded, size: 18),
                  label: const Text('Filters'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.file_download_outlined, size: 18),
                  label: const Text('Export CSV'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A1B9A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 30),

        // Summary Cards
        Row(
          children: [
            _buildSummaryCard(
              'Total Revenue',
              '₹2,45,000',
              Icons.account_balance_wallet_rounded,
              Colors.green,
            ),
            const SizedBox(width: 20),
            _buildSummaryCard(
              'Successful',
              '182',
              Icons.check_circle_rounded,
              Colors.blue,
            ),
            const SizedBox(width: 20),
            _buildSummaryCard(
              'Pending',
              '12',
              Icons.pending_rounded,
              Colors.orange,
            ),
            const SizedBox(width: 20),
            _buildSummaryCard('Failed', '4', Icons.error_rounded, Colors.red),
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
                              'DATE & TIME',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'TRANSACTION DETAILS',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
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
                              'PAYMENT METHOD',
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
                              'AMOUNT',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                        rows: transactions
                            .map((txn) => _buildTxnRow(txn))
                            .toList(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Showing recent 50 transactions',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'View All History',
                style: TextStyle(
                  color: Color(0xFF6A1B9A),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildTxnRow(Map<String, dynamic> txn) {
    Color statusColor;
    switch (txn['status']) {
      case 'Success':
        statusColor = Colors.green;
        break;
      case 'Pending':
        statusColor = Colors.orange;
        break;
      case 'Failed':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return DataRow(
      cells: [
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                txn['date'],
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
              Text(
                txn['time'],
                style: TextStyle(color: Colors.grey[500], fontSize: 11),
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
                txn['order_id'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Text(
                txn['payment_id'],
                style: TextStyle(color: Colors.blue[600], fontSize: 11),
              ),
            ],
          ),
        ),
        DataCell(Text(txn['customer'], style: const TextStyle(fontSize: 13))),
        DataCell(
          Row(
            children: [
              Icon(
                _getPaymentIcon(txn['method']),
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Text(txn['method'], style: const TextStyle(fontSize: 13)),
            ],
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              txn['status'].toUpperCase(),
              style: TextStyle(
                color: statusColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        DataCell(
          Text(
            txn['amount'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF333333),
            ),
          ),
        ),
      ],
    );
  }

  IconData _getPaymentIcon(String method) {
    if (method.contains('Card')) return Icons.credit_card_rounded;
    if (method.contains('UPI')) return Icons.account_balance_wallet_rounded;
    if (method.contains('Cash')) return Icons.payments_rounded;
    return Icons.account_balance_rounded;
  }
}
