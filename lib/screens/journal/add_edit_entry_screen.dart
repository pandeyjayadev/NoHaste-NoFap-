import 'package:flutter/material.dart';
import '../../../models/journal_entry.dart';
import 'package:nohaste/services/journal_service.dart';

class AddEditEntryScreen extends StatefulWidget {
  final JournalEntry? entry;

  const AddEditEntryScreen({super.key, this.entry});

  @override
  State<AddEditEntryScreen> createState() => _AddEditEntryScreenState();
}

class _AddEditEntryScreenState extends State<AddEditEntryScreen> {
  final JournalService _journalService = JournalService();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _customTriggerController = TextEditingController();

  MoodLevel _selectedMood = MoodLevel.neutral;
  final Set<String> _selectedTriggers = {};
  final List<String> _customTriggers = [];
  bool _isLoading = false;

  bool get _isEditing => widget.entry != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _initializeEditingData();
    }
  }

  void _initializeEditingData() {
    final entry = widget.entry!;
    _titleController.text = entry.title;
    _contentController.text = entry.content;
    _selectedMood = entry.mood;
    _selectedTriggers.addAll(entry.triggers);
    _customTriggers.addAll(entry.customTriggers);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _customTriggerController.dispose();
    super.dispose();
  }

  Future<void> _saveEntry() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final entry = JournalEntry(
      id: _isEditing ? widget.entry!.id : _journalService.generateId(),
      createdAt: _isEditing ? widget.entry!.createdAt : DateTime.now(),
      updatedAt: DateTime.now(),
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      mood: _selectedMood,
      triggers: _selectedTriggers.toList(),
      customTriggers: _customTriggers,
    );

    final success = await _journalService.saveEntry(entry);

    setState(() => _isLoading = false);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing
                  ? 'Entry updated successfully'
                  : 'Entry saved successfully',
            ),
          ),
        );
        Navigator.pop(context, true);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save entry. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _addCustomTrigger() {
    final trigger = _customTriggerController.text.trim();
    if (trigger.isNotEmpty && !_customTriggers.contains(trigger)) {
      setState(() {
        _customTriggers.add(trigger);
        _customTriggerController.clear();
      });
    }
  }

  void _removeCustomTrigger(String trigger) {
    setState(() {
      _customTriggers.remove(trigger);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Entry' : 'New Entry'),
        elevation: 0,
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveEntry,
              child: Text(
                _isEditing ? 'Update' : 'Save',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Give your entry a title...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title for your entry';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 24),

              // Mood Selection
              Text(
                'How are you feeling?',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: MoodLevel.values.map((mood) {
                  final isSelected = _selectedMood == mood;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedMood = mood),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Color(mood.color)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected
                              ? Color(mood.color)
                              : Colors.grey[300]!,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : Color(mood.color),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            mood.label,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Common Triggers
              Text(
                'Triggers (Optional)',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                'Select any triggers that may have influenced your mood',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: JournalService.commonTriggers.map((trigger) {
                  final isSelected = _selectedTriggers.contains(trigger);
                  return FilterChip(
                    label: Text(trigger),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedTriggers.add(trigger);
                        } else {
                          _selectedTriggers.remove(trigger);
                        }
                      });
                    },
                    selectedColor: Theme.of(
                      context,
                    ).primaryColor.withOpacity(0.2),
                    checkmarkColor: Theme.of(context).primaryColor,
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Custom Triggers
              Text(
                'Custom Triggers',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                'Add your own triggers that aren\'t listed above',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _customTriggerController,
                      decoration: InputDecoration(
                        hintText: 'Enter custom trigger...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      textCapitalization: TextCapitalization.words,
                      onSubmitted: (_) => _addCustomTrigger(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addCustomTrigger,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Add'),
                  ),
                ],
              ),
              if (_customTriggers.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _customTriggers.map((trigger) {
                    return Chip(
                      label: Text(trigger),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () => _removeCustomTrigger(trigger),
                      backgroundColor: Theme.of(
                        context,
                      ).primaryColor.withOpacity(0.1),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 24),

              // Content Field
              Text(
                'Journal Entry',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                'Write about your thoughts, feelings, or experiences',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contentController,
                maxLines: 8,
                decoration: InputDecoration(
                  hintText:
                      'What\'s on your mind? How are you feeling? What happened today?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  alignLabelWithHint: true,
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please write something in your journal entry';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
