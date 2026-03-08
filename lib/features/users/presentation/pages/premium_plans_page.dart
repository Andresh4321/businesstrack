import 'package:flutter/material.dart';

class PremiumPlansPage extends StatelessWidget {
  const PremiumPlansPage({super.key, this.isProfessional = false});

  final bool isProfessional;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Premium Plans'), elevation: 0),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [Color(0xFF0E1117), Color(0xFF1A1F2E)]
                : const [Color(0xFFF4F7FB), Color(0xFFE9EEF7)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.06)
                        : Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.12)
                          : Colors.black.withOpacity(0.07),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10A37F).withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.workspace_premium,
                          color: Color(0xFF10A37F),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          isProfessional
                              ? 'Choose the right plan for your professional workflow.'
                              : 'Upgrade anytime. No payment setup yet, this is UI only.',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.white70 : Colors.black87,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                _planCard(
                  context,
                  title: 'Basic',
                  price: 'Free',
                  subtitle: 'Good for getting started',
                  features: const [
                    'Core inventory and stock tracking',
                    'Basic reports',
                    'Standard support',
                  ],
                  accent: const Color(0xFF9AA3B2),
                  highlighted: false,
                ),
                const SizedBox(height: 14),
                _planCard(
                  context,
                  title: 'Extended',
                  price: 'Rs 200 / month',
                  subtitle: 'For growing business teams',
                  features: const [
                    'Everything in Basic',
                    'Advanced analytics',
                    'Priority notifications',
                  ],
                  accent: const Color(0xFF1D9BF0),
                  highlighted: true,
                  badge: 'Popular',
                ),
                const SizedBox(height: 14),
                _planCard(
                  context,
                  title: 'Pro',
                  price: 'Rs 400 / month',
                  subtitle: 'Full power for professionals',
                  features: const [
                    'Everything in Extended',
                    'AI assistant enhancements',
                    'Top-tier priority support',
                  ],
                  accent: const Color(0xFF10A37F),
                  highlighted: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _planCard(
    BuildContext context, {
    required String title,
    required String price,
    required String subtitle,
    required List<String> features,
    required Color accent,
    required bool highlighted,
    String? badge,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? (highlighted ? accent.withOpacity(0.16) : const Color(0xFF151A23))
            : (highlighted ? accent.withOpacity(0.09) : Colors.white),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: highlighted
              ? accent.withOpacity(0.85)
              : (isDark ? Colors.white.withOpacity(0.12) : Colors.black12),
          width: highlighted ? 1.4 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: highlighted
                ? accent.withOpacity(0.14)
                : Colors.black.withOpacity(isDark ? 0.22 : 0.05),
            blurRadius: highlighted ? 18 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      color: accent,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            price,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: accent,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 14),
          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, size: 18, color: accent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      feature,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.35,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('UI only for now. Payment coming soon.'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Choose $title'),
            ),
          ),
        ],
      ),
    );
  }
}
