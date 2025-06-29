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
  int ValorAlvo = 1024;
  List<List<int>> grid = [];
  int moveu = 0;
  bool Vitoria = false;
  bool Derrota = false;

  @override
  void initState() {
    super.initState();
    _iniciarjogo();
  }

  void _iniciarjogo() {
    grid = List.generate(TamanhoGrid, (_) => List.filled(TamanhoGrid, 0));
    _adicionarpeca();
    _adicionarpeca();
    moveu = 0;
    Vitoria = false;
    Derrota = false;
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
    } else {
      Derrota = true;
    }
  }

  Future<void> _move(String direction) async {
    if (Vitoria || Derrota) return;

    bool movimento = false;

    switch (direction) {
      case 'esquerda':
        movimento = _moveesquerda();
        break;
      case 'direita':
        movimento = _movedireita();
        break;
      case 'cima':
        movimento = _movecima();
        break;
      case 'baixo':
        movimento = _movebaixo();
        break;
    }

    if (movimento) {
      setState(() {
        _adicionarpeca();
        moveu++;
        if (_verificaVitoria()) {
          Vitoria = true;
        } else if (_verificaDerrota()) {
          Derrota = true;
        }
      });
    } else if (_verificaDerrota()) {
      setState(() {
        Derrota = true;
      });
    }
  }

  bool _moveesquerda() {
    bool movimento = false;
    for (int i = 0; i < TamanhoGrid; i++) {
      movimento = _combineespacos(grid[i]) || movimento;
    }
    return movimento;
  }

  bool _movedireita() {
    bool movimento = false;
    for (int i = 0; i < TamanhoGrid; i++) {
      grid[i] = grid[i].reversed.toList();
      movimento = _combineespacos(grid[i]) || movimento;
      grid[i] = grid[i].reversed.toList();
    }
    return movimento;
  }

  bool _movecima() {
    bool movimento = false;
    for (int j = 0; j < TamanhoGrid; j++) {
      List<int> column = [];
      for (int i = 0; i < TamanhoGrid; i++) {
        column.add(grid[i][j]);
      }
      movimento = _combineespacos(column) || movimento;
      for (int i = 0; i < TamanhoGrid; i++) {
        grid[i][j] = column[i];
      }
    }
    return movimento;
  }

  bool _movebaixo() {
    bool movimento = false;
    for (int j = 0; j < TamanhoGrid; j++) {
      List<int> column = [];
      for (int i = TamanhoGrid - 1; i >= 0; i--) {
        column.add(grid[i][j]);
      }
      movimento = _combineespacos(column) || movimento;
      for (int i = TamanhoGrid - 1; i >= 0; i--) {
        grid[i][j] = column[TamanhoGrid - 1 - i];
      }
    }
    return movimento;
  }

  bool _combineespacos(List<int> row) {
    bool movimento = false;
    List<int> nonZero = row.where((x) => x != 0).toList();
    for (int i = 0; i < nonZero.length - 1; i++) {
      if (nonZero[i] == nonZero[i + 1]) {
        nonZero[i] *= 2;
        nonZero[i + 1] = 0;
        movimento = true;
      }
    }
    nonZero = nonZero.where((x) => x != 0).toList();
    while (nonZero.length < row.length) {
      nonZero.add(0);
    }
    for (int i = 0; i < row.length; i++) {
      if (row[i] != nonZero[i]) {
        movimento = true;
      }
      row[i] = nonZero[i];
    }
    return movimento;
  }

  bool _verificaVitoria() {
    for (int i = 0; i < TamanhoGrid; i++) {
      for (int j = 0; j < TamanhoGrid; j++) {
        if (grid[i][j] >= ValorAlvo) {
          return true;
        }
      }
    }
    return false;
  }

  bool _verificaDerrota() {
    if (grid.every((row) => row.every((cell) => cell != 0))) {
      for (int i = 0; i < TamanhoGrid; i++) {
        for (int j = 0; j < TamanhoGrid; j++) {
          if ((i < TamanhoGrid - 1 && grid[i][j] == grid[i + 1][j]) ||
              (j < TamanhoGrid - 1 && grid[i][j] == grid[i][j + 1])) {
            return false;
          }
        }
      }
      return true;
    }
    return false;
  }

  Widget _buildespaco(int value) {
    Color backgroundColor = Colors.grey[300]!;
    Color textColor = Colors.black87;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          value == 0 ? '' : value.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('2048 - Movimentos: $moveu')),
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
          if (Vitoria)
            const Text(
              "VOCÊ GANHOU!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          if (Derrota)
            const Text(
              "VOCÊ PERDEU!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _Constroibotao(Icons.arrow_left, () => _move('esquerda')),
              _Constroibotao(Icons.arrow_upward, () => _move('cima')),
              _Constroibotao(Icons.arrow_downward, () => _move('baixo')),
              _Constroibotao(Icons.arrow_right, () => _move('direita')),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _iniciarjogo,
            child: const Text('Novo Jogo'),
          ),
        ],
      ),
    );
  }

  Widget _Constroibotao(IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: 80,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(10.0),
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          foregroundColor: const Color.fromARGB(255, 255, 0, 0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: Icon(icon, size: 30),
      ),
    );
  }
}
