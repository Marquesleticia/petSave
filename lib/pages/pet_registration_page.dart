// Importações para manipulação de dados e UI
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_save/services/postgres_service.dart';

// Definição das cores usadas na página
const _bg = Color(0xFF141210); // Cor de fundo escuro
const _orange = Color(0xFFF97316); // Cor laranja para destaques
const _textSecondary = Color(0xFF9E9589); // Cor cinza para textos secundários

// Enum para definir o status do pet (resgatado ou perdido)
enum _PetStatus { achado, perdido }

// Página de registro de novo pet - utiliza StatefulWidget para gerenciar estado
class PetRegistrationPage extends StatefulWidget {
  const PetRegistrationPage({super.key});

  @override
  State<PetRegistrationPage> createState() => _PetRegistrationPageState();
}

// Estado da página de registro
class _PetRegistrationPageState extends State<PetRegistrationPage> {
  // Chave para validação do formulário
  final _formKey = GlobalKey<FormState>();

  // Controladores dos campos de input
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  // Serviço para comunicação com o banco de dados
  final _petService = PostgresService();

  // Variáveis de estado
  _PetStatus _status = _PetStatus.achado; // Status inicial (resgatado)
  Uint8List? _imageBytes; // Bytes da imagem selecionada
  String? _imageDataUrl; // URL em base64 da imagem
  bool _isSaving = false; // Indica se está salvando os dados

  // Libera recursos dos controladores quando a página é fechada
  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Abre a galeria de imagens e processa a imagem selecionada
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    // Seleciona imagem com redimensionamento e compressão
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 80,
    );
    if (file == null) return;

    // Converte imagem para bytes e identifica o tipo MIME
    final bytes = await file.readAsBytes();
    final extension = file.path.toLowerCase();
    final mimeType = extension.endsWith('.png')
        ? 'image/png'
        : extension.endsWith('.webp')
            ? 'image/webp'
            : 'image/jpeg';

    // Armazena a imagem em memória e cria URL em base64
    setState(() {
      _imageBytes = bytes;
      _imageDataUrl = 'data:$mimeType;base64,${base64Encode(bytes)}';
    });
  }

  // Valida e envia os dados do pet para o banco de dados
  Future<void> _submit() async {
    // Valida os campos do formulário
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // Verifica se uma imagem foi selecionada
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

    // Inicia o envio dos dados
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

    // Exibe mensagem de erro, se houver
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

    // Sucesso: volta para página anterior
    Navigator.of(context).pop(true);
  }

  // Define o estilo dos campos de texto (input decoration)
  InputDecoration _fieldDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: _textSecondary),
      filled: true,
      fillColor: const Color(0xFFF4F4F5),
      // Borda padrão
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      // Borda quando o campo não está ativo
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      // Borda quando o campo está em foco (laranja)
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: _orange, width: 1.5),
      ),
    );
  }

  // Constrói a interface da página
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      // Barra superior com título
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
        // Card branco contendo o formulário
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
                // Título da seção
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
                // Subtítulo explicativo
                const Text(
                  'Cadastre seu animal perdido ou resgatado e conecte-se com quem pode ajudar.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _textSecondary,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 22),
                // Seção para seleção de imagem
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F4F5),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    // Exibe a imagem se selecionada, senão exibe placeholder
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
                // Botões para selecionar o status do pet (Resgatado ou Perdido)
                Row(
                  children: [
                    // Botão "Resgatado" (verde)
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
                            'Resgatado',
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
                    // Botão "Perdido" (vermelho)
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
                // Campos de entrada do formulário
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
                // Campo de telefone com validação
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
                // Botão de envio do formulário
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
                    // Mostra loading enquanto está salvando
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
