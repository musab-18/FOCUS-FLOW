import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/analytics_provider.dart' ;
import '../theme/app_theme.dart' ;

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final analytics = context.watch<AnalyticsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SectionHeader('Appearance'),
          _SettingsTile(
            icon: Icons.palette_rounded,
            label: 'Dark Mode',
            subtitle: analytics.themeMode == ThemeMode.dark
                ? 'Dark'
                : analytics.themeMode == ThemeMode.light
                    ? 'Light'
                    : 'System',
            onTap: () => _showThemePicker(context, analytics),
          ),
          _SettingsTile(
            icon: Icons.color_lens_rounded,
            label: 'Accent Color',
            trailing: CircleAvatar(backgroundColor: analytics.themeColor, radius: 12),
            onTap: () => _showColorPicker(context, analytics),
          ),
          const SizedBox(height: 20),
          _SectionHeader('Notifications'),
          _SettingsTile(
            icon: Icons.notifications_rounded,
            label: 'Push Notifications',
            trailing: Switch(
              value: analytics.notificationsEnabled,
              onChanged: (v) => analytics.setNotifications(v),
              activeColor: AppColors.deepCoral,
            ),
          ),
          const SizedBox(height: 20),
          _SectionHeader('Preferences'),
          _SettingsTile(
            icon: Icons.language_rounded,
            label: 'Language',
            subtitle: analytics.language,
            onTap: () => _showLanguagePicker(context, analytics),
          ),
          _SettingsTile(
            icon: Icons.category_rounded,
            label: 'Categories',
            onTap: () => Navigator.pushNamed(context, '/categories'),
          ),
          const SizedBox(height: 20),
          _SectionHeader('Account'),
          _SettingsTile(
            icon: Icons.workspace_premium_rounded,
            label: 'Subscription',
            onTap: () => Navigator.pushNamed(context, '/subscription'),
          ),
          _SettingsTile(
            icon: Icons.help_outline_rounded,
            label: 'Help & Feedback',
            onTap: () => Navigator.pushNamed(context, '/help'),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.deepCoral.withOpacity(0.06),
              borderRadius: BorderRadius.circular(14),
              border:
                  Border.all(color: AppColors.deepCoral.withOpacity(0.15)),
            ),
            child: Row(
              children: [
                const Icon(Icons.bolt_rounded,
                    color: AppColors.deepCoral, size: 20),
                const SizedBox(width: 10),
                Text('FocusFlow v1.0.0',
                    style: GoogleFonts.inter(
                        color: AppColors.deepCoral,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showThemePicker(BuildContext context, AnalyticsProvider analytics) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Choose Theme',
                style: GoogleFonts.inter(
                    fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            ...const [
              (ThemeMode.system, '🌐 System Default'),
              (ThemeMode.light, '☀️ Light'),
              (ThemeMode.dark, '🌙 Dark'),
            ].map((t) => ListTile(
                  title: Text(t.$2, style: GoogleFonts.inter()),
                  trailing: analytics.themeMode == t.$1
                      ? const Icon(Icons.check_rounded,
                          color: AppColors.deepCoral)
                      : null,
                  onTap: () {
                    analytics.setThemeMode(t.$1);
                    Navigator.pop(context);
                  },
                )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context, AnalyticsProvider analytics) {
    final colors = {
      'Coral': AppColors.deepCoral,
      'Teal': AppColors.teal,
      'Purple': AppColors.purple,
      'Orange': AppColors.orange,
      'Slate': AppColors.slateGrey,
    };
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Accent Color',
                style: GoogleFonts.inter(
                    fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: colors.entries.map((e) {
                final isSelected = analytics.themeColor.value == e.value.value;
                return GestureDetector(
                  onTap: () {
                    analytics.setThemeColor(e.value);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: e.value,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: AppColors.white, width: 3)
                          : null,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: e.value.withOpacity(0.5),
                                blurRadius: 8,
                                spreadRadius: 2,
                              )
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: AppColors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker(
      BuildContext context, AnalyticsProvider analytics) {
    final langs = ['English', 'Spanish', 'French', 'German', 'Arabic', 'Urdu'];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Language',
                style: GoogleFonts.inter(
                    fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            ...langs.map((l) => ListTile(
                  title: Text(l, style: GoogleFonts.inter()),
                  trailing: analytics.language == l
                      ? const Icon(Icons.check_rounded,
                          color: AppColors.deepCoral)
                      : null,
                  onTap: () {
                    analytics.setLanguage(l);
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(label.toUpperCase(),
          style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: AppColors.slateGrey)),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isDark ? AppColors.darkCard : const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.deepCoral, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.w500)),
                  if (subtitle != null)
                    Text(subtitle!,
                        style: GoogleFonts.inter(
                            fontSize: 12, color: AppColors.slateGrey)),
                ],
              ),
            ),
            trailing ??
                (onTap != null
                    ? const Icon(Icons.chevron_right_rounded,
                        color: AppColors.slateGrey)
                    : const SizedBox()),
          ],
        ),
      ),
    );
  }
}
