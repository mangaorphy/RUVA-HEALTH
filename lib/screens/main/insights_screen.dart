import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cycle_provider.dart';
import '../../providers/education_provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/content_provider.dart';
import '../../widgets/content/insights_widgets.dart';
import '../education/products_guide_screen.dart';
import '../education/quiz_list_screen.dart';
import '../education/video_library_screen.dart';
import '../education/learning_content_screen.dart';
import 'notifications_screen.dart';
import '../../widgets/charts/symptom_trends_chart.dart';
import '../../widgets/content/for_you_content.dart';
import '../../widgets/content/community_hub.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late TextEditingController _searchController;
  String _searchQuery = '';
  List<Map<String, dynamic>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeController.forward();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
    _performSearch(_searchQuery);
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults.clear();
      });
      return;
    }

    final contentProvider = Provider.of<ContentProvider>(
      context,
      listen: false,
    );
    final filteredResults = contentProvider.searchContent(query);

    setState(() {
      _searchResults = filteredResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final cycleProvider = Provider.of<CycleProvider>(context);
    final educationProvider = Provider.of<EducationProvider>(context);

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : const Color(0xFFFDF2F8),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            pinned: true,
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFEC4899).withOpacity(0.1),
                    const Color(0xFF8B5CF6).withOpacity(0.1),
                  ],
                ),
              ),
            ),
            title: Container(
              height: 40,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFEC4899).withOpacity(0.2),
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => _onSearchChanged(),
                decoration: InputDecoration(
                  hintText: 'Search articles, topics...',
                  hintStyle: TextStyle(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[500],
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: 20,
                    color: const Color(0xFFEC4899),
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear_rounded,
                            size: 20,
                            color: Color(0xFFEC4899),
                          ),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged();
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            actions: [
              Consumer<NotificationProvider>(
                builder: (context, notificationProvider, child) {
                  final unreadCount = notificationProvider.unreadCount;

                  return Stack(
                    children: [
                      IconButton(
                        icon: Icon(
                          unreadCount > 0
                              ? Icons.notifications_active_rounded
                              : Icons.notifications_none_rounded,
                          color: const Color(0xFFEC4899),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationsScreen(),
                            ),
                          );
                        },
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFEC4899), Color(0xFF8B5CF6)],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              unreadCount > 99 ? '99+' : unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Search Results
                if (_searchQuery.isNotEmpty) ...[
                  _buildSearchResults(),
                  const SizedBox(height: 24),
                ] else ...[
                  // Personalized Dashboard
                  PersonalizedDashboard(
                    cycleProvider: cycleProvider,
                    theme: theme,
                  ),

                  const SizedBox(height: 24),

                  // Quick Access Section
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFEC4899), Color(0xFF8B5CF6)],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Quick Access',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode
                              ? Colors.white
                              : const Color(0xFF2D3748),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildQuickAccessGrid(educationProvider, theme),

                  const SizedBox(height: 24),

                  // Learning Journey
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFEC4899), Color(0xFF8B5CF6)],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Your Learning Journey',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode
                              ? Colors.white
                              : const Color(0xFF2D3748),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildLearningJourney(educationProvider, theme),

                  const SizedBox(height: 24),

                  // Health Insights
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFEC4899), Color(0xFF8B5CF6)],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Health Insights',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode
                              ? Colors.white
                              : const Color(0xFF2D3748),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildHealthInsights(cycleProvider, theme),

                  const SizedBox(height: 24),

                  // Symptom Trends
                  const SymptomTrendsChart(),

                  const SizedBox(height: 24),

                  // For You Content
                  const ForYouContent(),

                  const SizedBox(height: 24),

                  // Community Hub
                  const CommunityHub(),
                ],

                const SizedBox(height: 100), // Bottom padding for FAB
              ]),
            ),
          ),
        ],
      ),

      // Floating Action Button for quick learning
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFEC4899), Color(0xFF8B5CF6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFEC4899).withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => _showQuickLearningModal(context),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.school_rounded, size: 22),
          label: const Text(
            'Quick Learn',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    if (_searchResults.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFEC4899).withOpacity(0.1),
                    const Color(0xFF8B5CF6).withOpacity(0.1),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 48,
                color: Color(0xFFEC4899),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No results found for "$_searchQuery"',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : const Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Try searching for topics like "cycle", "symptoms", or "products"',
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search Results (${_searchResults.length})',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _searchResults.length,
          itemBuilder: (context, index) {
            final result = _searchResults[index];
            return _buildSearchResultItem(result, theme);
          },
        ),
      ],
    );
  }

  Widget _buildSearchResultItem(Map<String, dynamic> result, ThemeData theme) {
    IconData icon;
    Color color;

    switch (result['type']) {
      case 'article':
        icon = Icons.article_rounded;
        color = const Color(0xFFEC4899);
        break;
      case 'guide':
        icon = Icons.book_rounded;
        color = const Color(0xFF8B5CF6);
        break;
      case 'feature':
        icon = Icons.analytics_rounded;
        color = const Color(0xFFEC4899);
        break;
      case 'quiz':
        icon = Icons.quiz_rounded;
        color = const Color(0xFF8B5CF6);
        break;
      case 'videos':
        icon = Icons.play_circle_rounded;
        color = const Color(0xFFEC4899);
        break;
      case 'resources':
        icon = Icons.health_and_safety_rounded;
        color = const Color(0xFF8B5CF6);
        break;
      default:
        icon = Icons.help_rounded;
        color = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          result['title'],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(result['description']),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Handle navigation based on result type
          _handleSearchResultTap(result);
        },
      ),
    );
  }

  void _handleSearchResultTap(Map<String, dynamic> result) {
    switch (result['type']) {
      case 'guide':
        _navigateToProductsTab();
        break;
      case 'quiz':
        _navigateToQuiz();
        break;
      case 'videos':
        _navigateToVideos();
        break;
      case 'resources':
        _navigateToResources();
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening ${result['title']}...')),
        );
    }
  }

  Widget _buildQuickAccessGrid(
    EducationProvider educationProvider,
    ThemeData theme,
  ) {
    final quickActions = [
      {
        'title': 'Period Products',
        'description': 'Learn about different options',
        'icon': Icons.inventory_2_rounded,
        'color': const Color(0xFFEC4899),
        'badge': _buildNewBadge(),
        'onTap': () => _navigateToProductsTab(),
      },
      {
        'title': 'Cycle Quiz',
        'description': 'Test your knowledge',
        'icon': Icons.quiz_rounded,
        'color': const Color(0xFF8B5CF6),
        'badge': _buildProgressBadge(
          educationProvider.getOverallQuizProgress(),
        ),
        'onTap': () => _navigateToQuiz(),
      },
      {
        'title': 'Educational Videos',
        'description': 'Watch and learn',
        'icon': Icons.play_circle_rounded,
        'color': const Color(0xFFEC4899),
        'badge': _buildWatchTimeBadge(educationProvider.getTotalWatchTime()),
        'onTap': () => _navigateToVideos(),
      },
      {
        'title': 'Health Resources',
        'description': 'Expert advice & tips',
        'icon': Icons.health_and_safety_rounded,
        'color': const Color(0xFF8B5CF6),
        'badge': null,
        'onTap': () => _navigateToResources(),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.85,
      ),
      itemCount: quickActions.length,
      itemBuilder: (context, index) {
        final action = quickActions[index];
        return InteractiveContentCard(
          title: action['title'] as String,
          description: action['description'] as String,
          icon: action['icon'] as IconData,
          color: action['color'] as Color,
          onTap: action['onTap'] as VoidCallback,
          badge: action['badge'] as Widget?,
        );
      },
    );
  }

  Widget _buildLearningJourney(
    EducationProvider educationProvider,
    ThemeData theme,
  ) {
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFEC4899).withOpacity(0.1),
            const Color(0xFF8B5CF6).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFEC4899).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up_rounded,
                  color: Color(0xFFEC4899), size: 24),
              const SizedBox(width: 8),
              Text(
                'Your Progress',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : const Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildProgressItem(
            'Quizzes Completed',
            educationProvider.getCompletedQuizCount(),
            educationProvider.getTotalQuizCount(),
            const Color(0xFF8B5CF6),
            theme,
          ),
          const SizedBox(height: 12),
          _buildProgressItem(
            'Videos Watched',
            educationProvider.getWatchedVideoCount(),
            educationProvider.getTotalVideoCount(),
            const Color(0xFFEC4899),
            theme,
          ),
          const SizedBox(height: 12),
          _buildProgressItem(
            'Resources Explored',
            educationProvider.getExploredResourceCount(),
            educationProvider.getTotalResourceCount(),
            const Color(0xFF8B5CF6),
            theme,
          ),
          const SizedBox(height: 16),
          _buildAchievementBadges(educationProvider, theme),
        ],
      ),
    );
  }

  Widget _buildProgressItem(
    String label,
    int completed,
    int total,
    Color color,
    ThemeData theme,
  ) {
    final progress = total > 0 ? completed / total : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
            Text(
              '$completed/$total',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildAchievementBadges(
    EducationProvider educationProvider,
    ThemeData theme,
  ) {
    final achievements = educationProvider.getUnlockedAchievements();

    if (achievements.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            const Icon(Icons.emoji_events_outlined, color: Colors.amber),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Complete activities to unlock achievements!',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Wrap(
      spacing: 8,
      children: achievements
          .map(
            (achievement) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.amber.withOpacity(0.5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.emoji_events_rounded,
                    size: 14,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    achievement,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.amber.shade700,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildHealthInsights(CycleProvider cycleProvider, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics_rounded, color: Color(0xFFEC4899)),
              const SizedBox(width: 8),
              Text(
                'Cycle Analytics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildAnalyticCard(
                  'Avg Cycle',
                  '${cycleProvider.averageCycleLength} days',
                  _getCycleHealthStatus(cycleProvider.averageCycleLength),
                  theme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAnalyticCard(
                  'Regularity',
                  _getCycleRegularity(cycleProvider),
                  _getRegularityStatus(cycleProvider),
                  theme,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInsightTip(cycleProvider, theme),
        ],
      ),
    );
  }

  Widget _buildAnalyticCard(
    String label,
    String value,
    String status,
    ThemeData theme,
  ) {
    final statusColor = status == 'Normal'
        ? Colors.green
        : status == 'Irregular'
            ? Colors.orange
            : Colors.blue;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightTip(CycleProvider cycleProvider, ThemeData theme) {
    final tip = _getPersonalizedTip(cycleProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.1),
            theme.colorScheme.secondary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFEC4899).withOpacity(0.2),
                  const Color(0xFF8B5CF6).withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.lightbulb_rounded,
              size: 20,
              color: Color(0xFFEC4899),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Insight for You',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tip,
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Badge widgets
  Widget _buildNewBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEC4899), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'NEW',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildProgressBadge(double progress) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF8B5CF6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '${(progress * 100).toInt()}%',
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildWatchTimeBadge(int minutes) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEC4899),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '${minutes}m',
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  // Navigation methods
  void _navigateToProductsTab() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProductsGuideScreen()),
    );
  }

  void _navigateToQuiz() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QuizListScreen()),
    );

    // Refresh education provider to update quiz progress
    if (result != null) {
      final educationProvider = Provider.of<EducationProvider>(
        context,
        listen: false,
      );
      await educationProvider.refreshEducationProgress();
      setState(() {}); // Trigger rebuild to update progress display
    }
  }

  void _navigateToVideos() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VideoLibraryScreen()),
    );
  }

  void _navigateToResources() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Navigating to Resources...')));
  }

  void _showQuickLearningModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Quick Learning',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _buildQuickLearningItem(
                        'Menstrual Cycle Basics',
                        'Learn the fundamentals in 5 minutes',
                        Icons.school,
                        Colors.blue,
                      ),
                      _buildQuickLearningItem(
                        'Period Product Guide',
                        'Quick comparison of all options',
                        Icons.inventory,
                        Colors.pink,
                      ),
                      _buildQuickLearningItem(
                        'Tracking Your Symptoms',
                        'What to log and why it matters',
                        Icons.analytics,
                        Colors.green,
                      ),
                      _buildQuickLearningItem(
                        'Myths vs Facts',
                        'Common misconceptions debunked',
                        Icons.fact_check,
                        Colors.orange,
                      ),
                      _buildQuickLearningItem(
                        'Nutrition & Periods',
                        'Foods that help and hurt during your cycle',
                        Icons.restaurant,
                        Colors.purple,
                      ),
                      _buildQuickLearningItem(
                        'Exercise During Periods',
                        'Stay active and feel better',
                        Icons.fitness_center,
                        Colors.teal,
                      ),
                      _buildQuickLearningItem(
                        'When to See a Doctor',
                        'Warning signs and health concerns',
                        Icons.medical_services,
                        Colors.red,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickLearningItem(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.pop(context);
          _navigateToLearningContent(title);
        },
      ),
    );
  }

  void _navigateToLearningContent(String title) {
    final contentProvider = Provider.of<ContentProvider>(
      context,
      listen: false,
    );
    final content = contentProvider.learningContent[title];
    if (content != null) {
      final sectionsData = content['sections'] as List<dynamic>?;
      final processedSections = sectionsData?.map<Map<String, dynamic>>((
        section,
      ) {
        final sectionMap = section as Map<String, dynamic>;
        return {
          'title': sectionMap['title'],
          'content': sectionMap['content'],
          'icon': contentProvider.getIconForType(sectionMap['icon']),
        };
      }).toList();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LearningContentScreen(
            title: title,
            content: content['content'] as String,
            sections: processedSections,
          ),
        ),
      );
    }
  }

  // Helper methods
  String _getCycleHealthStatus(int avgLength) {
    if (avgLength >= 21 && avgLength <= 35) return 'Normal';
    if (avgLength < 21) return 'Short';
    return 'Long';
  }

  String _getCycleRegularity(CycleProvider cycleProvider) {
    if (cycleProvider.cycles.length < 3) return 'Need more data';
    return 'Regular'; // Simplified for now
  }

  String _getRegularityStatus(CycleProvider cycleProvider) {
    return 'Normal'; // Simplified for now
  }

  String _getPersonalizedTip(CycleProvider cycleProvider) {
    final day = cycleProvider.currentCycleDay;
    if (day <= 5) {
      return 'Focus on iron-rich foods to replenish what you lose during menstruation.';
    } else if (day <= 13) {
      return 'Great time to start new habits - your energy is naturally increasing!';
    } else if (day <= 16) {
      return 'Peak fertility window. Your body temperature may be slightly higher.';
    } else {
      return 'PMS symptoms are common now. Try stress-reduction techniques.';
    }
  }
}
