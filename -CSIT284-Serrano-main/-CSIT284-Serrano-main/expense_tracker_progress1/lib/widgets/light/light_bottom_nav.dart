import 'package:flutter/material.dart';
import '../../theme/light_theme.dart';

class LightBottomNav extends StatelessWidget {
  const LightBottomNav({
    super.key,
    required this.currentIndex,
    required this.onSelected,
    required this.onAdd,
  });
  final int currentIndex;
  final ValueChanged<int> onSelected;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return SizedBox(
      height: 96 + bottom,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 72 + bottom,
              padding: EdgeInsets.only(bottom: bottom),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [BoxShadow(color: Color(0x0F000000), blurRadius: 20, offset: Offset(0, -4))],
              ),
              child: Row(
                children: [
                  _item(Icons.home_rounded, 'Home', 0),
                  _item(Icons.insert_chart_rounded, 'Report', 1),
                  const SizedBox(width: 84),
                  _item(Icons.style_rounded, 'Plan', 2),
                  _item(Icons.settings_rounded, 'Settings', 3),
                ],
              ),
            ),
          ),
          Positioned(
            top: 4,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: onAdd,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [LightColors.purpleLight, LightColors.purple],
                    ),
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: LightColors.purple.withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(IconData icon, String label, int index) {
    final selected = currentIndex == index;
    final color = selected ? LightColors.ink : const Color(0xFF9A9AA0);
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onSelected(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}