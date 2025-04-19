import 'package:flutter/material.dart';

class TestHistoryShimmer extends StatelessWidget {
  const TestHistoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final shimmerBaseColor = isDark ? Colors.grey[800] : Colors.grey[300];
    final shimmerHighlightColor = isDark ? Colors.grey[700] : Colors.grey[100];

    return ListView(
      children: [
        // Shimmer for stats section
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Container(
            height: 110,
            decoration: BoxDecoration(
              color: shimmerBaseColor,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),

        // Shimmer for graph section title
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Container(
            height: 20,
            width: 180,
            decoration: BoxDecoration(
              color: shimmerBaseColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),

        // Shimmer for graph section
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Container(
            height: 240,
            decoration: BoxDecoration(
              color: shimmerBaseColor,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),

        // Shimmer for test records title
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 20,
                width: 120,
                decoration: BoxDecoration(
                  color: shimmerBaseColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                height: 30,
                width: 80,
                decoration: BoxDecoration(
                  color: shimmerBaseColor,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ],
          ),
        ),

        // Shimmer for filter chips
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Row(
            children: List.generate(
              4,
              (index) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  height: 32,
                  width: 70,
                  decoration: BoxDecoration(
                    color: shimmerBaseColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Shimmer for test history cards
        ...List.generate(
          4,
          (index) => Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _buildShimmerCard(shimmerBaseColor),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerCard(Color? baseColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Top section
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: baseColor?.withOpacity(0.7),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Main content
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Test type badge
                    Container(
                      height: 20,
                      width: 60,
                      decoration: BoxDecoration(
                        color: baseColor?.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Test name
                    Container(
                      height: 22,
                      decoration: BoxDecoration(
                        color: baseColor?.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 22,
                      width: 140,
                      decoration: BoxDecoration(
                        color: baseColor?.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Lesson info
                    Container(
                      height: 18,
                      width: 160,
                      decoration: BoxDecoration(
                        color: baseColor?.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Date and time
                    Row(
                      children: [
                        Container(
                          height: 16,
                          width: 100,
                          decoration: BoxDecoration(
                            color: baseColor?.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          height: 16,
                          width: 80,
                          decoration: BoxDecoration(
                            color: baseColor?.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Right side - Score circle
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: baseColor?.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
