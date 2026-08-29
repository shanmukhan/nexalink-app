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
  final _identifierController = TextEditingController();
  final _otpController = TextEditingController();
  final _referralCodeController = TextEditingController();
  final _authService = AuthService();

  bool _otpSent = false;
  bool _isSubmitting = false;
  String? _errorMessage;

  bool get _isValidIdentifier {
    final value = _identifierController.text.trim();
    final phonePattern = RegExp(r'^[6-9]\d{9}$');
    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return phonePattern.hasMatch(value) || emailPattern.hasMatch(value);
  }

  bool get _isValidOtp => RegExp(r'^\d{6}$').hasMatch(_otpController.text.trim());

  Future<void> _onSendOtp() async {
    if (!_isValidIdentifier) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context)!.invalidLoginInput)),
      );
      return;
    }
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });
    try {
      await _authService.requestOtp(_identifierController.text);
      if (!mounted) return;
      setState(() => _otpSent = true);
    } on ApiException catch (_) {
      if (!mounted) return;
      setState(() => _errorMessage = S.of(context)!.otpRequestFailed);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _onVerifyOtp() async {
    if (!_isValidOtp) return;
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });
    try {
      await _authService.verifyOtp(_identifierController.text, _otpController.text, referralCode: _referralCodeController.text);
      if (!mounted) return;
      unawaited(CartProvider.of(context).loadCart());
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } on ApiException catch (_) {
      if (!mounted) return;
      setState(() => _errorMessage = S.of(context)!.otpVerifyFailed);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _otpController.dispose();
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
        decoration: const BoxDecoration(
          color: Color(0xFFF8FAFF),
        ),
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
                      const SizedBox(height: 20),
                      Text(
                        l10n.loginTitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _otpSent ? l10n.otpSentSubtitle(_identifierController.text.trim()) : l10n.loginSubtitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                      if (!_otpSent) ...[
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${l10n.languageLabel}:',
                              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => localeNotifier.setLocale(const Locale('en')),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  backgroundColor: isEnglish ? theme.colorScheme.primary : null,
                                  foregroundColor: isEnglish ? theme.colorScheme.onPrimary : null,
                                  side: BorderSide(color: theme.colorScheme.primary),
                                ),
                                child: FittedBox(child: Text(l10n.english)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => localeNotifier.setLocale(const Locale('te')),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  backgroundColor: !isEnglish ? theme.colorScheme.primary : null,
                                  foregroundColor: !isEnglish ? theme.colorScheme.onPrimary : null,
                                  side: BorderSide(color: theme.colorScheme.primary),
                                ),
                                child: FittedBox(child: Text(l10n.telugu)),
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 28),
                      if (!_otpSent) ...[
                        Text(
                          l10n.phoneOrEmailLabel,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _identifierController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: l10n.phoneOrEmailHint,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            prefixIcon: const Icon(Icons.person_outline),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: _referralCodeController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                            hintText: l10n.referralCodeHint,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            prefixIcon: const Icon(Icons.card_giftcard_outlined),
                          ),
                        ),
                        const SizedBox(height: 20),
                        FilledButton(
                          onPressed: _isValidIdentifier && !_isSubmitting ? _onSendOtp : null,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : Text(l10n.sendOtpButton),
                        ),
                      ] else ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.otpHint,
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            TextButton(
                              onPressed: _isSubmitting
                                  ? null
                                  : () => setState(() {
                                        _otpSent = false;
                                        _otpController.clear();
                                        _errorMessage = null;
                                      }),
                              child: Text(l10n.changeNumberLabel),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _otpController,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          decoration: InputDecoration(
                            hintText: l10n.otpHint,
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            prefixIcon: const Icon(Icons.password_outlined),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 20),
                        FilledButton(
                          onPressed: _isValidOtp && !_isSubmitting ? _onVerifyOtp : null,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : Text(l10n.verifyOtpButton),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: _isSubmitting ? null : _onSendOtp,
                          child: Text(l10n.resendOtp),
                        ),
                      ],
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                        ),
                      ],
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
