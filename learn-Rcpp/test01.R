library(Rcpp)

cppFunction("
  int add(int x, int y, int z) {
    int sum = x + y + z;
    return sum;
  }
")

add(2,3,4)
