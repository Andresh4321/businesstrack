import 'package:flutter/material.dart';

class AlertsWidget extends StatelessWidget {
  final int criticalCount;
  final int warningCount;
  final VoidCallback onViewAll;

  const AlertsWidget({
    super.key,
    required this.criticalCount,
    required this.warningCount,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onViewAll,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.red.withValues(alpha: isDark ? 0.16 : 0.08),
              Colors.orange.withValues(alpha: isDark ? 0.1 : 0.04),
            ],
          ),
          border: Border.all(
            color: Colors.red.withValues(alpha: isDark ? 0.5 : 0.3),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Alerts & Notifications',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Icon(Icons.notifications, color: Colors.red.shade600),
                ],
              ),
              const SizedBox(height: 12),
              if (criticalCount == 0 && warningCount == 0)
                Text(
                  'All systems running smoothly',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.green.shade600,
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (criticalCount > 0)
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$criticalCount critical alert${criticalCount > 1 ? 's' : ''}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Colors.red.shade600,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    if (warningCount > 0) const SizedBox(height: 8),
                    if (warningCount > 0)
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$warningCount warning${warningCount > 1 ? 's' : ''}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Colors.orange.shade600,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
