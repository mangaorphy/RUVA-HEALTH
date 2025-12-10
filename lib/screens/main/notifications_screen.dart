import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/auth_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize notifications when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notificationProvider = Provider.of<NotificationProvider>(
        context,
        listen: false,
      );
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Create sample notifications if user is authenticated and list is empty
      if (authProvider.isAuthenticated &&
          notificationProvider.notifications.isEmpty) {
        notificationProvider.createWelcomeNotification();
        notificationProvider.createSymptomTrackingReminder();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(0xFF000000) : const Color(0xFFF7FAFC),
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
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
          ),
        ),
        actions: [
          Consumer<NotificationProvider>(
            builder: (context, notificationProvider, child) {
              if (notificationProvider.unreadCount > 0) {
                return TextButton(
                  onPressed: () {
                    notificationProvider.markAllAsRead();
                  },
                  child: Text(
                    'Mark All Read',
                    style: TextStyle(
                      color: const Color(0xFFEC4899),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer2<NotificationProvider, AuthProvider>(
        builder: (context, notificationProvider, authProvider, child) {
          if (!authProvider.isAuthenticated) {
            return Center(
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(32),
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
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFFEC4899),
                            const Color(0xFF8B5CF6),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.login_rounded,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Sign in to see notifications',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color:
                            isDarkMode ? Colors.white : const Color(0xFF2D3748),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Get personalized reminders and updates about your cycle',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.7)
                            : const Color(0xFF4A5568),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      icon: const Icon(Icons.login_rounded, size: 20),
                      label: const Text('Sign In'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        backgroundColor: const Color(0xFFEC4899),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (notificationProvider.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: const Color(0xFFEC4899),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading notifications...',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.7)
                          : const Color(0xFF4A5568),
                    ),
                  ),
                ],
              ),
            );
          }

          final notifications = notificationProvider.notifications;

          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFEC4899).withOpacity(0.1),
                          const Color(0xFF8B5CF6).withOpacity(0.1),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.notifications_none_rounded,
                      size: 64,
                      color: const Color(0xFFEC4899),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No notifications yet',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color:
                          isDarkMode ? Colors.white : const Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Text(
                      'We\'ll notify you about important updates and reminders',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.7)
                            : const Color(0xFF4A5568),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return _buildNotificationItem(
                context,
                notification,
                notificationProvider,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    AppNotification notification,
    NotificationProvider notificationProvider,
  ) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: notification.isRead
            ? null
            : LinearGradient(
                colors: [
                  const Color(0xFFEC4899).withOpacity(0.05),
                  const Color(0xFF8B5CF6).withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        color: notification.isRead
            ? (isDarkMode ? Colors.grey[900] : Colors.white)
            : null,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notification.isRead
              ? (isDarkMode ? Colors.grey[800]! : Colors.grey[200]!)
              : const Color(0xFFEC4899).withOpacity(0.3),
          width: notification.isRead ? 1 : 2,
        ),
        boxShadow: notification.isRead
            ? []
            : [
                BoxShadow(
                  color: const Color(0xFFEC4899).withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            _handleNotificationTap(context, notification, notificationProvider);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _getNotificationColor(notification.type)
                            .withOpacity(0.2),
                        _getNotificationColor(notification.type)
                            .withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getNotificationIcon(notification.type),
                    color: _getNotificationColor(notification.type),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: notification.isRead
                                    ? FontWeight.w500
                                    : FontWeight.bold,
                                color:
                                    isDarkMode ? Colors.white : Colors.black87,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFEC4899),
                                    Color(0xFF8B5CF6)
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification.message,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatTimestamp(notification.timestamp),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color:
                              isDarkMode ? Colors.grey[500] : Colors.grey[500],
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete') {
                      notificationProvider.deleteNotification(notification.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Notification deleted'),
                          backgroundColor: const Color(0xFFEC4899),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    } else if (value == 'mark_read') {
                      notificationProvider.markAsRead(notification.id);
                    }
                  },
                  itemBuilder: (context) => [
                    if (!notification.isRead)
                      const PopupMenuItem(
                        value: 'mark_read',
                        child: Text('Mark as read'),
                      ),
                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                  icon: Icon(
                    Icons.more_vert,
                    color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleNotificationTap(
    BuildContext context,
    AppNotification notification,
    NotificationProvider notificationProvider,
  ) {
    notificationProvider.handleNotificationTap(notification);

    // Handle navigation based on notification type and action data
    if (notification.actionData != null) {
      final route = notification.actionData!['route'] as String?;
      if (route != null) {
        if (route == '/login') {
          Navigator.pushNamed(context, '/login');
        } else if (route == '/home') {
          Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
        }
      }
    }
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.welcome:
        return Icons.waving_hand;
      case NotificationType.loginReminder:
        return Icons.backup;
      case NotificationType.periodReminder:
        return Icons.event;
      case NotificationType.symptomReminder:
        return Icons.assignment;
      case NotificationType.general:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.welcome:
        return const Color(0xFF8B5CF6); // Purple
      case NotificationType.loginReminder:
        return const Color(0xFFEC4899); // Pink
      case NotificationType.periodReminder:
        return const Color(0xFFEC4899); // Pink
      case NotificationType.symptomReminder:
        return const Color(0xFF8B5CF6); // Purple
      case NotificationType.general:
        return const Color(0xFFEC4899); // Pink
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}
