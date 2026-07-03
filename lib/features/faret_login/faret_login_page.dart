import 'package:flutter/material.dart';

import '../../core/api/faret_auth_api.dart';
import '../../core/empresa/empresa_session.dart';
import '../empresa_selector/empresa_selector_page.dart';
import '../faret_home/faret_home_page.dart';

class FaretLoginPage extends StatefulWidget {
  const FaretLoginPage({super.key});

  @override
  State<FaretLoginPage> createState() => _FaretLoginPageState();
}

class _FaretLoginPageState extends State<FaretLoginPage> {
  final _identificadorController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authApi = FaretAuthApi();

  bool _loading = false;

  @override
  void dispose() {
    _identificadorController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _ingresar() async {
    final identificador = _identificadorController.text.trim();
    final password = _passwordController.text;

    if (identificador.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese RUT/usuario y contraseña')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final resultado = await _authApi.login(identificador, password);

      EmpresaSession.iniciarFaret(
        token: resultado['token'],
        nombreUsuario: resultado['nombre'],
        rol: resultado['rol'],
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const FaretHomePage()),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _volver() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const EmpresaSelectorPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101820),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2A33).withOpacity(0.82),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.white.withOpacity(0.10)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'FARET',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.6,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 26),
                    TextField(
                      controller: _identificadorController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'RUT, usuario o correo',
                        labelStyle: TextStyle(color: Color(0xFF90A4AE)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF607D8B)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF8BC34A)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                        labelStyle: TextStyle(color: Color(0xFF90A4AE)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF607D8B)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF8BC34A)),
                        ),
                      ),
                      onSubmitted: (_) => _ingresar(),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 58,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _ingresar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8BC34A),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: _loading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'INGRESAR',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextButton(
                      onPressed: _loading ? null : _volver,
                      child: const Text(
                        'Volver',
                        style: TextStyle(color: Color(0xFF90A4AE)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
