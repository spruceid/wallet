import 'package:credible/app/shared/widget/base/button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TapToUnlockPage extends StatelessWidget {
  final VoidCallback authenticate;

  const TapToUnlockPage({
    super.key,
    required this.authenticate,
  });

  @override
  Widget build(BuildContext context) => BasePage(
        scrollView: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BaseButton.primary(
              onPressed: authenticate,
              child: Text(
                'Unlock',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 16.0,
                  height: 1.375,
                ),
              ),
            ),
            const SizedBox(height: 128.0),
          ],
        ),
      );
}
