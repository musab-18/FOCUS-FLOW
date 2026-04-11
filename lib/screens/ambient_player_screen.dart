import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/focus_provider.dart';
import '../theme/app_theme.dart';

class AmbientPlayerScreen extends StatelessWidget {
  const AmbientPlayerScreen({super.key});

  static const _sounds = [
    ('Rain', '🌧️', AppColors.info),
    ('Forest', '🌲', AppColors.success),
    ('Ocean', '🌊', AppColors.teal),
    ('Café', '☕', AppColors.orange),
    ('Fire', '🔥', AppColors.deepCoral),
    ('White Noise', '📻', AppColors.slateGrey),
    ('Thunder', '⛈️', AppColors.purple),
    ('Birds', '🐦', AppColors.mediumPriority),
  ];

  @override
  Widget build(BuildContext context) {
    final focus = context.watch<FocusProvider>();
    final currentSound = _sounds.firstWhere(
      (s) => s.$1 == focus.currentAmbient,
      orElse: () => _sounds.first,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Soundscape', 
          style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 20, color: AppColors.slateDark)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: AppColors.slateGrey),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. IMPROVED IMMERSIVE NOW PLAYING CARD
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    currentSound.$3, 
                    currentSound.$3.withValues(alpha: 0.7)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: currentSound.$3.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Hero(
                        tag: 'ambient_icon',
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Text(currentSound.$2, style: const TextStyle(fontSize: 40)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              focus.isAmbientPlaying ? 'IMMERSING IN' : 'READY TO PLAY',
                              style: GoogleFonts.inter(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Text(
                              focus.currentAmbient,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _PlayPauseButton(
                        isPlaying: focus.isAmbientPlaying,
                        onTap: focus.toggleAmbient,
                      ),
                    ],
                  ),
                  if (focus.isAmbientPlaying) ...[
                    const SizedBox(height: 24),
                    _VolumeSlider(),
                  ],
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Select Environment',
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.slateDark),
            ),
          ),
          const SizedBox(height: 16),

          // 2. REFINED GRID WITH INTERACTIVE TILES
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              itemCount: _sounds.length,
              itemBuilder: (ctx, i) {
                final s = _sounds[i];
                final isSelected = focus.currentAmbient == s.$1;
                final isPlaying = isSelected && focus.isAmbientPlaying;

                return GestureDetector(
                  onTap: () {
                    focus.setAmbient(s.$1);
                    if (!focus.isAmbientPlaying) focus.toggleAmbient();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: isSelected ? s.$3.withValues(alpha: 0.08) : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isSelected ? s.$3 : AppColors.slateLight,
                        width: isSelected ? 2.5 : 1.5,
                      ),
                      boxShadow: isSelected ? [
                        BoxShadow(color: s.$3.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))
                      ] : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(s.$2, style: const TextStyle(fontSize: 36)),
                        const SizedBox(height: 8),
                        Text(
                          s.$1,
                          style: GoogleFonts.inter(
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                            color: isSelected ? s.$3 : AppColors.slateGrey,
                            fontSize: 14,
                          ),
                        ),
                        if (isPlaying) const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: _WaveVisualizer(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayPauseButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onTap;
  const _PlayPauseButton({required this.isPlaying, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Icon(
          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          color: Colors.black,
          size: 32,
        ),
      ),
    );
  }
}

class _VolumeSlider extends StatefulWidget {
  @override
  State<_VolumeSlider> createState() => _VolumeSliderState();
}

class _VolumeSliderState extends State<_VolumeSlider> {
  double _val = 0.7;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.volume_mute_rounded, color: Colors.white, size: 18),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
              thumbColor: Colors.white,
              overlayColor: Colors.white.withValues(alpha: 0.2),
              trackHeight: 4,
            ),
            child: Slider(
              value: _val,
              onChanged: (v) => setState(() => _val = v),
            ),
          ),
        ),
        const Icon(Icons.volume_up_rounded, color: Colors.white, size: 18),
      ],
    );
  }
}

class _WaveVisualizer extends StatelessWidget {
  const _WaveVisualizer();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) => Container(
        width: 3,
        height: 12,
        margin: const EdgeInsets.symmetric(horizontal: 1),
        decoration: BoxDecoration(
          color: AppColors.slateDark.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(2),
        ),
      )), // In a real app, this would be an animated widget
    );
  }
}
