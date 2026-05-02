import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsController controller;
  const SettingsScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final palette = controller.value.theme.palette;
        return Scaffold(
          backgroundColor: palette.background,
          appBar: AppBar(
            backgroundColor: palette.background,
            elevation: 0,
            iconTheme: IconThemeData(color: palette.textPrimary),
            title: Text(
              'Settings',
              style: TextStyle(
                color: palette.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              _sectionHeader('Text size', palette),
              _sizePicker(palette),
              const SizedBox(height: 28),
              _sectionHeader('Theme', palette),
              _themePicker(palette),
              const SizedBox(height: 28),
              _sectionHeader('Reading font', palette),
              _fontPicker(palette),
              const SizedBox(height: 32),
              Text(
                'Settings apply across the whole app and are saved on this device.',
                style: TextStyle(
                  fontSize: 13,
                  color: palette.textMuted,
                  height: 1.4,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionHeader(String text, Palette p) => Padding(
        padding: const EdgeInsets.only(bottom: 12, left: 4),
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            letterSpacing: 1.8,
            fontWeight: FontWeight.w600,
            color: p.accent,
          ),
        ),
      );

  Widget _sizePicker(Palette p) {
    return Column(
      children: TextSizeOption.values.map((opt) {
        final selected = controller.value.textSize == opt;
        return _OptionTile(
          palette: p,
          selected: selected,
          title: opt.label,
          trailing: Text(
            'A',
            style: TextStyle(
              fontSize: 14 * opt.scale,
              color: p.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          onTap: () => controller.setTextSize(opt),
        );
      }).toList(),
    );
  }

  Widget _themePicker(Palette p) {
    return Column(
      children: AppThemeOption.values.map((opt) {
        final selected = controller.value.theme == opt;
        final swatch = opt.palette;
        return _OptionTile(
          palette: p,
          selected: selected,
          title: opt.label,
          leading: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: swatch.background,
              shape: BoxShape.circle,
              border: Border.all(color: p.cardBorder, width: 1),
            ),
            child: Center(
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: swatch.accent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          onTap: () => controller.setTheme(opt),
        );
      }).toList(),
    );
  }

  Widget _fontPicker(Palette p) {
    return Column(
      children: FontOption.values.map((opt) {
        final selected = controller.value.font == opt;
        final preview = opt == FontOption.classic
            ? GoogleFonts.playfairDisplay(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: p.textPrimary,
              )
            : GoogleFonts.atkinsonHyperlegible(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: p.textPrimary,
              );
        return _OptionTile(
          palette: p,
          selected: selected,
          title: opt.label,
          subtitle: opt.description,
          trailing: Text('Aa', style: preview),
          onTap: () => controller.setFont(opt),
        );
      }).toList(),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final Palette palette;
  final bool selected;
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback onTap;

  const _OptionTile({
    required this.palette,
    required this.selected,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected
            ? palette.accent.withOpacity(0.10)
            : palette.background,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? palette.accent : palette.cardBorder,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: 14),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: palette.textPrimary,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 13,
                            color: palette.textMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 12),
                  trailing!,
                ],
                const SizedBox(width: 8),
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: selected ? palette.accent : palette.textMuted,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
