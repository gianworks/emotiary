import "package:flutter/material.dart";
import "package:icons_plus/icons_plus.dart";
import "package:emotiary/core/theme/app_colors.dart";
import "package:emotiary/core/theme/app_text_styles.dart";
import "package:emotiary/core/utils/date_time_utils.dart";
import "package:emotiary/core/utils/quill_utils.dart";
import "package:emotiary/core/helpers/navigation_helper.dart";
import "package:emotiary/data/models/entry.dart";
import "package:emotiary/screens/home/entry_details_screen.dart";
import "package:emotiary/widgets/primary_search_bar.dart";
import "package:emotiary/widgets/primary_card.dart";

class HomeScreen extends StatefulWidget {
  final List<Entry> entries;
  final Function(Entry entry) onDeleteEntry;
  final Function(Entry entry) onEditEntry;

  const HomeScreen({
    super.key,
    required this.entries,
    required this.onDeleteEntry,
    required this.onEditEntry
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FocusNode _searchBarFocusNode = FocusNode();

  Map<String, List<Entry>> _groupedEntries = {};

  void _groupEntriesByDate(List<Entry> entries) {
    // Sort entries by descending date
    entries.sort((a, b) => DateTimeUtils.parse(b.date).compareTo(DateTimeUtils.parse(a.date)));

    // Group entries by date
    Map<String, List<Entry>> grouped = {};
    for (var entry in entries) {
      grouped.putIfAbsent(entry.date, () => []);
      grouped[entry.date]!.add(entry);
    }
    _groupedEntries = grouped;
  }

 void _filterEntries(String query) {
    // Get filtered entries by title, mood, or activity
    final List<Entry> filteredEntries = widget.entries.where((entry) {
      final bool isTitleMatched = QuillUtils.jsonToPlainText(entry.titleJson).toLowerCase().contains(query.toLowerCase());
      final bool isMoodMatched = entry.mood.toLowerCase().contains(query.toLowerCase());
      final bool isActivityMatched = entry.activities.keys.any((key) => key.toLowerCase().contains(query.toLowerCase()));

      return isTitleMatched || isMoodMatched || isActivityMatched;
    }).toList();

    setState(() => _groupEntriesByDate(filteredEntries));
  }

  void _goToEntryDetailsScreen(Entry entry) {
    NavigationHelper.push(
      EntryDetailsScreen(
        entry: entry, 
        onDeleteEntry: widget.onDeleteEntry,
        onEditEntry: widget.onEditEntry
      ), 
      context
    );
  }

  @override 
  void initState() {
    super.initState();
    _groupEntriesByDate(widget.entries);
    _searchBarFocusNode.addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.entries != widget.entries) {
      _groupEntriesByDate(widget.entries);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _searchBarFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 16),
      children: [
        const SizedBox(height: 32),
        Text("Journal Entries", style: AppTextStyles.headlineLarge),
        const SizedBox(height: 4),
        Text("You've written ${widget.entries.length} entries so far", style: AppTextStyles.bodyLarge),
        const SizedBox(height: 32),
        PrimarySearchBar(
          height: 40, 
          focusNode: _searchBarFocusNode,
          leading: Icon(AntDesign.search_outline, color: (_searchBarFocusNode.hasFocus) ? AppColors.brownSugar : AppColors.warmGray),
          hintText: "Search by title, mood, or activity..", 
          hintStyle: TextStyle(fontSize: 14, color: AppColors.warmGray), 
          textStyle: TextStyle(fontSize: 16, color: AppColors.brownSugar, fontWeight: FontWeight.w500),
          onChanged: _filterEntries
        ),
        const SizedBox(height: 8),
        if (widget.entries.isNotEmpty && _groupedEntries.isNotEmpty) ...[
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _groupedEntries.length,
            itemBuilder: (_, index) {
              final String date = _groupedEntries.keys.elementAt(index);
              final List<Entry> entriesByDate = _groupedEntries[date]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(DateTimeUtils.formateRelativeDate(date), style: AppTextStyles.titleSmall),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: entriesByDate.length,
                    itemBuilder: (_, index) {
                      final int reverseIndex = entriesByDate.length - 1 - index;
                      final Entry entry = entriesByDate[reverseIndex];

                      return PrimaryCard(
                        onTap: () => _goToEntryDetailsScreen(entry),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(16),
                        content: Row(
                          children: [
                            const SizedBox(width: 8),
                            Column(
                              children: [
                                Text(entry.moodEmoji, style: const TextStyle(fontSize: 32)),
                                Text(entry.mood, style: const TextStyle(fontSize: 14, color: AppColors.darkBrown, fontWeight: FontWeight.w500))
                              ]
                            ),
                            const SizedBox(width: 24),
                            SizedBox(
                              width: 200,
                              child: IgnorePointer(
                                child : Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      QuillUtils.jsonToPlainText(entry.titleJson), 
                                      style: AppTextStyles.titleSmall,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      QuillUtils.jsonToPlainText(entry.textJson).trim(), 
                                      style: AppTextStyles.bodyMedium, 
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 4
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: entry.activities.entries.map(
                                        (activity) => Text("${activity.value} ${activity.key.toLowerCase()}", style: AppTextStyles.bodyMedium)
                                      ).toList()
                                    )
                                  ]
                                )
                              )
                            ),
                            const SizedBox(width: 32),
                            const Icon(AntDesign.right_outline, size: 16, color: AppColors.taupeGray)
                          ]
                        )
                      );
                    }
                  )
                ]
              );
            }
          ),
          const SizedBox(height: 32)
        ]
        else if (widget.entries.isEmpty) ...[
          const SizedBox(height: 128),
          const Text("Your journal is empty.\nTap the write button to begin.", style: AppTextStyles.bodyMedium, textAlign: TextAlign.center)
        ] 
        else if (_groupedEntries.isEmpty) ...[
          const SizedBox(height: 128),
          const Text("No matches found.\nMaybe try another title, mood, or activity?", style: AppTextStyles.bodyMedium, textAlign: TextAlign.center)
        ]
      ]
    );
  }
}
