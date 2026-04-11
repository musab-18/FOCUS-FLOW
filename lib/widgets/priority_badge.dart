import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task_model.dart' ;
import '../theme/app_theme.dart' ;

class PriorityBadge extends StatelessWidget {
  final TaskPriority priority;
  final bool compact;

  const PriorityBadge({super.key, required this.priority, this.compact = false});

  Color get _color {
    switch (priority) {
      case TaskPriority.high: return AppColors.highPriority;
      case TaskPriority.medium: return AppColors.mediumPriority;
      case TaskPriority.low: return AppColors.lowPriority;
    }
  }

  String get _label {
    switch (priority) {
      case TaskPriority.high: return 'High';
      case TaskPriority.medium: return 'Medium';
      case TaskPriority.low: return 'Low';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 10,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: _color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            _label,
            style: GoogleFonts.inter(
              fontSize: compact ? 10 : 11,
              fontWeight: FontWeight.w600,
              color: _color,
            ),
          ),
        ],
      ),
    );
  }
}
