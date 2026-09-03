import 'dart:async';

import 'package:flutter/material.dart';
import 'api_client.dart';
import 'auth_service.dart';
import 'cart_manager.dart';
import 'generated/app_localizations.dart';
import 'home_page.dart';
import 'locale_manager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Testing-phase-only: the backend doesn't deliver OTPs yet (see OtpService),
  // so login is a single step — request + verify are chained behind the "Send
  // OTP" button using this placeholder code, which the backend's OTP bypass
  // ignores. Remove this once real OTP delivery ships and restore the
  // separate verify-code step.
  static const _bypassOtp = '000000';

  final _identifierController = TextEditingController();
  final _referralCodeController = TextEditingController();
  final _authService = AuthService();

  bool _isSubmitting = false;
  bool _showReferralField = false;
  String? _errorMessage;

  static final _phonePattern = RegExp(r'^[6-9]\d{9}$');
  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  bool get _isValidIdentifier {
    final value = _identifierController.text.trim();
    return _phonePattern.hasMatch(value) || _emailPattern.hasMatch(value);
  }

  // Numeric keypad while the input still looks like the start of a phone
  // number (digits only, or empty — phone is the more common path), an
  // email-friendly keyboard (with "@") once it clearly isn't.
  TextInputType get _keyboardType {
    final value = _identifierController.text.trim();
    final looksLikePhoneSoFar = RegExp(r'^\d*$').hasMatch(value);
    return looksLikePhoneSoFar ? TextInputType.phone : TextInputType.emailAddress;
  }

  IconData get _identifierIcon {
    final value = _identifierController.text.trim();
    if (value.isEmpty) return Icons.person_outline;
    if (_phonePattern.hasMatch(value)) return Icons.phone_android_outlined;
    if (value.contains('@')) return Icons.email_outlined;
    return Icons.person_outline;
  }

  Future<void> _onSendOtp() async {
    if (!_isValidIdentifier) {
      setState(() => _errorMessage = S.of(context)!.invalidLoginInput);
      return;
    }
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });
    try {
      await _authService.requestOtp(_identifierController.text);
      await _authService.verifyOtp(
        _identifierController.text,
        _bypassOtp,
        referralCode: _referralCodeController.text,
      );
      if (!mounted) return;
      unawaited(CartProvider.of(context).loadCart());
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
    } on ApiException catch (_) {
      if (!mounted) return;
      setState(() => _errorMessage = S.of(context)!.otpRequestFailed);
    } catch (_) {
      // Anything else (no network, DNS/host lookup failure, timeout, …) —
      // still surface *something* rather than leaving the button just stop
      // spinning with no explanation.
      if (!mounted) return;
      setState(() => _errorMessage = S.of(context)!.genericErrorMessage);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _referralCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localeNotifier = LocaleProvider.of(context);
    final currentLocale = localeNotifier.value ?? const Locale('en');
    final isEnglish = currentLocale.languageCode == 'en';
    final l10n = S.of(context)!;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFFF8FAFF)),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: Padding(
                  padding: const EdgeInsets.all(26),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withAlpha(36),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.lock_outline_rounded,
                            size: 34,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.appTitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.loginTitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.loginSubtitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${l10n.languageLabel}:',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () =>
                                  localeNotifier.setLocale(const Locale('en')),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                                backgroundColor: isEnglish
                                    ? theme.colorScheme.primary
                                    : null,
                                foregroundColor: isEnglish
                                    ? theme.colorScheme.onPrimary
                                    : null,
                                side: BorderSide(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              child: FittedBox(child: Text(l10n.english)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () =>
                                  localeNotifier.setLocale(const Locale('te')),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                                backgroundColor: !isEnglish
                                    ? theme.colorScheme.primary
                                    : null,
                                foregroundColor: !isEnglish
                                    ? theme.colorScheme.onPrimary
                                    : null,
                                side: BorderSide(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              child: FittedBox(child: Text(l10n.telugu)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Text(
                        l10n.phoneOrEmailLabel,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _identifierController,
                        keyboardType: _keyboardType,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [
                          AutofillHints.telephoneNumber,
                          AutofillHints.email,
                        ],
                        decoration: InputDecoration(
                          hintText: l10n.phoneOrEmailHint,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          prefixIcon: Icon(_identifierIcon),
                        ),
                        onChanged: (_) =>
                            setState(() => _errorMessage = null),
                        onSubmitted: (_) {
                          if (_isValidIdentifier && !_isSubmitting) {
                            _onSendOtp();
                          }
                        },
                      ),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 13,
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () => setState(
                            () => _showReferralField = !_showReferralField,
                          ),
                          icon: Icon(
                            _showReferralField
                                ? Icons.expand_less
                                : Icons.card_giftcard_outlined,
                            size: 18,
                          ),
                          label: Text(l10n.haveReferralCode),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ),
                      if (_showReferralField) ...[
                        const SizedBox(height: 8),
                        TextField(
                          controller: _referralCodeController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                            hintText: l10n.referralCodeHint,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            prefixIcon: const Icon(
                              Icons.card_giftcard_outlined,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: _isValidIdentifier && !_isSubmitting
                            ? _onSendOtp
                            : null,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(l10n.sendOtpButton),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
