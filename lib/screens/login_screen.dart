import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/app_store.dart';
import '../theme/app_theme.dart';
import '../utils/validators.dart';
import '../widgets/common_widgets.dart';
import '../widgets/primary_button.dart';

/// V16 - Log masuk (Login)
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userCtrl = TextEditingController(text: 'pembekal.contoh');
  final _passCtrl = TextEditingController(text: 'pembekal123');
  bool _obscure = true;
  bool _busy = false;
  String? _loginError;

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _loginError = null);
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      final user =
          await AppStore.instance.login(_userCtrl.text, _passCtrl.text);
      if (mounted) context.go(user.isAdmin ? '/admin' : '/home');
    } on StoreException catch (e) {
      if (mounted) setState(() => _loginError = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _info(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Form(
              key: _formKey,
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
                    child: TextFormField(
                      controller: _userCtrl,
                      textInputAction: TextInputAction.next,
                      decoration:
                          const InputDecoration(hintText: 'Nama pengguna'),
                      validator: (v) => Validators.required(v, 'Nama pengguna'),
                    ),
                  ),
                  LabeledField(
                    label: 'Kata laluan',
                    child: TextFormField(
                      controller: _passCtrl,
                      obscureText: _obscure,
                      onFieldSubmitted: (_) => _submit(),
                      validator: (v) => Validators.required(v, 'Kata laluan'),
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
                  if (_loginError != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: Text(_loginError!,
                          style: const TextStyle(
                              color: AppColors.danger, fontSize: 12)),
                    ),
                  PrimaryButton(
                    label: _busy ? 'Sila tunggu...' : 'Log masuk',
                    onPressed: _busy ? null : _submit,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextButton(
                    onPressed: () => _info('Lupa kata laluan',
                        'Sila hubungi pentadbir UiTM eProcurement untuk menetapkan semula kata laluan anda.'),
                    child: const Text('Lupa kata laluan'),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const Divider(),
                  const SizedBox(height: AppSpacing.sm),
                  TextButton(
                    onPressed: () => _info('Daftar pembekal baharu',
                        'Pendaftaran pembekal baharu dibuat melalui pejabat perolehan UiTM. Sila hubungi pentadbir untuk mendapatkan akaun.'),
                    child: const Text('Daftar pembekal baharu'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Text(
                    'Akaun demo\nPembekal: pembekal.contoh / pembekal123\n'
                    'Pentadbir: admin.uitm / admin123',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.grey500, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
