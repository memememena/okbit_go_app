import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../providers/meal_provider.dart';
import '../providers/timetable_provider.dart';
import '../widgets/school_life/meal/meal_list_item.dart';
import '../widgets/school_life/timetable/timetable_grid.dart';
import '../widgets/school_life/calendar/calendar_grid.dart';
import '../widgets/school_life/calendar/calendar_header.dart';
import '../widgets/school_life/calendar/weekday_header.dart';
import '../widgets/school_life/calendar/schedule_item.dart';
import '../widgets/school_life/allergy/allergy_info_card.dart';
import '../widgets/school_life/allergy/allergy_info_dialog.dart';
import '../models/meal.dart';
import '../models/event.dart';
import '../utils/constants.dart';

class SchoolLifeScreen extends StatefulWidget {
  const SchoolLifeScreen({super.key});

  @override
  State<SchoolLifeScreen> createState() => _SchoolLifeScreenState();
}

class _SchoolLifeScreenState extends State<SchoolLifeScreen>
    with SingleTickerProviderStateMixin {
  static const _kTabCount = 3;

  late final TabController _tabController;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  final Map<DateTime, List<Event>> _events = {};

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadInitialData();
  }

  void _initializeControllers() {
    _tabController = TabController(length: _kTabCount, vsync: this);
    initializeDateFormatting(kLocale, null);
  }

  Future<void> _loadInitialData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeProviders();
    });
  }

  Future<void> _initializeProviders() async {
    final mealProvider = context.read<MealProvider>();
    final timeTableProvider = context.read<TimeTableProvider>();

    if (!mealProvider.isInitialized) {
      await mealProvider.fetchMeals();
    }

    if (!timeTableProvider.isInitialized) {
      await timeTableProvider.fetchTimeTable();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  String _getFormattedDate(DateTime date) {
    final formatter = DateFormat('M월 d일 (E)', kLocale);
    return formatter.format(date);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: kBackgroundColor,
      elevation: 0,
      title: const Text(kSchoolLifeTitle, style: kTitleStyle),
      centerTitle: true,
      bottom: TabBar(
        controller: _tabController,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[500],
        labelStyle: kTabStyle,
        unselectedLabelStyle: kUnselectedTabStyle,
        tabs: const [
          Tab(text: '시간표'),
          Tab(text: '급식'),
          Tab(text: '캘린더'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildTimeTableTab(),
          _buildMealTab(),
          _buildCalendarTab(),
        ],
      ),
    );
  }

  Widget _buildErrorView(String message, VoidCallback onRetry) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: kSpacing),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text(kRetryButtonText),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildTimeTableTab() {
    return Consumer<TimeTableProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                provider.message ?? '시간표를 불러오는 중입니다...',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
            ],
          );
        }

        if (provider.error != null) {
          return _buildErrorView(
            provider.message ?? '시간표를 불러오는데 실패했습니다.',
            () => provider.fetchTimeTable(forceRefresh: true),
          );
        }

        if (provider.timeTable == null) {
          return _buildErrorView(
            provider.message ?? '시간표 데이터가 없습니다.',
            () => provider.fetchTimeTable(forceRefresh: true),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.fetchTimeTable(forceRefresh: true),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TimeTableGrid(timeTable: provider.timeTable!),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMealTab() {
    return Consumer<MealProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return _buildLoadingView();
        }

        if (provider.error != null) {
          return _buildErrorView(
            kLoadFailedMessage,
            () => provider.fetchMeals(forceRefresh: true),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.fetchMeals(forceRefresh: true),
          child: ListView(
            padding: const EdgeInsets.all(kSpacing),
            children: [
              AllergyInfoCard(onTap: _showAllergyInfoDialog),
              if (provider.meals.isEmpty)
                _buildErrorView(
                  kNoDataMessage,
                  () => provider.fetchMeals(forceRefresh: true),
                )
              else
                ..._buildMealList(provider.meals),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildMealList(List<Meal> meals) {
    return meals
        .map((meal) => Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: MealListItem(meal: meal),
            ))
        .toList();
  }

  void _showAllergyInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => const AllergyInfoDialog(),
    );
  }

  Widget _buildCalendarTab() {
    return Container(
      color: kSurfaceColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Column(
              children: [
                CalendarHeader(
                  focusedDay: _focusedDay,
                  onPreviousMonth: () {
                    setState(() {
                      _focusedDay = DateTime(
                        _focusedDay.year,
                        _focusedDay.month - 1,
                        1,
                      );
                    });
                  },
                  onNextMonth: () {
                    setState(() {
                      _focusedDay = DateTime(
                        _focusedDay.year,
                        _focusedDay.month + 1,
                        1,
                      );
                    });
                  },
                ),
                const SizedBox(height: 16),
                const WeekdayHeader(),
                CalendarGrid(
                  focusedDay: _focusedDay,
                  selectedDay: _selectedDay,
                  events: _events,
                  onDaySelected: (date) {
                    setState(() {
                      _selectedDay = date;
                    });
                  },
                ),
              ],
            ),
          ),
          if (_getEventsForDay(_selectedDay).isNotEmpty) ...[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                _getFormattedDate(_selectedDay),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: kSurfaceColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: ListView.separated(
                  itemCount: _getEventsForDay(_selectedDay).length,
                  separatorBuilder: (context, index) => const Divider(
                    color: kBorderColor,
                    height: 32,
                    thickness: 1,
                  ),
                  itemBuilder: (context, index) {
                    final event = _getEventsForDay(_selectedDay)[index];
                    return ScheduleItem(
                      description: event.description,
                      title: event.title,
                      isToday: _isSameDay(_selectedDay, DateTime.now()),
                    );
                  },
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
