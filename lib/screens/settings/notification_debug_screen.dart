import 'package:flutter/material.dart';
import '../../services/notification_service.dart';

class NotificationDebugScreen extends StatefulWidget {
  const NotificationDebugScreen({super.key});

  @override
  State<NotificationDebugScreen> createState() =>
      _NotificationDebugScreenState();
}

class _NotificationDebugScreenState extends State<NotificationDebugScreen> {
  final NotificationService _notificationService = NotificationService();
  Map<String, dynamic>? _notificationStatus;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkNotificationStatus();
  }

  Future<void> _checkNotificationStatus() async {
    setState(() => _isLoading = true);
    try {
      final status = await _notificationService.getNotificationStatus();
      setState(() => _notificationStatus = status);
    } catch (e) {
      print('Error checking notification status: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testNotification() async {
    try {
      await _notificationService.testNotification();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Test notification sent! Check your notification panel.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending notification: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _testPeriodReminder() async {
    try {
      await _notificationService.schedulePeriodReminder(
        scheduledDate: DateTime.now().add(const Duration(days: 7)),
        daysUntilPeriod: 2,
        notificationId: 8888,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Period reminder scheduled for 2 minutes from now (for testing)',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error scheduling period reminder: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _testImmediatePeriodNotification() async {
    try {
      await _notificationService.showImmediateNotification(
        title: 'Period Reminder',
        body: 'Your period is expected in 2 days. Stay prepared!',
        payload: 'test_period_reminder',
        notificationId: 7777,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Immediate period notification sent!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending immediate notification: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Debug'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
            ),
          ),
        ),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notification System Status',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (_notificationStatus != null) ...[
                            _buildStatusRow(
                              'Initialized',
                              _notificationStatus!['is_initialized'],
                            ),
                            _buildStatusRow(
                              'Permissions Granted',
                              _notificationStatus!['permissions_granted'],
                            ),
                            _buildStatusRow(
                              'Platform',
                              _notificationStatus!['platform'],
                            ),
                            _buildStatusRow(
                              'Pending Notifications',
                              '${_notificationStatus!['pending_notifications_count']}',
                            ),
                          ] else
                            const Text('Loading status...'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _checkNotificationStatus,
                            child: const Text('Refresh Status'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Test Buttons
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Test Notifications',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Test immediate notification
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _testNotification,
                              icon: const Icon(
                                  Icons.notifications_active_rounded),
                              label: const Text('Test Immediate Notification'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8B5CF6),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Test period notification
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _testImmediatePeriodNotification,
                              icon: const Icon(Icons.favorite_rounded),
                              label: const Text('Test Period Notification'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFEC4899),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Test scheduled notification
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _testPeriodReminder,
                              icon: const Icon(Icons.schedule_rounded),
                              label: const Text('Schedule Test Reminder'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Pending Notifications
                  if (_notificationStatus != null &&
                      _notificationStatus!['pending_notifications_count'] >
                          0) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pending Notifications',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...(_notificationStatus!['pending_notifications']
                                    as List)
                                .map(
                              (notification) => Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading:
                                      const Icon(Icons.notifications_rounded),
                                  title: Text(
                                    notification['title'] ?? 'No title',
                                  ),
                                  subtitle: Text(
                                    notification['body'] ?? 'No body',
                                  ),
                                  trailing: Text(
                                    'ID: ${notification['id']}',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Troubleshooting Tips
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Troubleshooting Tips',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '• Check that notification permissions are enabled in device settings',
                          ),
                          const Text(
                            '• Ensure the app is not in battery optimization/doze mode',
                          ),
                          const Text(
                            '• Check Do Not Disturb settings on your device',
                          ),
                          const Text(
                            '• Try restarting the app after permission changes',
                          ),
                          const Text(
                            '• On Android: Check notification channels in app info',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatusRow(String label, dynamic value) {
    Color color = Colors.grey;
    Icon icon = const Icon(Icons.help_rounded, color: Colors.grey);

    if (value is bool) {
      color = value ? Colors.green : Colors.red;
      icon = Icon(value ? Icons.check_circle_rounded : Icons.error_rounded,
          color: color);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 8),
          Text('$label: '),
          Text(
            value.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
