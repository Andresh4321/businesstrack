import 'package:businesstrack/features/supplier/domain/entities/supplier_entity.dart';
import 'package:businesstrack/features/supplier/data/datasource/remote/supplieremotedatasource.dart';
import 'package:businesstrack/core/User_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AIAssistantPage extends ConsumerStatefulWidget {
  const AIAssistantPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AIAssistantPage> createState() => _AIAssistantPageState();
}

class _AIAssistantPageState extends ConsumerState<AIAssistantPage> {
  final TextEditingController _queryController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [];
  bool _isLoading = false;

  final List<String> _predefinedQuestions = [
    'Who are the suppliers who supply...',
    'Show me suppliers for...',
    'Find suppliers that provide...',
  ];

  @override
  void initState() {
    super.initState();
    _messages.add(
      Message(
        role: MessageRole.assistant,
        content:
            "Hello! I'm your AI assistant. I can help you find suppliers for your products. Try asking me something like 'Who are the suppliers who supply...?'",
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _queryController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  List<String> _extractProducts(String userMessage) {
    final patterns = [
      RegExp(
        r'who are the suppliers who supply\s*(.*?)(\?|$)',
        caseSensitive: false,
      ),
      RegExp(r'show me suppliers for\s*(.*?)(\?|$)', caseSensitive: false),
      RegExp(
        r'find suppliers that provide\s*(.*?)(\?|$)',
        caseSensitive: false,
      ),
      RegExp(r'suppliers who supply\s*(.*?)(\?|$)', caseSensitive: false),
      RegExp(r'suppliers for\s*(.*?)(\?|$)', caseSensitive: false),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(userMessage);
      if (match != null && match.group(1) != null) {
        String productsStr = match.group(1)!.trim();

        // Remove leading/trailing punctuation
        productsStr = productsStr.replaceAll(RegExp(r'^[.\s]+|[.\s]+$'), '');

        return productsStr
            .split(RegExp(r',\s*|\s+and\s+|\s+or\s+', caseSensitive: false))
            .map((p) => p.trim().toLowerCase())
            .map((p) => p.replaceAll(RegExp(r'^[.\s]+|[.\s]+$'), ''))
            .where((p) => p.isNotEmpty)
            .toList();
      }
    }

    return [];
  }

  Future<List<SupplierEntity>> _findSuppliersByProducts(
    List<String> products,
  ) async {
    try {
      final supplierDataSource = ref.read(supplierRemoteDatasourceProvider);
      final userState = ref.read(userProvider);
      final userId = userState?.id ?? '';

      final Map<String, SupplierEntity> allSuppliersMap = {};

      for (final product in products) {
        try {
          final suppliers = await supplierDataSource.searchSuppliersByProduct(
            product,
            userId,
          );
          for (final supplier in suppliers) {
            if (supplier.id != null) {
              allSuppliersMap[supplier.id!] = supplier;
            }
          }
        } catch (e) {
          print('Error fetching suppliers for $product: $e');
        }
      }

      return allSuppliersMap.values.toList();
    } catch (e) {
      print('Error fetching suppliers: $e');
      rethrow;
    }
  }

  String _formatSupplierResponse(
    List<SupplierEntity> suppliers,
    List<String> products,
  ) {
    if (suppliers.isEmpty) {
      return "I couldn't find any suppliers for ${products.join(", ")}. You may need to add new suppliers to your system.";
    }

    String response =
        'I found ${suppliers.length} supplier${suppliers.length > 1 ? "s" : ""} for ${products.join(", ")}:\n\n';

    for (int i = 0; i < suppliers.length; i++) {
      final supplier = suppliers[i];
      response += '${i + 1}. ${supplier.name}\n';
      response += '📧 Email: ${supplier.email}\n';
      response += '📞 Contact: ${supplier.contactNumber}\n';
      response += '📦 Products: ${supplier.products.join(", ")}\n\n';
    }

    return response;
  }

  Future<void> _handleSendMessage() async {
    final query = _queryController.text.trim();
    if (query.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(
        Message(
          role: MessageRole.user,
          content: query,
          timestamp: DateTime.now(),
        ),
      );
      _isLoading = true;
    });

    _queryController.clear();
    _scrollToBottom();

    try {
      final products = _extractProducts(query);

      if (products.isEmpty) {
        setState(() {
          _messages.add(
            Message(
              role: MessageRole.assistant,
              content:
                  "Please specify which products or materials you're looking for. For example: 'Who are the suppliers who supply eggs?' or 'Show me suppliers for milk and butter'",
              timestamp: DateTime.now(),
            ),
          );
        });
      } else {
        final suppliers = await _findSuppliersByProducts(products);
        final responseContent = _formatSupplierResponse(suppliers, products);

        setState(() {
          _messages.add(
            Message(
              role: MessageRole.assistant,
              content: responseContent,
              timestamp: DateTime.now(),
            ),
          );
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(
          Message(
            role: MessageRole.assistant,
            content:
                'Sorry, I encountered an error while searching for suppliers. Please try again.',
            timestamp: DateTime.now(),
          ),
        );
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.auto_awesome, color: Colors.purple),
            const SizedBox(width: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Assistant',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Ask about suppliers and products',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        elevation: 2,
      ),
      body: Column(
        children: [
          // Predefined questions (show only when no messages yet)
          if (_messages.length <= 1)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.5),
                border: Border(
                  bottom: BorderSide(color: theme.dividerColor, width: 1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick questions:',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _predefinedQuestions.map((question) {
                      return OutlinedButton(
                        onPressed: () {
                          _queryController.text = question;
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        child: Text(
                          question,
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message.role == MessageRole.user;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: isUser
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isUser) ...[
                        CircleAvatar(
                          backgroundColor: Colors.purple,
                          radius: 16,
                          child: const Icon(
                            Icons.smart_toy,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isUser
                                ? theme.colorScheme.primary
                                : theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.content,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: isUser
                                      ? Colors.white
                                      : theme.textTheme.bodyMedium?.color,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatTime(message.timestamp),
                                style: theme.textTheme.caption?.copyWith(
                                  color: isUser
                                      ? Colors.white.withOpacity(0.7)
                                      : theme.textTheme.caption?.color
                                            ?.withOpacity(0.7),
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isUser) ...[
                        const SizedBox(width: 12),
                        CircleAvatar(
                          backgroundColor: theme.colorScheme.primary,
                          radius: 16,
                          child: const Icon(
                            Icons.person,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),

          // Loading indicator
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.purple,
                    radius: 16,
                    child: const Icon(
                      Icons.smart_toy,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 8),
                        const Text('Thinking...'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Input field
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              border: Border(
                top: BorderSide(color: theme.dividerColor, width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _queryController,
                    decoration: InputDecoration(
                      hintText: 'Ask about suppliers...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    enabled: !_isLoading,
                    onSubmitted: (_) => _handleSendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.primary.withOpacity(0.8),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Icon(Icons.send, color: Colors.white),
                    onPressed: _isLoading ? null : _handleSendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final hour = timestamp.hour > 12 ? timestamp.hour - 12 : timestamp.hour;
    final period = timestamp.hour >= 12 ? 'PM' : 'AM';
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}

enum MessageRole { user, assistant }

class Message {
  final MessageRole role;
  final String content;
  final DateTime timestamp;

  Message({required this.role, required this.content, required this.timestamp});
}
