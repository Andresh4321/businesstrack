import 'package:flutter/material.dart';

class ProfessionalModuleButton extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onPress;
  final String? badge;
  final bool isHighlighted;

  const ProfessionalModuleButton({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onPress,
    this.badge,
    this.isHighlighted = false,
  });

  @override
  State<ProfessionalModuleButton> createState() =>
      _ProfessionalModuleButtonState();
}

class _ProfessionalModuleButtonState extends State<ProfessionalModuleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.98,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPress();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.color.withValues(alpha: isDark ? 0.18 : 0.1),
                widget.color.withValues(alpha: isDark ? 0.08 : 0.02),
              ],
            ),
            border: Border.all(
              color: widget.isHighlighted
                  ? widget.color
                  : widget.color.withValues(alpha: isDark ? 0.5 : 0.3),
              width: widget.isHighlighted ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(
                  alpha:
                  widget.isHighlighted
                      ? (isDark ? 0.06 : 0.15)
                      : (isDark ? 0.03 : 0.08),
                ),
                blurRadius: isDark ? 8 : 12,
                offset: Offset(0, isDark ? 2 : 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: widget.color.withValues(alpha: isDark ? 0.3 : 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(widget.icon, color: widget.color, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.description,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: widget.color.withValues(alpha: 0.6),
                    ),
                  ],
                ),
              ),
              // Badge
              if (widget.badge != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.badge!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
