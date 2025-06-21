class CLayoutHelper {
  static List<List<int?>> generateCShape(int n) {
    if (n < 5) return [];

    // For different values of n, we need different approaches
    List<List<int?>> grid;

    if (n <= 7) {
      grid = _generateSmallC(n);
    } else if (n <= 12) {
      grid = _generateMediumC(n);
    } else {
      grid = _generateLargeC(n);
    }

    return grid;
  }

  static List<List<int?>> _generateSmallC(int n) {
    int topCount, leftCount, bottomCount;

    if (n == 5) {
      topCount = 2;
      leftCount = 1;
      bottomCount = 2;
    } else if (n == 6) {
      topCount = 2;
      leftCount = 2;
      bottomCount = 2;
    } else {
      // n == 7
      topCount = 3;
      leftCount = 1;
      bottomCount = 3;
    }

    int rows = leftCount + 2;
    int cols = topCount;

    List<List<int?>> grid = List.generate(
      rows,
      (i) => List.generate(cols, (j) => null),
    );

    int boxIndex = 0;

    for (int j = 0; j < topCount; j++) {
      grid[0][j] = boxIndex++;
    }

    for (int i = 1; i < rows - 1; i++) {
      grid[i][0] = boxIndex++;
    }

    // Bottom row
    for (int j = 0; j < bottomCount; j++) {
      grid[rows - 1][j] = boxIndex++;
    }

    return grid;
  }

  static List<List<int?>> _generateMediumC(int n) {
    int topCount = (n * 0.4).round();
    int bottomCount = topCount;
    int leftCount = n - topCount - bottomCount;

    if (leftCount < 1) {
      leftCount = 1;
      topCount = (n - leftCount) ~/ 2;
      bottomCount = n - topCount - leftCount;
    }

    int rows = leftCount + 2;
    int cols = topCount > bottomCount ? topCount : bottomCount;

    List<List<int?>> grid = List.generate(
      rows,
      (i) => List.generate(cols, (j) => null),
    );

    int boxIndex = 0;

    for (int j = 0; j < topCount; j++) {
      grid[0][j] = boxIndex++;
    }

    for (int i = 1; i < rows - 1; i++) {
      grid[i][0] = boxIndex++;
    }

    for (int j = 0; j < bottomCount; j++) {
      grid[rows - 1][j] = boxIndex++;
    }

    return grid;
  }

  static List<List<int?>> _generateLargeC(int n) {
    int topCount = (n * 0.35).round();
    int bottomCount = topCount;
    int leftCount = n - topCount - bottomCount;

    // Ensure proportions make sense
    if (leftCount < 2) {
      leftCount = 2;
      topCount = (n - leftCount) ~/ 2;
      bottomCount = n - topCount - leftCount;
    }

    int rows = leftCount + 2;
    int cols = topCount > bottomCount ? topCount : bottomCount;

    List<List<int?>> grid = List.generate(
      rows,
      (i) => List.generate(cols, (j) => null),
    );

    int boxIndex = 0;

    for (int j = 0; j < topCount; j++) {
      grid[0][j] = boxIndex++;
    }

    for (int i = 1; i < rows - 1; i++) {
      grid[i][0] = boxIndex++;
    }

    for (int j = 0; j < bottomCount; j++) {
      grid[rows - 1][j] = boxIndex++;
    }

    return grid;
  }

  static Map<int, int> getBoxIndexToGridPosition(List<List<int?>> grid) {
    Map<int, int> indexMap = {};
    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[i].length; j++) {
        if (grid[i][j] != null) {
          indexMap[grid[i][j]!] = i * 100 + j; // Simple encoding: row*100 + col
        }
      }
    }
    return indexMap;
  }
}
