import 'package:flutter/material.dart';
import 'package:habify/services/note_service.dart';
import '../viewmodels/bottom_nav_viewmodel.dart';

class BottomNav extends StatefulWidget {
  final String username;
  const BottomNav({super.key, required this.username});

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  final NoteService _noteService = NoteService();
  late BottomNavViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = BottomNavViewModel(widget.username);
  }

  @override
  void dispose() {
    _viewModel.selectedIndex.dispose();
    super.dispose();
  }

  void _switchToAddScreen() {
    _viewModel.changeTab(2);
  }

  void _showAddNotePopup() {
    _viewModel.showAddNotePopup(context, _noteService);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<int>(
        valueListenable: _viewModel.selectedIndex,
        builder: (context, selectedIndex, _) {
          return IndexedStack(
            index: selectedIndex,
            children: _viewModel.pages,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _viewModel.showAddOptions(
            context, _switchToAddScreen, _showAddNotePopup),
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color(0xFF29068D),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: ValueListenableBuilder<int>(
          valueListenable: _viewModel.selectedIndex,
          builder: (context, selectedIndex, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.home),
                  color: selectedIndex == 0 ? Colors.blue : Colors.grey,
                  onPressed: () => _viewModel.changeTab(0),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_month_sharp),
                  color: selectedIndex == 1 ? Colors.blue : Colors.grey,
                  onPressed: () => _viewModel.changeTab(1),
                ),
                const SizedBox(width: 40), // Space for the FAB
                IconButton(
                  icon: const Icon(Icons.graphic_eq),
                  color: selectedIndex == 3 ? Colors.blue : Colors.grey,
                  onPressed: () => _viewModel.changeTab(3),
                ),
                IconButton(
                  icon: const Icon(Icons.person),
                  color: selectedIndex == 4 ? Colors.blue : Colors.grey,
                  onPressed: () => _viewModel.changeTab(4),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
