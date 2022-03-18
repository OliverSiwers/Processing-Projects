public class MatrixMath {
  public static float[][] multMatrices(float[][] firstMatrix, float[][] secondMatrix) {
    float[][] result = new float[firstMatrix.length][secondMatrix[0].length];

    for (int row = 0; row < result.length; row++) {
      for (int col = 0; col < result[row].length; col++) {
        result[row][col] = multMatricesCell(firstMatrix, secondMatrix, row, col);
      }
    }

    return result;
  }

  private static float multMatricesCell(float[][] firstMatrix, float[][] secondMatrix, int row, int col) {
    float cell = 0;
    for (int i = 0; i < secondMatrix.length; i++) {
      cell += firstMatrix[row][i] * secondMatrix[i][col];
    }
    return cell;
  }

  public static float[][] multMatrixBy(float[][] m, float n) {
    float[][] res = new float[m.length][m[0].length];
    for (int i = 0; i < res.length; i++) {
      for (int j = 0; j < res[0].length; j++) {
        res[i][j] = m[i][j] * n;
      }
    }
    return res;
  }

  public static float[][] addMatrices(float[][] m1, float[][] m2) {
    if (m1.length != m2.length || m1[0].length != m2[0].length) {
      return null;
    }

    float[][] res = new float[m1.length][m1[0].length];
    for (int i = 0; i < res.length; i++) {
      for (int j = 0; j < res[0].length; j++) {
        res[i][j] = m1[i][j] + m2[i][j];
      }
    }
    return res;
  }

  public static float[][] clearMatrix(float[][] m) {
    float[][] res = new float[m.length][m[0].length];
    for (int i = 0; i < res.length; i++) {
      for (int j = 0; j < res[0].length; j++) {
        res[i][j] = 0;
      }
    }
    return res;
  }
}

class MM extends MatrixMath {
}
