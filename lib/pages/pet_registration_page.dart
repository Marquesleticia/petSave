import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_save/services/postgres_service.dart';

const _bg = Color(0xFF141210);
const _orange = Color(0xFFF97316);
const _textSecondary = Color(0xFF9E9589);

enum _PetStatus { achado, perdido }

class PetRegistrationPage extends StatefulWidget {
  const PetRegistrationPage({super.key});

  @override
  State<PetRegistrationPage> createState() => _PetRegistrationPageState();
}

class _PetRegistrationPageState extends State<PetRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _petService = PostgresService();
  _PetStatus _status = _PetStatus.achado;
  Uint8List? _imageBytes;
  String? _imageDataUrl;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 80,
    );
    if (file == null) return;

    final bytes = await file.readAsBytes();
    final extension = file.path.toLowerCase();
    final mimeType = extension.endsWith('.png')
        ? 'image/png'
        : extension.endsWith('.webp')
            ? 'image/webp'
            : 'image/jpeg';

    setState(() {
      _imageBytes = bytes;
      _imageDataUrl = 'data:$mimeType;base64,${base64Encode(bytes)}';
    });
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_imageDataUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione uma imagem para o pet.'),
          backgroundColor: Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    final error = await _petService.insertPetCard(
      name: _nameController.text,
      isResgatado: _status == _PetStatus.achado,
      local: _addressController.text,
      timeAgo: 'Agora',
      imageUrl: _imageDataUrl!,
    );
    if (!mounted) return;
    setState(() => _isSaving = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
        ),
      );
      return;
    }

    Navigator.of(context).pop(true);
  }

  InputDecoration _fieldDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: _textSecondary),
      filled: true,
      fillColor: const Color(0xFFF4F4F5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: _orange, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: const Text('Cadastrar Pet'),
        backgroundColor: _bg,
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: _orange),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Cadastre seu Pet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: _bg,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Cadastre seu pet e garanta ajuda para achar-lo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _textSecondary,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 22),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F4F5),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: _imageBytes != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: Image.memory(
                              _imageBytes!,
                              width: double.infinity,
                              height: 140,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.photo_camera_outlined,
                                  size: 28, color: _textSecondary),
                              SizedBox(height: 12),
                              Text(
                                'Adicionar Imagem do seu Pet',
                                style: TextStyle(
                                    color: _textSecondary,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _status = _PetStatus.achado),
                        child: Container(
                          height: 48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _status == _PetStatus.achado
                                ? const Color(0xFF22C55E)
                                : const Color(0xFFF4F4F5),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: _status == _PetStatus.achado
                                  ? const Color(0xFF16A34A)
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Text(
                            'Achado',
                            style: TextStyle(
                              color: _status == _PetStatus.achado
                                  ? Colors.white
                                  : _textSecondary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _status = _PetStatus.perdido),
                        child: Container(
                          height: 48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _status == _PetStatus.perdido
                                ? const Color(0xFFEF4444)
                                : const Color(0xFFF4F4F5),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: _status == _PetStatus.perdido
                                  ? const Color(0xFFB91C1C)
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Text(
                            'Perdido',
                            style: TextStyle(
                              color: _status == _PetStatus.perdido
                                  ? Colors.white
                                  : _textSecondary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: _fieldDecoration('Nome'),
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Informe o nome do pet'
                      : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _breedController,
                  textCapitalization: TextCapitalization.words,
                  decoration: _fieldDecoration('Raça'),
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Informe a raça do pet'
                      : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _addressController,
                  textCapitalization: TextCapitalization.words,
                  decoration: _fieldDecoration('Endereço'),
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Informe o endereço'
                      : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: _fieldDecoration('Telefone de contato'),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Informe um telefone';
                    if (!RegExp(r'^[0-9 ()+-]{8,}$').hasMatch(value)) {
                      return 'Telefone inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 22),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _orange,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: _orange.withOpacity(0.6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            'Cadastre-se agora!',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
