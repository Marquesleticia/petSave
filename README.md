# PetSave 🐾

Um aplicativo mobile construído com Flutter para ajudar a reunir pets perdidos com suas famílias. A comunidade trabalha junta para relatar animais resgatados ou perdidos, criando um feed atualizado para facilitar os reencontros.

## 📱 Telas do Aplicativo

O projeto está sendo estruturado com foco em componentização e código limpo. Atualmente, o fluxo conta com:

* **Home (Página Inicial):** * Cabeçalho de boas-vindas e detalhes.
    * Banner principal de engajamento.
    * Carrossel horizontal de pets urgentes (casos recentes de animais perdidos).
    * Feed vertical com o histórico de pets, utilizando tags dinâmicas (**Resgatado** ou **Perdido**) para facilitar a identificação visual.
    
* **Detalhes do Pet :** * Uma tela dedicada para exibir informações completas do animal selecionado, como fotos em tela cheia, descrição detalhada, localização exata e botão de contato com o publicador.

## 🛠️ Tecnologias Utilizadas

* **Flutter & Dart:** Framework principal para construção da interface multiplataforma.
* **Cached Network Image:** Gerenciamento inteligente e cacheamento de imagens vindas da internet para melhor performance e economia de dados.

## 🚀 Como executar o projeto

1. Clone este repositório no seu computador.
2. Abra o terminal na pasta do projeto e instale as dependências:
   ```bash
   flutter pub get
