import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/features/course/materials/test/view/mcq_test_details_view.dart';
import 'package:prostuti/features/course/materials/test/view/written_test_details_view.dart';
import 'package:prostuti/features/course/materials/test/viewmodel/get_test_by_id.dart';
import 'package:prostuti/features/course/materials/test/viewmodel/test_viewmodel.dart';
import '../../../../../core/services/nav.dart';
import '../../shared/widgets/material_list_skeleton.dart';
import '../../shared/widgets/trailing_icon.dart';
import '../viewmodel/written_test_viewmodel.dart';

class TestListView extends ConsumerStatefulWidget {
  const TestListView({Key? key}) : super(key: key);

  @override
  TestListViewState createState() => TestListViewState();
}

class TestListViewState extends ConsumerState<TestListView>
    with CommonWidgets, SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mcqTestAsync = ref.watch(mCQTestListViewmodelProvider);
    final writtenTestAsync = ref.watch(writtenTestListViewmodelProvider);

    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("টেস্ট"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "এমসিকিউ"),
            Tab(text: "রিটেন"),
          ],
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          indicatorWeight: 2.0,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          indicatorSize: TabBarIndicatorSize.label,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // MCQ ListView
          mcqTestAsync.when(
            data: (test) {
              return ListView.builder(
                itemCount: test.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      ref
                          .watch(getTestByIdProvider.notifier)
                          .setTestId(test[index].sId!);
                      Nav().push(const MCQTestDetailsView());
                    },
                    child: lessonItem(
                      theme,
                      trailingIcon: TrailingIcon(
                        classDate: test[index].publishDate!,
                        isCompleted: true,
                      ),
                      itemName: "টেস্ট: ${test[index].name}",
                      icon: Icons.question_answer_rounded,
                      lessonName: '${test[index].lessonId!.number} ',
                    ),
                  );
                },
              );
            },
            error: (error, stackTrace) => Text("$error"),
            loading: () => MaterialListSkeleton(),
          ),
          // Written ListView
          writtenTestAsync.when(
            data: (test) {
              return ListView.builder(
                itemCount: test.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      ref
                          .watch(getTestByIdProvider.notifier)
                          .setTestId(test[index].sId!);
                      Nav().push(const WrittenTestDetailsView());
                    },
                    child: lessonItem(
                      theme,
                      trailingIcon: TrailingIcon(
                        classDate: test[index].publishDate!,
                        isCompleted: true,
                      ),
                      itemName: "টেস্ট: ${test[index].name}",
                      icon: Icons.edit_note_rounded,
                      lessonName: '${test[index].lessonId!.number} ',
                    ),
                  );
                },
              );
            },
            error: (error, stackTrace) => Text("$error"),
            loading: () => MaterialListSkeleton(),
          ),
        ],
      ),
    );
  }
}
