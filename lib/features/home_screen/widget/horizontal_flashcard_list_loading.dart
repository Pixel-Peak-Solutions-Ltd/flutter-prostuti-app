import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../flashcard/model/flashcard_model.dart';

class HorizontalFlashcardListLoading extends StatelessWidget {
  const HorizontalFlashcardListLoading({
    super.key,
    required this.maxWidth,
  });

  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final fakeFlashcards = List<Flashcard>.generate(
      3,
      (index) => Flashcard(
        title: 'Loading flashcard title',
        studentId: Student(name: 'Loading author'),
      ),
    );

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: fakeFlashcards.length,
      itemBuilder: (context, index) {
        return Container(
          width: maxWidth * 0.8,
          padding: EdgeInsets.only(
            left: index == 0 ? 16 : 8,
            right: index == fakeFlashcards.length - 1 ? 16 : 8,
          ),
          child: Skeletonizer(
            enabled: true,
            child: Card(
              elevation: 8,
              shadowColor: Colors.grey.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: maxWidth * 0.5,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 100,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 40,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
