import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/network_avatar.dart';
import '../../../services/message_service.dart';
import '../../../models/message_model.dart';

class MessagesPage extends StatefulWidget {
  final String? initialConversationId;
  final String? initialSpecialistId;

  const MessagesPage({
    super.key,
    this.initialConversationId,
    this.initialSpecialistId,
  });

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  List<ConversationModel> _conversations = [];
  bool _isLoading = true;
  String _searchQuery = '';
  bool _missingCounselorProfile = false;

  @override
  void initState() {
    super.initState();
    _loadConversations();
    if (widget.initialSpecialistId != null || widget.initialConversationId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openChat(
          'Chat',
          widget.initialSpecialistId,
          widget.initialConversationId,
        );
      });
    }
  }

  Future<void> _loadConversations() async {
    setState(() => _isLoading = true);
    bool missing = false;
    final list = await MessageService.getConversations(
      onProfileStatus: (isMissing) => missing = isMissing,
    );
    if (mounted) {
      setState(() {
        _conversations = list;
        _missingCounselorProfile = missing;
        _isLoading = false;
      });
    }
  }

  void _openChat(String title, String? targetSpecialistId, String? convId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => _ChatScreen(
          title: title,
          specialistId: targetSpecialistId,
          conversationId: convId,
        ),
      ),
    );
  }

  List<ConversationModel> get _filteredConversations {
    if (_searchQuery.isEmpty) return _conversations;
    return _conversations.where((conv) {
      final name = conv.specialist?.user.name ?? conv.client?.name ?? '';
      return name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          conv.lastMessage.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final convs = _filteredConversations;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadConversations,
          color: AppColors.primaryTeal,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              const Text('MENSAGENS DIRETAS', style: AppTextStyles.eyebrow),
              const SizedBox(height: 6),
              const Text('Conversas', style: AppTextStyles.heading1),
              const SizedBox(height: 18),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.borderLight),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded, color: AppColors.textPlaceholder),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        onChanged: (val) => setState(() => _searchQuery = val),
                        decoration: const InputDecoration(
                          hintText: 'Buscar conversa',
                          hintStyle: TextStyle(color: AppColors.textPlaceholder, fontSize: 14),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Center(child: CircularProgressIndicator(color: AppColors.primaryTeal)),
                )
              else if (convs.isNotEmpty) ...[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: convs.length,
                      separatorBuilder: (ctx, idx) => const Divider(height: 1, color: AppColors.divider),
                      itemBuilder: (context, index) {
                        final conv = convs[index];
                        final name = conv.specialist?.user.name ?? conv.client?.name ?? 'Conversa';
                        final avatar = conv.specialist?.user.avatarUrl ?? conv.client?.avatarUrl;
                        final specId = conv.specialist?.id;

                        return InkWell(
                          onTap: () => _openChat(name, specId, conv.id),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                NetworkAvatar(
                                  imageUrl: avatar ?? '',
                                  name: name,
                                  size: 52,
                                  borderRadius: 999,
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        conv.lastMessage,
                                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Center(
                    child: Text(
                      _missingCounselorProfile
                          ? 'Seu perfil de conselheiro ainda não foi concluído.\nComplete o cadastro profissional para acessar as conversas.'
                          : 'Nenhuma conversa encontrada.\nInicie um contato direto através do perfil de um especialista.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.5),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatScreen extends StatefulWidget {
  final String title;
  final String? specialistId;
  final String? conversationId;

  const _ChatScreen({
    required this.title,
    this.specialistId,
    this.conversationId,
  });

  @override
  State<_ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<_ChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  List<ChatMessageModel> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    if (widget.conversationId != null) {
      setState(() => _isLoading = true);
      final history = await MessageService.getMessages(widget.conversationId!);
      if (mounted) {
        setState(() {
          _messages = history;
          _isLoading = false;
        });
      }
    }
  }

  void _sendMessage() async {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;
    _msgController.clear();

    if (widget.specialistId != null) {
      final sent = await MessageService.sendMessage(
        specialistId: widget.specialistId!,
        content: text,
      );
      if (sent != null && mounted) {
        setState(() => _messages.add(sent));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal))
                : _messages.isEmpty
                    ? Center(
                        child: Text(
                          'Início da conversa com ${widget.title}.',
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _messages.length,
                        itemBuilder: (ctx, index) {
                          final msg = _messages[index];
                          final isMe = msg.sender?.role == 'CLIENT';
                          return Align(
                            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: isMe ? AppColors.primaryTeal : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: isMe ? null : Border.all(color: AppColors.borderLight),
                              ),
                              child: Text(
                                msg.content,
                                style: TextStyle(
                                  color: isMe ? Colors.white : AppColors.textPrimary,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    decoration: InputDecoration(
                      hintText: 'Digite uma mensagem...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send_rounded, color: AppColors.primaryTeal),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
