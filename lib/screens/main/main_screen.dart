import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'calendar_screen.dart';
import 'insights_screen.dart';
import '../settings/settings_screen.dart';
import '../../providers/navigation_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _screens = [
    const HomeScreen(),
    const CalendarScreen(),
    const InsightsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navigationProvider = Provider.of<NavigationProvider>(context);

    return Scaffold(
      body: _screens[navigationProvider.selectedIndex],
      bottomNavigationBar: _buildCurvedBottomNavigationBar(
        context,
        navigationProvider,
        theme,
      ),
    );
  }

  Widget _buildCurvedBottomNavigationBar(
    BuildContext context,
    NavigationProvider navigationProvider,
    ThemeData theme,
  ) {
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      height: 70 + MediaQuery.of(context).padding.bottom,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
                  const Color(0xFF1F1F1F),
                  const Color(0xFF2A2A2A),
                ]
              : [
                  const Color(0xFFFDF2F8),
                  const Color(0xFFFCE7F3),
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : const Color(0xFFEC4899).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                icon: Icons.home_rounded,
                label: 'Home',
                index: 0,
                isSelected: navigationProvider.selectedIndex == 0,
                onTap: () => navigationProvider.setIndex(0),
                isDarkMode: isDarkMode,
              ),
              _buildNavItem(
                context,
                icon: Icons.calendar_month_rounded,
                label: 'Calendar',
                index: 1,
                isSelected: navigationProvider.selectedIndex == 1,
                onTap: () => navigationProvider.setIndex(1),
                isDarkMode: isDarkMode,
              ),
              _buildNavItem(
                context,
                icon: Icons.bar_chart_rounded,
                label: 'Insights',
                index: 2,
                isSelected: navigationProvider.selectedIndex == 2,
                onTap: () => navigationProvider.setIndex(2),
                isDarkMode: isDarkMode,
              ),
              _buildNavItem(
                context,
                icon: Icons.person_rounded,
                label: 'Profile',
                index: 3,
                isSelected: navigationProvider.selectedIndex == 3,
                onTap: () => navigationProvider.setIndex(3),
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFEC4899),
                          const Color(0xFF8B5CF6),
                        ],
                      )
                    : null,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 22,
                color: isSelected
                    ? Colors.white
                    : (isDarkMode
                        ? Colors.grey.shade400
                        : Colors.grey.shade600),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? (isDarkMode
                        ? const Color(0xFFEC4899)
                        : const Color(0xFF8B5CF6))
                    : (isDarkMode
                        ? Colors.grey.shade400
                        : Colors.grey.shade600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
