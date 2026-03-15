import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const StarNoteApp());

class StarNoteApp extends StatelessWidget {
  const StarNoteApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'StarNote',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true),
    home: const NotesHome(),
  );
}

// ─── COLOR PALETTE ───────────────────────────────────────────
const bg      = Color(0xFF0a0e1a);
const surface = Color(0xFF111827);
const card1   = Color(0xFF1e3a5f);
const card2   = Color(0xFF1e1f4b);
const card3   = Color(0xFF2d1b4e);
const card4   = Color(0xFF1a3a2e);
const accent  = Color(0xFF7dd3fc);

final cardColors = [card1, card2, card3, card4,
  const Color(0xFF3b1f1f), const Color(0xFF1f3b2d)];

// ─── MODEL ───────────────────────────────────────────────────
class Note {
  String id, title, body, tag;
  Color color;
  DateTime created;
  Note({required this.id, required this.title,
        required this.body, required this.tag,
        required this.color, required this.created});
}

// ─── HOME ────────────────────────────────────────────────────
class NotesHome extends StatefulWidget {
  const NotesHome({super.key});
  @override
  State<NotesHome> createState() => _NotesHomeState();
}

class _NotesHomeState extends State<NotesHome> {
  final List<Note> _notes = [
    Note(id:'1', title:'Flutter animations', body:'Explore AnimationController with CurvedAnimation for smooth UI transitions. Try spring physics!', tag:'Dev', color: card1, created: DateTime.now().subtract(const Duration(hours: 2))),
    Note(id:'2', title:'Gradient ideas 🎨', body:'Deep space purples + electric blues. Use RadialGradient with multiple stops for nebula effect.', tag:'Design', color: card2, created: DateTime.now().subtract(const Duration(days: 1))),
    Note(id:'3', title:'M.S. research ideas', body:'Distributed systems + AI overlay. Look into federated learning for privacy-preserving ML.', tag:'Research', color: card3, created: DateTime.now().subtract(const Duration(days: 2))),
    Note(id:'4', title:'App launch checklist', body:'• Splash screen\n• Onboarding\n• Auth flow\n• Dark mode\n• App icon', tag:'Todo', color: card4, created: DateTime.now().subtract(const Duration(days: 3))),
  ];
  String _search = '';
  String _activeTag = 'All';

  final tags = ['All', 'Dev', 'Design', 'Research', 'Todo'];

  List<Note> get filtered => _notes.where((n) {
    final matchSearch = n.title.toLowerCase().contains(_search.toLowerCase()) ||
                        n.body.toLowerCase().contains(_search.toLowerCase());
    final matchTag = _activeTag == 'All' || n.tag == _activeTag;
    return matchSearch && matchTag;
  }).toList();

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: bg,
    body: SafeArea(child: Column(children: [
      _buildHeader(),
      _buildSearch(),
      _buildTags(),
      Expanded(child: _buildGrid()),
    ])),
    floatingActionButton: FloatingActionButton(
      onPressed: () => _openEditor(context, null),
      backgroundColor: accent,
      foregroundColor: bg,
      child: const Icon(Icons.add_rounded, size: 28),
    ),
  );

  Widget _buildHeader() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('Star', style: TextStyle(
            fontSize: 28, fontWeight: FontWeight.w900,
            color: Colors.white, letterSpacing: -1,
          )),
          const Text('Note', style: TextStyle(
            fontSize: 28, fontWeight: FontWeight.w900,
            color: accent, letterSpacing: -1,
          )),
          const SizedBox(width: 6),
          const Text('✦', style: TextStyle(fontSize: 18, color: accent)),
        ]),
        Text('${_notes.length} notes in the cosmos',
          style: const TextStyle(fontSize: 12, color: Color(0xFF6b7280))),
      ]),
      _starIcon(),
    ]),
  );

  Widget _starIcon() => Container(
    width: 44, height: 44,
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.06),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.white.withOpacity(0.08)),
    ),
    child: const Icon(Icons.auto_awesome_rounded, color: accent, size: 22),
  );

  Widget _buildSearch() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
    child: TextField(
      onChanged: (v) => setState(() => _search = v),
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: 'Search your universe...',
        hintStyle: const TextStyle(color: Color(0xFF4b5563), fontSize: 14),
        prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF4b5563), size: 20),
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    ),
  );

  Widget _buildTags() => SizedBox(
    height: 52,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      itemCount: tags.length,
      separatorBuilder: (_, __) => const SizedBox(width: 8),
      itemBuilder: (_, i) {
        final active = tags[i] == _activeTag;
        return GestureDetector(
          onTap: () => setState(() => _activeTag = tags[i]),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: active ? accent : surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: active ? accent : Colors.white.withOpacity(0.08)),
            ),
            child: Text(tags[i], style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600,
              color: active ? bg : const Color(0xFF9ca3af),
            )),
          ),
        );
      },
    ),
  );

  Widget _buildGrid() {
    final notes = filtered;
    if (notes.isEmpty) return const Center(
      child: Text('No notes found ✦', style: TextStyle(color: Color(0xFF4b5563))));
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 14,
        childAspectRatio: 0.82,
      ),
      itemCount: notes.length,
      itemBuilder: (_, i) => _buildNoteCard(notes[i]),
    );
  }

  Widget _buildNoteCard(Note note) => GestureDetector(
    onTap: () => _openEditor(context, note),
    onLongPress: () => _deleteNote(note),
    child: Container(
      decoration: BoxDecoration(
        color: note.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(note.tag, style: const TextStyle(
            fontSize: 10, fontWeight: FontWeight.w700,
            color: Colors.white, letterSpacing: 0.5,
          )),
        ),
        const SizedBox(height: 12),
        Text(note.title, style: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.w700,
          color: Colors.white, height: 1.3,
        ), maxLines: 2, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 8),
        Expanded(child: Text(note.body, style: TextStyle(
          fontSize: 12, color: Colors.white.withOpacity(0.65), height: 1.5,
        ), overflow: TextOverflow.fade)),
        const SizedBox(height: 8),
        Text(_formatDate(note.created), style: TextStyle(
          fontSize: 10, color: Colors.white.withOpacity(0.35),
        )),
      ]),
    ),
  );

  String _formatDate(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inHours < 1) return 'Just now';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  void _deleteNote(Note note) {
    showDialog(context: context, builder: (_) => AlertDialog(
      backgroundColor: surface,
      title: const Text('Delete note?', style: TextStyle(color: Colors.white)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: accent))),
        TextButton(onPressed: () {
          setState(() => _notes.removeWhere((n) => n.id == note.id));
          Navigator.pop(context);
        }, child: const Text('Delete', style: TextStyle(color: Colors.red))),
      ],
    ));
  }

  void _openEditor(BuildContext context, Note? note) async {
    final result = await Navigator.push(context,
      MaterialPageRoute(builder: (_) => NoteEditor(note: note)));
    if (result != null && result is Note) {
      setState(() {
        final idx = _notes.indexWhere((n) => n.id == result.id);
        if (idx != -1) _notes[idx] = result;
        else _notes.insert(0, result);
      });
    }
  }
}

