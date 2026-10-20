import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/primary_button.dart';

/// V16 - Log masuk (Login)
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userCtrl = TextEditingController(text: 'pembekal.contoh');
  final _passCtrl = TextEditingController(text: '••••••••');
  bool _obscure = true;

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.inventory_2_outlined,
                          color: AppColors.white, size: 18),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    const Text('FindProcurement+',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),
                const Text('Log masuk',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                const SizedBox(height: AppSpacing.xs),
                const Text('Akaun pembekal UiTM eProcurement',
                    style: TextStyle(color: AppColors.grey500, fontSize: 13)),
                const SizedBox(height: AppSpacing.xl),
                LabeledField(
                  label: 'Pengguna',
                  child: TextField(
                    controller: _userCtrl,
                    decoration: const InputDecoration(hintText: 'Nama pengguna'),
                  ),
                ),
                LabeledField(
                  label: 'Kata laluan',
                  child: TextField(
                    controller: _passCtrl,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      hintText: 'Kata laluan',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                          size: 20,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                  ),
                ),
                PrimaryButton(
                  label: 'Log masuk',
                  onPressed: () => context.go('/home'),
                ),
                const SizedBox(height: AppSpacing.md),
                TextButton(
                  onPressed: () {},
                  child: const Text('Lupa kata laluan'),
                ),
                const SizedBox(height: AppSpacing.sm),
                const Divider(),
                const SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: () {},
                  child: const Text('Daftar pembekal baharu'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
