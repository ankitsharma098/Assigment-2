// utils/c_layout_helper.dart
class CLayoutHelper {
  static List<List<bool>> generateCShape(int n) {
    if (n < 5) return [];

    // Calculate grid dimensions for C shape
    int rows = ((n + 1) / 2).ceil() + 1;
    int cols = 3;

    // Adjust for larger numbers
    if (n > 15) {
      cols = ((n - rows * 2) / (rows - 2)).ceil() + 2;
    }

    List<List<bool>> grid = List.generate(
      rows,
      (i) => List.generate(cols, (j) => false),
    );

    int boxCount = 0;

    // Top row
    for (int j = 0; j < cols && boxCount < n; j++) {
      grid[0][j] = true;
      boxCount++;
    }

    // Left column (excluding top and bottom)
    for (int i = 1; i < rows - 1 && boxCount < n; i++) {
      grid[i][0] = true;
      boxCount++;
    }

    // Bottom row
    if (boxCount < n) {
      for (int j = 0; j < cols && boxCount < n; j++) {
        grid[rows - 1][j] = true;
        boxCount++;
      }
    }

    return grid;
  }

  static List<int> getBoxIndices(List<List<bool>> grid) {
    List<int> indices = [];
    int index = 0;

    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[i].length; j++) {
        if (grid[i][j]) {
          indices.add(index);
          index++;
        }
      }
    }

    return indices;
  }
}
