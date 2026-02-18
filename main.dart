// import 'dart:io';

// Nó da Árvore B
import 'dart:math';

class BTreeNode {
  List<int> keys = [];
  List<BTreeNode> children = [];
  bool isLeaf;

  BTreeNode(this.isLeaf);
}

// Classe da Árvore B
class BTree {
  BTreeNode? root;
  final int t; // Grau mínimo

  BTree(this.t) {
    root = BTreeNode(true);
  }

  // Função principal de inserção
  void insert(int key) {
    BTreeNode r = root!;
    if (r.keys.length == (2 * t) - 1) {
      BTreeNode s = BTreeNode(false);
      root = s;
      s.children.add(r);
      _splitChild(s, 0, r);
      _insertNonFull(s, key);
    } else {
      _insertNonFull(r, key);
    }
  }

  // Divide um nó cheio
  void _splitChild(BTreeNode parent, int i, BTreeNode fullNode) {
    BTreeNode newNode = BTreeNode(fullNode.isLeaf);

    // Move as t-1 chaves finais para o novo nó
    for (int j = 0; j < t - 1; j++) {
      newNode.keys.add(fullNode.keys.removeAt(t));
    }

    // Se não for folha; move os filhos também
    if (!fullNode.isLeaf) {
      for (int j = 0; j < t; j++) {
        newNode.children.add(fullNode.children.removeAt(t));
      }
    }

    parent.children.insert(i + 1, newNode);
    parent.keys.insert(i, fullNode.keys.removeAt(t - 1));
  }

  // Insere em um nó que garantidamente não esta cheio
  void _insertNonFull(BTreeNode node, int key) {
    int i = node.keys.length - 1;

    if (node.isLeaf) {
      node.keys.add(0); //placeholder
      while (i >= 0 && key < node.keys[i]) {
        node.keys[i + 1] = node.keys[i];
        i--;
      }
      node.keys[i + 1] = key;
    } else {
      while (i >= 0 && key < node.keys[i]) {
        i--;
      }
      i++;
      if (node.children[i].keys.length == (2 * t) - 1) {
        _splitChild(node, i, node.children[i]);
        if (key > node.keys[i]) i++;
      }
      _insertNonFull(node.children[i], key);
    }
  }

  // Imprime a estrutura no terminal
  void printTree(BTreeNode? node, String indent) {
    if (node != null) {
      print("$indent${node.keys}");
      for (var child in node.children) {
        printTree(child, "$indent ");
      }
    }
  }
}

void main() {
  final myTree = BTree(3);

  int random = 15;
  // List<int> numeros = [10, 20, 5, 6, 12, 30, 7, 17];
  List<int> numeros = [];

  for (int i = 0; i < random; i++) {
    int n = Random().nextInt(random);
    numeros.add(n);
  }

  print("--- B-Tree Console App ---");
  String texto = "";
  for (int i = 0; i < numeros.length; i++) {
    if (i < numeros.length - 1) {
      texto += "${numeros[i]}, ";
    } else {
      texto += "${numeros[i]}... ";
    }
  }
  print("Inserindo: $texto");
  numeros.forEach((k) => myTree.insert(k));

  print("\nEstrutura Final da Árvore:");
  myTree.printTree(myTree.root, "");
}