// ─── NOTE EDITOR ─────────────────────────────────────────────
class NoteEditor extends StatefulWidget {
  final Note? note;
  const NoteEditor({super.key, this.note});
  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  late TextEditingController _titleCtrl;
  late TextEditingController _bodyCtrl;
  late Color _color;
  late String _tag;
  final tags = ['Dev', 'Design', 'Research', 'Todo', 'Personal'];

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.note?.title ?? '');
    _bodyCtrl  = TextEditingController(text: widget.note?.body  ?? '');
    _color = widget.note?.color ?? cardColors[Random().nextInt(cardColors.length)];
    _tag   = widget.note?.tag   ?? 'Dev';
  }

  void _save() {
    if (_titleCtrl.text.trim().isEmpty) return;
    final note = Note(
      id: widget.note?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleCtrl.text.trim(),
      body:  _bodyCtrl.text.trim(),
      tag: _tag, color: _color,
      created: widget.note?.created ?? DateTime.now(),
    );
    Navigator.pop(context, note);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: bg,
    appBar: AppBar(
      backgroundColor: bg,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(widget.note == null ? 'New Note ✦' : 'Edit Note',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      actions: [
        GestureDetector(
          onTap: _save,
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: accent, borderRadius: BorderRadius.circular(20)),
            child: const Text('Save', style: TextStyle(
              color: bg, fontWeight: FontWeight.w700, fontSize: 14)),
          ),
        ),
      ],
    ),
    body: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Color picker
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: cardColors.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) => GestureDetector(
              onTap: () => setState(() => _color = cardColors[i]),
              child: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: cardColors[i],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _color == cardColors[i] ? accent : Colors.transparent,
                    width: 2.5,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Tag picker
        Wrap(spacing: 8, children: tags.map((t) => GestureDetector(
          onTap: () => setState(() => _tag = t),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: _tag == t ? accent : surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(t, style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600,
              color: _tag == t ? bg : const Color(0xFF9ca3af),
            )),
          ),
        )).toList()),
        const SizedBox(height: 24),
        TextField(
          controller: _titleCtrl,
          style: const TextStyle(
            fontSize: 22, fontWeight: FontWeight.w800,
            color: Colors.white, letterSpacing: -0.5,
          ),
          decoration: const InputDecoration(
            hintText: 'Note title...',
            hintStyle: TextStyle(color: Color(0xFF4b5563)),
            border: InputBorder.none,
          ),
        ),
        const Divider(color: Color(0xFF1f2937), height: 24),
        Expanded(child: TextField(
          controller: _bodyCtrl,
          maxLines: null, expands: true,
          style: const TextStyle(
            fontSize: 15, color: Color(0xFFd1d5db), height: 1.7,
          ),
          decoration: const InputDecoration(
            hintText: 'Write your thoughts...',
            hintStyle: TextStyle(color: Color(0xFF4b5563)),
            border: InputBorder.none,
          ),
        )),
      ]),
    ),
  );
}