import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(Tela());
}

class Tela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2048',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PaginaPrincipal(),
    );
  }
}

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({Key? key}) : super(key: key);

  @override
  _PaginaPrincipalState createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  int TamanhoGrid = 4;
  List<List<int>> grid = [];

  @override
  void initState() {
    super.initState();
    _iniciarjogo();
  }

  void _iniciarjogo() {
    grid = List.generate(TamanhoGrid, (_) => List.filled(TamanhoGrid, 0));
    _adicionarpeca();
    _adicionarpeca();
    setState(() {});
  }

  void _adicionarpeca() {
    List<List<int>> espacosvazios = [];
    for (int i = 0; i < TamanhoGrid; i++) {
      for (int j = 0; j < TamanhoGrid; j++) {
        if (grid[i][j] == 0) {
          espacosvazios.add([i, j]);
        }
      }
    }
    if (espacosvazios.isNotEmpty) {
      final random = Random();
      final espaco = espacosvazios[random.nextInt(espacosvazios.length)];
      grid[espaco[0]][espaco[1]] = random.nextDouble() < 0.9 ? 2 : 4;
    }
  }

  Widget _buildespaco(int value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          value == 0 ? '' : value.toString(),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('2048')),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: TamanhoGrid,
              ),
              itemCount: TamanhoGrid * TamanhoGrid,
              itemBuilder: (context, index) {
                int row = index ~/ TamanhoGrid;
                int col = index % TamanhoGrid;
                return _buildespaco(grid[row][col]);
              },
            ),
          ),
          ElevatedButton(
            onPressed: _iniciarjogo,
            child: const Text('Novo Jogo'),
          ),
        ],
      ),
    );
  }
}
