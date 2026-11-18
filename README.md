# Sábios App - Mobile

Aplicação Flutter do ecossistema **Sábios**, criada para conectar clientes a
conselheiros e organizar sessões de orientação. O projeto contém atualmente um
protótipo navegável da experiência do cliente, com telas de autenticação,
descoberta de conselheiros, agenda, mensagens e perfil.

> **Estado atual:** a interface e os fluxos principais estão implementados com
> estado local e dados de demonstração. Ainda não há autenticação real,
> persistência, chamadas para a API ou integração com uma sala virtual.

---

## 📚 Documentação relacionada

- [Frontend Web](https://github.com/Sabios-app/Web-Front/blob/main/README.md) — aplicação web do ecossistema Sábios.
- [Backend da API](https://github.com/Sabios-app/Api-Backend/blob/main/README.md) — serviço responsável pelas
  integrações de backend.

---

## 🚀 Tecnologias

- **Flutter**
- **Dart 3.13.5 ou superior**, conforme o `pubspec.yaml`
- **Material 3**
- **Cupertino Icons**
- **Path Provider**
- **flutter_lints**
- **flutter_launcher_icons**

O projeto está configurado para executar nos alvos Flutter presentes no
repositório:

- Android
- iOS
- Web
- Windows
- macOS
- Linux

---

## ✨ Funcionalidades atuais

### Fluxo de entrada

- Tela de boas-vindas.
- Escolha do tipo de conta:
  - Cliente.
  - Conselheiro.
- Tela de cadastro.
- Tela de login.
- Recuperação de senha representada por feedback visual.
- Entrada de demonstração no aplicativo principal.

### Área principal do cliente

- **Início:** saudação, próxima sessão, plano de ação, notificações e
  conselheiro recomendado.
- **Explorar:** busca por nome, área ou tema; filtros por especialidade;
  favoritos; avaliação, preço e disponibilidade; abertura do fluxo de agenda.
- **Agenda:** seleção de dia, sessão agendada, lembrete e ação para entrar na
  sala virtual.
- **Mensagens:** lista de conversas e indicador de mensagens não lidas.
- **Perfil:** dados da conta, favoritos, pagamentos, preferências e ações
  auxiliares.

As ações de entrar em uma sala, abrir uma conversa, redefinir senha e acessar
opções ainda exibem feedback local na interface. Elas não executam integrações
externas neste momento.

---

## 📁 Estrutura de pastas e arquitetura

O código Dart fica organizado por responsabilidade e por domínio de tela:

```text
Mobile/
├── assets/
│   └── icon/                         # Ícones usados para gerar os assets do app
├── lib/
│   ├── core/
│   │   ├── theme/                    # Cores, tipografia e tema Material
│   │   └── widgets/                  # Componentes visuais compartilhados
│   ├── pages/
│   │   ├── agenda/
│   │   │   └── views/                # Agenda e sessões
│   │   ├── auth/
│   │   │   └── views/                # Boas-vindas, login, cadastro e perfis
│   │   ├── explore/
│   │   │   └── views/                # Busca e seleção de conselheiros
│   │   ├── home/
│   │   │   ├── views/                # Tela inicial
│   │   │   └── widgets/              # Cards e seções da tela inicial
│   │   ├── messages/
│   │   │   └── views/                # Conversas
│   │   ├── navigation/
│   │   │   ├── views/                # Navegação principal
│   │   │   └── widgets/              # Barra de navegação inferior
│   │   └── profile/
│   │       └── views/                # Perfil do cliente
│   └── main.dart                     # Ponto de entrada da aplicação
├── test/                             # Testes e utilitários de geração de asset
├── android/                          # Configuração do alvo Android
├── ios/                              # Configuração do alvo iOS
├── linux/                            # Configuração do alvo Linux
├── macos/                            # Configuração do alvo macOS
├── web/                              # Configuração do alvo Web
├── windows/                          # Configuração do alvo Windows
├── analysis_options.yaml             # Regras de análise e lint
├── pubspec.yaml                      # Metadados, dependências e assets
└── pubspec.lock                      # Versões resolvidas das dependências
```

### Organização por camadas

- **`core/theme/`** concentra a identidade visual. Cores devem ser adicionadas
  em `AppColors`, estilos em `AppTextStyles` e configurações globais em
  `AppTheme`.
- **`core/widgets/`** contém componentes reutilizáveis entre diferentes fluxos,
  como logo e avatar de rede.
- **`pages/<fluxo>/views/`** contém telas e coordena o estado específico de cada
  fluxo.
- **`pages/home/widgets/`** contém seções exclusivas da tela inicial, como
  cards, plano de ação e modal de agendamento.
- **`pages/navigation/`** controla a navegação inferior e mantém as telas
  principais em um `IndexedStack`.

O `AuthGate` controla o fluxo de entrada por meio de `AuthScreenState`. Quando
o estado chega a `authenticatedApp`, o usuário acessa a
`MainNavigationScreen`.

### Regra de decisão: `core/widgets/` ou `pages/`

- Coloque em `core/widgets/` componentes usados por mais de um fluxo ou que
  representam um padrão visual do produto.
- Coloque em `pages/<fluxo>/widgets/` componentes exclusivos de uma página ou
  jornada.
- Mantenha nas `views/` a composição da tela e a coordenação do estado.
- Ao adicionar integração com a API, mantenha serviços, modelos e tratamento
  de erro separados da composição visual das páginas.

---

## 🎨 Identidade visual

O tema usa Material 3 e uma paleta baseada em:

- Verde-petróleo como cor primária.
- Dourado como cor de destaque e ações principais.
- Fundo claro quente e superfícies em tons de sage/sand.
- Tipografia e espaçamentos centralizados em `core/theme/`.

Prefira os valores existentes em `AppColors`, `AppTextStyles` e `AppTheme` em
vez de criar cores ou estilos isolados diretamente nas telas.

---

## 🛠️ Configuração e execução

### Pré-requisitos

1. Instale o Flutter SDK compatível com Dart 3.13.5 ou superior.
2. Instale o SDK e as ferramentas do alvo que deseja executar:
   - Android Studio e Android SDK para Android.
   - Xcode para iOS e macOS.
   - Visual Studio com Desktop development with C++ para Windows.
   - Ferramentas de desktop correspondentes para Linux.
3. Confira o ambiente:

```bash
flutter doctor
```

### Instalação

Na pasta `Mobile/`:

```bash
flutter pub get
```

### Executar

Para listar os dispositivos disponíveis:

```bash
flutter devices
```

Para iniciar em um dispositivo específico:

```bash
flutter run -d <device-id>
```

Exemplos:

```bash
flutter run -d chrome
flutter run -d windows
```

### Gerar ícones

Após alterar `assets/icon/` ou a configuração de ícones no `pubspec.yaml`:

```bash
dart run flutter_launcher_icons
```

---

## ✅ Qualidade e validação

Antes de abrir um Pull Request ou realizar um commit, execute:

```bash
flutter analyze
flutter test
```

O comando `flutter test` ficará pronto para executar assim que forem
adicionados arquivos de teste com o padrão `*_test.dart`; no estado atual,
`test/gerear.dart` é um utilitário de geração de ícone e não um teste
executável.

Para validar uma compilação de produção, use o alvo correspondente:

```bash
flutter build apk
flutter build web
flutter build windows
```

Nem todos os alvos podem ser compilados em todos os sistemas operacionais. Por
exemplo, builds de iOS exigem macOS e Xcode.

---

## 🌿 Boas práticas de colaboração

1. Crie uma branch a partir da `main` atualizada:
   - `feat/nome-do-fluxo`
   - `fix/descricao-do-ajuste`
2. Use commits claros e descritivos, por exemplo:
   - `feat: add mentor search filters`
   - `fix: preserve selected agenda day`
3. Não faça push direto na `main`.
4. Abra um Pull Request e solicite revisão de outro membro da equipe.
5. Execute `flutter analyze` e `flutter test` antes de solicitar o merge.
6. Evite adicionar lógica de negócio ou dados mockados diretamente em widgets
   compartilhados.

### Convenções de código

- Use `PascalCase` para classes, widgets e enums.
- Use `camelCase` para métodos, variáveis e parâmetros.
- Prefira widgets pequenos e com responsabilidade única.
- Use `const` sempre que o widget puder ser constante.
- Mantenha strings e dados de demonstração próximos do fluxo ao qual pertencem
  até que sejam substituídos por modelos e serviços reais.
- Não introduza uma dependência sem atualizar o `pubspec.yaml` e validar o
  projeto com `flutter pub get`.

---

## 🧭 Próximos passos de integração

Para transformar o protótipo em uma aplicação conectada ao restante do
ecossistema, os próximos pontos naturais são:

- Integrar autenticação com o backend.
- Substituir dados locais por modelos e repositórios de API.
- Persistir sessão, favoritos, tarefas e agendamentos.
- Implementar mensagens em tempo real.
- Integrar o provedor de sala virtual.
- Adicionar testes de widget e testes dos fluxos críticos.
