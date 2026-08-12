import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_assets.dart';

/// The filter button + search field row used above the payments, orders and
/// invoices lists. Extracted from the payments screen so the three list
/// pages share one look (Principle I — no duplicated layout literals).
///
/// Assumes an RTL ancestor: the filter button sits at the start (right) and
/// the field expands into the remaining space.
class SearchFilterBar extends StatelessWidget {
  const SearchFilterBar({
    this.hintText = 'ابحث بكود الفاتورة',
    this.controller,
    this.onChanged,
    this.onFilterTap,
    super.key,
  });

  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onFilterTap,
          child: SvgPicture.asset(
            AppAssets.filterIcon,
            width: 48,
            height: 48,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F2F7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE7E9EF)),
            ),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Color(0xFF8A93A6),
                  fontSize: 14,
                ),
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search, color: Color(0xFF1E5FFF)),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
