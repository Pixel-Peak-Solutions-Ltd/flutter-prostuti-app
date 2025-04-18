import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/core/services/currency_converter.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/features/course/course_details/view/course_details_view.dart';
import 'package:prostuti/features/course/course_list/viewmodel/course_list_viewmodel.dart';
import 'package:prostuti/features/course/course_list/viewmodel/get_course_by_id.dart';
import 'package:prostuti/features/course/course_list/widgets/course_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Simple provider for recent searches using SharedPreferences
final recentSearchesProvider = FutureProvider<List<String>>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('recent_searches') ?? [];
});

class SearchView extends ConsumerStatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  SearchViewState createState() => SearchViewState();
}

class SearchViewState extends ConsumerState<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showClearButton = false;

  // Flag to track if a search has been performed
  bool hasSearched = false;

  @override
  void initState() {
    super.initState();

    // Start with focused search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

    // Add listener to show/hide clear button
    _searchController.addListener(() {
      setState(() {
        _showClearButton = _searchController.text.isNotEmpty;
      });
    });
  }

  // Perform search
  void _performSearch() {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      setState(() {
        hasSearched = true;
      });
      ref.read(publishedCourseProvider.notifier).filterCourses(query);
      _saveSearch(query);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // Save a search term to SharedPreferences
  Future<void> _saveSearch(String query) async {
    if (query.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final searches = prefs.getStringList('recent_searches') ?? [];

    // Remove if already exists
    searches.removeWhere((item) => item.toLowerCase() == query.toLowerCase());

    // Add to beginning
    searches.insert(0, query);

    // Keep only last 5 searches
    if (searches.length > 5) {
      searches.removeLast();
    }

    await prefs.setStringList('recent_searches', searches);

    // Refresh the provider
    ref.refresh(recentSearchesProvider);
  }

  // Clear all recent searches
  Future<void> _clearRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recent_searches', []);

    // Refresh the provider
    ref.refresh(recentSearchesProvider);
  }

  @override
  Widget build(BuildContext context) {
    final publishedCoursesAsync = ref.watch(publishedCourseProvider);
    final recentSearchesAsync = ref.watch(recentSearchesProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Search header
            _buildSearchHeader(context),

            // Recent searches or results
            Expanded(
              child: publishedCoursesAsync.when(
                data: (courses) {
                  // Show recent searches if search is empty or not performed yet
                  if (!hasSearched) {
                    return recentSearchesAsync.when(
                      data: (searches) {
                        if (searches.isEmpty) {
                          // Show empty state instead of courses
                          return _buildEmptyInitialState();
                        }
                        return _buildRecentSearches(searches);
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (_, __) => const Center(
                          child: Text("Failed to load recent searches")),
                    );
                  }

                  // Filter and show courses
                  final notifier = ref.read(publishedCourseProvider.notifier);
                  final filteredCourses = notifier.filteredCourses;
                  if (filteredCourses.isEmpty) {
                    return _buildNoResultsFound();
                  }

                  return _buildCourseList(filteredCourses);
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Text("Error: $error"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back button
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[800]
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
              iconSize: 20,
            ),
          ),
          const Gap(12),

          // Search input field
          Expanded(
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[700]!
                      : Colors.grey[300]!,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/icons/search_icon.svg",
                    height: 20,
                    width: 20,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[400]!
                          : Colors.grey[600]!,
                      BlendMode.srcIn,
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: context.l10n!.searchCourses,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        hintStyle: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[400]
                              : Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 16,
                          ),
                      onSubmitted: (_) => _performSearch(),
                    ),
                  ),
                  if (_showClearButton)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() {
                          hasSearched = false;
                        });
                      },
                      child: Icon(
                        Icons.close,
                        size: 20,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[400]!
                            : Colors.grey[600]!,
                      ),
                    ),
                  const Gap(8),
                  // Search button
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: _performSearch,
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 22,
                      ),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 70,
            color: Colors.grey[300],
          ),
          const Gap(16),
          Text(
            'Start searching for courses',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
            textAlign: TextAlign.center,
          ),
          const Gap(8),
          Text(
            'Use the search box above',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearches(List<String> recentSearches) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Searches',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (recentSearches.isNotEmpty)
                TextButton(
                  onPressed: _clearRecentSearches,
                  child: Text(
                    'Clear',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const Gap(12),
          Expanded(
            child: ListView.builder(
              itemCount: recentSearches.length,
              itemBuilder: (context, index) {
                final search = recentSearches[index];
                return _buildRecentSearchItem(search);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearchItem(String search) {
    return InkWell(
      onTap: () {
        _searchController.text = search;
        _performSearch();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.history,
                size: 16,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[400]
                    : Colors.grey[600],
              ),
            ),
            const Gap(16),
            Expanded(
              child: Text(
                search,
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.north_west,
                size: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {
                _searchController.text = search;
                _performSearch();
              },
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseList(List courses) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 300),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return InkWell(
            onTap: () {
              ref.read(getCourseByIdProvider.notifier).setId(course.sId!);
              Nav().push(const CourseDetailsView());
            },
            child: CourseCard(
              priceType: course.priceType,
              title: course.name,
              price: currencyFormatter.format(course.price),
              imgPath:
                  course.image?.path ?? "assets/images/course_thumbnail.png",
            ),
          );
        },
      ),
    );
  }

  Widget _buildNoResultsFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 70,
            color: Colors.grey[300],
          ),
          const Gap(16),
          Text(
            'No results found',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
            textAlign: TextAlign.center,
          ),
          const Gap(8),
          Text(
            'Try different keywords',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
          const Gap(24),
          // Add a try again button
          ElevatedButton.icon(
            onPressed: () {
              _searchController.clear();
              setState(() {
                hasSearched = false;
              });
              _focusNode.requestFocus();
            },
            icon: const Icon(Icons.refresh),
            label: Text('New Search'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
