import 'package:flutter/material.dart';

class ExpenseListTileSkeleton extends StatelessWidget {
  const ExpenseListTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 14, width: 150, color: Colors.white),
                const SizedBox(height: 8),
                Container(height: 12, width: 100, color: Colors.white),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(height: 14, width: 60, color: Colors.white),
              const SizedBox(height: 8),
              Container(height: 12, width: 40, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }
}
