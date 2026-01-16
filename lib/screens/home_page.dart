import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal/components/adaptive_navigation.dart';
import 'package:journal/components/calendar_widget.dart';
import 'package:journal/screens/chat.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with AutomaticKeepAliveClientMixin {
  int screenIndex = 0;
  DateTime? _selectedDate;

  @override
  bool get wantKeepAlive => true;

  void handleScreenChanged(int selectedScreen) {
    setState(() {
      screenIndex = selectedScreen;
    });
  }

  Widget _buildCurrentScreen() {
    switch (screenIndex) {
      case 0: // Journal
        return _buildJournalContent();
      case 1: // Calendar
        return _buildCalendarContent();
      case 2: // Search
        return _buildChatContent();
      case 3: // Profile
        return _buildProfileContent();
      case 4: // Settings
        return _buildSettingsContent();
      default:
        return _buildJournalContent();
    }
  }

  Widget _buildJournalContent() {
    return Column(
      children: [
        const SizedBox(height: 30),
        
      ],
    );
  }

  Widget _buildCalendarContent() {
    return Center(
      child: CalendarWidget(
        selectedDate: _selectedDate,
        onDateSelected: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  Widget _buildChatContent() {
    return Center(
      child: Chat(),
    );
  }

  Widget _buildProfileContent() {
    return const Center(
      child: Text('Profile View', style: TextStyle(fontSize: 24)),
    );
  }

  Widget _buildSettingsContent() {
    return const Center(
      child: Text('Settings View', style: TextStyle(fontSize: 24)),
    );
  }

  Widget _buildStatCard(String value, String icon) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        color: Theme.of(context).colorScheme.surfaceVariant,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              icon,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveNavigation(
      selectedIndex: screenIndex,
      onDestinationSelected: handleScreenChanged,
      body: _buildCurrentScreen(),
    );
  }
}
