import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/core/services/size_config.dart';
import 'package:prostuti/features/home_screen/view/home_screen_view.dart';

import '../model/flashcard_details_model.dart';
import 'flashcard_study_view.dart';

class FlashcardCompletionView extends StatefulWidget {
  final String flashcardId;
  final String flashcardTitle;
  final int knownCount;
  final int learnCount;
  final int totalCards;
  final FlashcardDetail flashcardDetail;

  const FlashcardCompletionView({
    super.key,
    required this.flashcardId,
    required this.flashcardTitle,
    required this.knownCount,
    required this.learnCount,
    required this.totalCards,
    required this.flashcardDetail,
  });

  @override
  State<FlashcardCompletionView> createState() =>
      _FlashcardCompletionViewState();
}

class _FlashcardCompletionViewState extends State<FlashcardCompletionView>
    with CommonWidgets {
  @override
  Widget build(BuildContext context) {
    final int percentage =
        ((widget.knownCount / widget.totalCards) * 100).round();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          '${widget.knownCount}/${widget.totalCards}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        centerTitle: true,
        leading: IconButton(
          icon:
              Icon(Icons.close, color: Theme.of(context).unselectedWidgetColor),
          onPressed: () => Nav().push(
            const HomeScreen(
              initialIndex: 1,
            ),
          ),
        ),
        elevation: 10,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              color: Theme.of(context).cardColor,
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      context.l10n!.excellent,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    const Gap(12),
                    Text(context.l10n!.youHaveAchieved,
                        style: Theme.of(context).textTheme.titleSmall),
                    const Gap(32),

                    // Progress indicator
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: CircularProgressIndicator(
                            value: widget.knownCount / widget.totalCards,
                            strokeWidth: 8,
                            backgroundColor: Colors.grey.shade300,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                        Text('$percentage%',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontSize: 36,
                                )),
                      ],
                    ),

                    const Gap(40),

                    // Stats row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 8),
                          decoration: BoxDecoration(
                              color: const Color(0xffA1F3A9),
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset("assets/icons/correct.svg"),
                              const Gap(4),
                              Text(
                                '${widget.knownCount} ${context.l10n!.learned}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: const Color(0xff159021)),
                              ),
                            ],
                          ),
                        ),
                        const Gap(10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 8),
                          decoration: BoxDecoration(
                              color: const Color(0xffFDD489),
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset("assets/icons/skiped_qus.svg"),
                              const Gap(4),
                              Text(
                                '${widget.learnCount} ${context.l10n!.learning}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: const Color(0xffC9860D)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Gap(32),

            // Review button
            ElevatedButton(
              onPressed: () {
                Nav().push(FlashcardStudyView(
                    flashcardId: widget.flashcardId,
                    flashcardTitle: widget.flashcardTitle));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                minimumSize: Size(SizeConfig.w(356), SizeConfig.h(48)),
              ),
              child: Text(
                context.l10n!.reviewCardsAgain,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
