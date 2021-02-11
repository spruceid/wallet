import 'package:credible/app/shared/palette.dart';
import 'package:flutter/material.dart';

enum VerificationState {
  Unverified,
  Verified,
  VerifiedWithWarning,
  VerifiedWithError,
}

extension VerifyExtension on VerificationState {
  String get message {
    switch (this) {
      case VerificationState.Unverified:
        return 'Verifying...';
      case VerificationState.Verified:
        return 'Verified';
      case VerificationState.VerifiedWithWarning:
        return 'Verified (with warnings)';
      case VerificationState.VerifiedWithError:
        return 'Failed verification';
    }
  }

  IconData get icon {
    switch (this) {
      case VerificationState.Unverified:
        return Icons.refresh;
      case VerificationState.Verified:
        return Icons.check_circle_outline;
      case VerificationState.VerifiedWithWarning:
        return Icons.warning_amber_outlined;
      case VerificationState.VerifiedWithError:
        return Icons.error_outline;
    }
  }

  Color get color {
    switch (this) {
      case VerificationState.Unverified:
        return Palette.text;
      case VerificationState.Verified:
        return Colors.green;
      case VerificationState.VerifiedWithWarning:
        return Colors.orange;
      case VerificationState.VerifiedWithError:
        return Colors.red;
    }
  }
}
