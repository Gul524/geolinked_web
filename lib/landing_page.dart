import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;
import 'constants/assets.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const _NavBar(),
            const _HeroSection(),
            const _FeaturesSection(),
            const _ScreenshotSection(),
            const _TeamSection(),
            const _Footer(),
          ],
        ),
      ),
    );
  }
}

Future<void> _downloadApk() async {
  if (kIsWeb) {
    // For Web, we create an anchor element and click it to trigger download
    final anchor = html.AnchorElement(href: AppAssets.appApk)
      ..setAttribute("download", "geolinked.apk")
      ..click();
  } else {
    // Fallback for other platforms
    final Uri url = Uri.parse(AppAssets.appApk);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}

class _NavBar extends StatelessWidget {
  const _NavBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Row(
        children: [
          Text(
            'GeoLinked',
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const Spacer(),
          if (!isMobile) ...[
            _NavLink('Features', () {}),
            _NavLink('Screenshots', () {}),
            _NavLink('Team', () {}),
            const SizedBox(width: 20),
          ],
          ElevatedButton(
            onPressed: () {
              _downloadApk();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text('Download'),
          ),
        ],
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const _NavLink(this.title, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextButton(
        onPressed: onTap,
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: isMobile ? 40 : 100,
      ),
      child: Flex(
        direction: isMobile ? Axis.vertical : Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: isMobile ? 0 : 1,
            child: Column(
              crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
              children: [
                Text(
                  'Connecting Communities,\nOne Radius at a Time.',
                  textAlign: isMobile ? TextAlign.center : TextAlign.left,
                  style: GoogleFonts.outfit(
                    fontSize: isMobile ? 36 : 56,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 20),
                Text(
                  'GeoLinked is a location-based messaging platform that lets you broadcast updates and ask questions to people nearby. Stay informed, stay safe, and stay connected.',
                  textAlign: isMobile ? TextAlign.center : TextAlign.left,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
                  children: [
                    _DownloadButton(
                      Icons.download_rounded,
                      'Download APK',
                      () => _downloadApk(),
                    ),
                  ],
                ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
              ],
            ),
          ),
          if (!isMobile) const SizedBox(width: 80),
          Expanded(
            flex: isMobile ? 0 : 1,
            child: Padding(
              padding: EdgeInsets.only(top: isMobile ? 60 : 0),
              child: _PhoneMockup(AppAssets.screenshot1),
            ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.8, 0.8)),
          ),
        ],
      ),
    );
  }
}

class _DownloadButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  const _DownloadButton(this.icon, this.label, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        side: const BorderSide(color: Colors.black12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _PhoneMockup extends StatelessWidget {
  final String imagePath;
  const _PhoneMockup(this.imagePath);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        height: 600,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: const Color(0xFF333333), width: 8),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.2),
              blurRadius: 100,
              spreadRadius: 20,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey[900],
              child: const Icon(Icons.smartphone, color: Colors.white, size: 50),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeaturesSection extends StatelessWidget {
  const _FeaturesSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          Text(
            'Why GeoLinked?',
            style: GoogleFonts.outfit(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          const Text(
            'Smart features designed for your community',
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
          const SizedBox(height: 60),
          Wrap(
            spacing: 30,
            runSpacing: 30,
            alignment: WrapAlignment.center,
            children: const [
              _FeatureCard(
                icon: Icons.map_outlined,
                title: 'Interactive Map',
                description: 'Real-time local awareness with marker clustering and dynamic search.',
              ),
              _FeatureCard(
                icon: Icons.campaign_outlined,
                title: 'Local Broadcasts',
                description: 'Share traffic alerts, safety warnings, and events with neighbors instantly.',
              ),
              _FeatureCard(
                icon: Icons.help_outline,
                title: 'Community Asks',
                description: 'Ask questions to people physically located in specific areas.',
              ),
              _FeatureCard(
                icon: Icons.security_outlined,
                title: 'Privacy First',
                description: 'Granular data control and permanent account deletion for your peace of mind.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.blue, size: 30),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(color: Colors.black54, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _ScreenshotSection extends StatelessWidget {
  const _ScreenshotSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100),
      child: Column(
        children: [
          Text(
            'App Screenshots',
            style: GoogleFonts.outfit(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 60),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              children: [
                _ScreenshotItem(AppAssets.screenshot1),
                _ScreenshotItem(AppAssets.screenshot2),
                _ScreenshotItem(AppAssets.screenshot3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScreenshotItem extends StatelessWidget {
  final String imagePath;
  const _ScreenshotItem(this.imagePath);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 250,
          height: 500,
          color: Colors.grey[200],
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.image)),
          ),
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.1, end: 0);
  }
}

class _TeamSection extends StatelessWidget {
  const _TeamSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          Text(
            'Meet the Team',
            style: GoogleFonts.outfit(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 60),
          Wrap(
            spacing: 40,
            runSpacing: 40,
            alignment: WrapAlignment.center,
            children: const [
              _TeamMemberCard('Suleman Gul', 'Lead Developer'),
              _TeamMemberCard('Ahmed Luqman', 'Backend Engineer'),
              _TeamMemberCard('MHassan', 'UI/UX Designer'),
            ],
          ),
        ],
      ),
    );
  }
}

class _TeamMemberCard extends StatelessWidget {
  final String name;
  final String role;
  const _TeamMemberCard(this.name, this.role);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.blue.withOpacity(0.1),
          child: Text(
            name[0],
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          role,
          style: const TextStyle(color: Colors.black54),
        ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
      color: const Color(0xFF111827),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'GeoLinked',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Text(
                '© 2026 GeoLinked. All rights reserved.',
                style: TextStyle(color: Colors.white54),
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Divider(color: Colors.white10),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.link, color: Colors.white54)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.code, color: Colors.white54)),
            ],
          ),
        ],
      ),
    );
  }
}
