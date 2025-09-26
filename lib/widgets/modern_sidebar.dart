import 'package:flutter/material.dart';

class ModernSidebar extends StatefulWidget {
  final Function(String) onNavigate;
  final String currentRoute;
  final bool isCollapsed;
  final VoidCallback onToggle;

  const ModernSidebar({
    Key? key,
    required this.onNavigate,
    required this.currentRoute,
    required this.isCollapsed,
    required this.onToggle,
  }) : super(key: key);

  @override
  _ModernSidebarState createState() => _ModernSidebarState();
}

class _ModernSidebarState extends State<ModernSidebar> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: widget.isCollapsed ? 70 : 280,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A2E),
        border: Border(
          right: BorderSide(color: Color(0xFF2D2D4A), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo and Title with Toggle
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                GestureDetector(
                  onTap: widget.onToggle,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: widget.isCollapsed 
                      ? const Icon(Icons.menu, color: Colors.white, size: 24)
                      : const Text(
                          '⚡',
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                  ),
                ),
                if (!widget.isCollapsed) ...[
                  const SizedBox(width: 12),
                  const Text(
                    'StorySpark',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // User Profile Section
          if (!widget.isCollapsed)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF252542),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF3D3D5C), width: 1),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => widget.onNavigate('login'),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xFF6366F1),
                      child: const Text(
                        'R',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => widget.onNavigate('login'),
                          child: const Text(
                            'Login / Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Text(
                              '⭐',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Join Community',
                              style: TextStyle(
                                color: Color(0xFF8B5CF6),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => widget.onNavigate('login'),
                    child: const Text(
                      '👤',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          
          const SizedBox(height: 32),
          
          // Navigation Menu
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildNavItemWithEmoji(
                  emoji: '🏠',
                  label: 'Home',
                  route: 'home',
                  isActive: widget.currentRoute == 'home',
                ),
                _buildNavItemWithEmoji(
                  emoji: '⚡',
                  label: 'Spark a Story',
                  route: 'create',
                  isActive: widget.currentRoute == 'create',
                ),
                _buildNavItemWithEmoji(
                  emoji: '📚',
                  label: 'Story Library',
                  route: 'library',
                  isActive: widget.currentRoute == 'library',
                ),
                _buildNavItemWithEmoji(
                  emoji: '❤️',
                  label: 'My Favorites',
                  route: 'favorites',
                  isActive: widget.currentRoute == 'favorites',
                ),
                _buildNavItemWithEmoji(
                  emoji: '🛍️',
                  label: 'Purchases',
                  route: 'purchases',
                  isActive: widget.currentRoute == 'purchases',
                ),
                
                const SizedBox(height: 24),
                if (!widget.isCollapsed) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Story Tools',
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                
                _buildNavItemWithEmoji(
                  emoji: '🎨',
                  label: 'Story Illustrations',
                  route: 'illustrations',
                  isActive: widget.currentRoute == 'illustrations',
                ),
                _buildNavItemWithEmoji(
                  emoji: '🎬',
                  label: 'Story Videos',
                  route: 'videos',
                  isActive: widget.currentRoute == 'videos',
                  badge: 'New',
                ),
                _buildNavItemWithEmoji(
                  emoji: '📖',
                  label: 'Print Books',
                  route: 'print',
                  isActive: widget.currentRoute == 'print',
                ),
                _buildNavItemWithEmoji(
                  emoji: '✏️',
                  label: 'Story Editor',
                  route: 'editor',
                  isActive: widget.currentRoute == 'editor',
                ),
                
                const SizedBox(height: 24),
                if (!widget.isCollapsed) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Advanced',
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                
                _buildNavItemWithEmoji(
                  emoji: '💡',
                  label: 'Writing Tips',
                  route: 'tips',
                  isActive: widget.currentRoute == 'tips',
                ),
                _buildNavItemWithEmoji(
                  emoji: '⭐',
                  label: 'Premium Plans',
                  route: 'premium',
                  isActive: widget.currentRoute == 'premium',
                ),
                _buildNavItemWithEmoji(
                  emoji: '⚙️',
                  label: 'Settings',
                  route: 'settings',
                  isActive: widget.currentRoute == 'settings',
                ),
                _buildNavItemWithEmoji(
                  emoji: '🎓',
                  label: 'Learn',
                  route: 'learn',
                  isActive: widget.currentRoute == 'learn',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    IconData? icon, // Made optional since we use emoji now
    required String label,
    required String route,
    required bool isActive,
    String? badge,
    bool hasExternalLink = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        leading: _buildIconWidget(route, isActive),
        title: widget.isCollapsed 
          ? null 
          : Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isActive ? Colors.white : const Color(0xFF9CA3AF),
                      fontSize: 14,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
                if (badge != null && !widget.isCollapsed)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                if (hasExternalLink && !widget.isCollapsed)
                  const Icon(
                    Icons.open_in_new,
                    color: Color(0xFF6B7280),
                    size: 16,
                  ),
              ],
            ),
        onTap: () => widget.onNavigate(route),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        tileColor: isActive ? const Color(0xFF252542) : Colors.transparent,
        hoverColor: const Color(0xFF252542),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  Widget _buildIconWidget(String route, bool isActive) {
    String iconText;
    switch (route) {
      case 'home':
        iconText = '🏠';
        break;
      case 'library':
        iconText = '📚';
        break;
      case 'create':
        iconText = '✨';
        break;
      case 'favorites':
        iconText = '❤️';
        break;
      case 'purchases':
        iconText = '🛍️';
        break;
      case 'illustrations':
        iconText = '🎨';
        break;
      case 'videos':
        iconText = '🎬';
        break;
      case 'print':
        iconText = '📖';
        break;
      case 'editor':
        iconText = '✏️';
        break;
      case 'tips':
        iconText = '💡';
        break;
      case 'premium':
        iconText = '⭐';
        break;
      case 'settings':
        iconText = '⚙️';
        break;
      case 'learn':
        iconText = '🎓';
        break;
      default:
        iconText = '📄';
    }
    
    return Container(
      width: 20,
      height: 20,
      child: Center(
        child: Text(
          iconText,
          style: TextStyle(
            fontSize: 16,
            color: isActive ? Colors.white : const Color(0xFF9CA3AF),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItemWithEmoji({
    required String emoji,
    required String label,
    required String route,
    required bool isActive,
    String? badge,
    bool hasExternalLink = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        leading: Text(
          emoji,
          style: TextStyle(
            fontSize: 20,
            color: isActive ? Colors.white : const Color(0xFF9CA3AF),
          ),
        ),
        title: widget.isCollapsed 
          ? null 
          : Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isActive ? Colors.white : const Color(0xFF9CA3AF),
                      fontSize: 14,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
                if (badge != null && !widget.isCollapsed)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                if (hasExternalLink && !widget.isCollapsed)
                  const Icon(
                    Icons.open_in_new,
                    color: Color(0xFF6B7280),
                    size: 16,
                  ),
              ],
            ),
        onTap: () => widget.onNavigate(route),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        tileColor: isActive ? const Color(0xFF252542) : Colors.transparent,
        hoverColor: const Color(0xFF252542),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}
