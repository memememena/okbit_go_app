import 'package:flutter/material.dart';
import 'package:okbit_go_app/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:provider/provider.dart';
import '../providers/timetable_provider.dart';
import '../providers/meal_provider.dart';
import '../providers/navigation_provider.dart';
import '../models/meal.dart';
import '../routes.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            // TODO: 메뉴 열기
          },
        ),
        title: const Text(
          '옥빛GO!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {
              // TODO: 알림 페이지로 이동
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  _buildNoticeCard(),
                  const SizedBox(height: 12),
                  _buildSchoolLinkCard(),
                  const SizedBox(height: 16),
                  _buildMainCard(),
                  const SizedBox(height: 16),
                  _buildCalendarSection(),
                  const SizedBox(height: 16),
                  _buildSchoolNewsSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoticeCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // TODO: 공지사항 상세 페이지로 이동
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '공지사항',
                  style: TextStyle(
                    color: Colors.blue[400],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  '2024학년도 1학기 학사일정 안내',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSchoolLinkCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () async {
          final Uri url = Uri.parse('https://okbit-h.goedy.kr/okbit-h/main.do');
          if (await url_launcher.canLaunchUrl(url)) {
            await url_launcher.launchUrl(url,
                mode: url_launcher.LaunchMode.externalApplication);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '홈페이지',
                  style: TextStyle(
                    color: Colors.green[400],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  '옥빛고등학교',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.open_in_new, color: Colors.grey[600], size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _buildTimetableSection(),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _buildMealSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimetableSection() {
    return InkWell(
      onTap: () {
        context
            .read<NavigationProvider>()
            .goToTab(context, NavigationTab.schoolLife);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      '시간표',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Consumer<TimeTableProvider>(
                        builder: (context, provider, child) {
                          return Text(
                            provider.timeTable?.className ?? '1학년 3반',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Icon(Icons.chevron_right, color: Colors.grey[600], size: 20),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Consumer<TimeTableProvider>(
                builder: (context, provider, child) {
                  final timeTable = provider.timeTable;
                  if (timeTable == null) {
                    return Row(
                      children: [
                        _buildTimeSlot('1교시', '국어', '09:00'),
                        const SizedBox(width: 8),
                        _buildTimeSlot('2교시', '수학', '10:00'),
                        const SizedBox(width: 8),
                        _buildTimeSlot('3교시', '영어', '11:00'),
                        const SizedBox(width: 8),
                        _buildTimeSlot('4교시', '과학', '12:00'),
                      ],
                    );
                  }

                  if (timeTable.subjects.isEmpty) {
                    return Row(
                      children: [
                        _buildTimeSlot('1교시', '과목 없음', '09:00'),
                      ],
                    );
                  }

                  return Row(
                    children: List.generate(
                      timeTable.subjects[0].length,
                      (index) {
                        final startHour =
                            int.parse(timeTable.startTime.split(':')[0]);
                        return Row(
                          children: [
                            _buildTimeSlot(
                              '${index + 1}교시',
                              timeTable.subjects[0][index],
                              '${startHour + index}:00',
                            ),
                            if (index < timeTable.subjects[0].length - 1)
                              const SizedBox(width: 8),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlot(String time, String subject, String startTime) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            time,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subject,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            startTime,
            style: TextStyle(color: Colors.grey[600], fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildMealSection() {
    return Consumer<MealProvider>(
      builder: (context, provider, child) {
        final today = DateTime.now();
        final todayStr = DateFormat('yyyyMMdd').format(today);
        final todayMeal = provider.meals.firstWhere(
          (meal) => meal.date == todayStr,
          orElse: () => Meal(date: '', calorie: '', menu: []),
        );

        return InkWell(
          onTap: () {
            context
                .read<NavigationProvider>()
                .goToTab(context, NavigationTab.schoolLife);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          '급식',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            DateFormat('M월 d일').format(today),
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.chevron_right,
                        color: Colors.grey[600], size: 20),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF333333),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '중식',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          if (!provider.isLoading &&
                              provider.error == null &&
                              (todayMeal.date.isEmpty ||
                                  todayMeal.menu.isEmpty))
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    width: 1,
                                    height: 12,
                                    color: const Color(0xFF333333),
                                  ),
                                  Text(
                                    '오늘은 급식이 없습니다.',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      if (!(!provider.isLoading &&
                          provider.error == null &&
                          (todayMeal.date.isEmpty || todayMeal.menu.isEmpty)))
                        const SizedBox(height: 10),
                      if (provider.isLoading)
                        const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        )
                      else if (provider.error != null)
                        Text(
                          '급식 정보를 불러올 수 없습니다.',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      else if (todayMeal.date.isEmpty || todayMeal.menu.isEmpty)
                        Container()
                      else
                        Text(
                          todayMeal.menu.join(', '),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            height: 1.5,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCalendarSection() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          context
              .read<NavigationProvider>()
              .goToTab(context, NavigationTab.schoolLife);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '캘린더',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey[600], size: 20),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '일정을 추가해주세요',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSchoolNewsSection() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              // TODO: 학교소식 목록 페이지로 이동
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '학교소식',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '더보기',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey[500],
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: List.generate(3, (index) {
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      // TODO: 학교소식 상세 페이지로 이동
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '학교 동아리 발표회 성황리에 마쳐',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '2024.03.01',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (index < 2)
                    Container(height: 1, color: const Color(0xFF2A2A2A)),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
