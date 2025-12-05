import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PERIOD SELECTOR
              Row(
                children: [
                  Expanded(child: periodButton("Today", true)),
                  const SizedBox(width: 8),
                  Expanded(child: periodButton("This Week", false)),
                  const SizedBox(width: 8),
                  Expanded(child: periodButton("This Month", false)),
                ],
              ),

              const SizedBox(height: 28),

              // METRICS GRID 1
              Row(
                children: [
                  Expanded(child: metricCard("Products Produced", "42")),
                  const SizedBox(width: 12),
                  Expanded(child: metricCard("Materials Used", "18")),
                ],
              ),

              const SizedBox(height: 12),

              // METRICS GRID 2
              Row(
                children: [
                  Expanded(child: metricCard("Avg Wastage", "3.2%")),
                  const SizedBox(width: 12),
                  Expanded(child: metricCard("Total Cost", "\$1,240")),
                ],
              ),

              const SizedBox(height: 28),

              // Production Trends
              const Text(
                "Production Trends",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const ChartBox(
                icon: "📈",
                text: "Production chart will appear here",
              ),

              const SizedBox(height: 28),

              // Wastage Analysis
              const Text(
                "Wastage Analysis",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const ChartBox(
                icon: "📊",
                text: "Wastage chart will appear here",
              ),

              const SizedBox(height: 28),

              // TOP PRODUCTS TABLE
              const Text(
                "Top Products",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  children: const [
                    ProductRow(
                      name: "1-Tier Chocolate Cake",
                      units: "15 units",
                      wastage: "2.1%",
                    ),
                    ProductRow(
                      name: "2-Tier Vanilla Cake",
                      units: "12 units",
                      wastage: "3.5%",
                    ),
                    ProductRow(
                      name: "3-Tier Wedding Cake",
                      units: "8 units",
                      wastage: "4.2%",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- WIDGETS BELOW ---------- //

  Widget periodButton(String text, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF4F46E5) : Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: active ? Colors.white : Colors.grey[600],
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget metricCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// CHART BOX
class ChartBox extends StatelessWidget {
  final String icon;
  final String text;

  const ChartBox({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 48, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// PRODUCT ROW
class ProductRow extends StatelessWidget {
  final String name;
  final String units;
  final String wastage;

  const ProductRow({
    super.key,
    required this.name,
    required this.units,
    required this.wastage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(units, style: TextStyle(color: Colors.grey[600])),
            ],
          ),
          Text(
            wastage,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFFF59E0B),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
