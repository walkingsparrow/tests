#include <exception>
#include <stdexcept>
#include <cstdlib>
#include <vector>
#include <iostream>
#include <ctime>
#include <algorithm>    // 
#include <cstdlib>      // std::rand, std::srand


int main() {
    srand (time(NULL));
    std::vector<int> res(10, 0);
    for (int i = 0; i < 10; i++) res[i] = i;
    std::random_shuffle(res.begin(), res.end());
    for (int i = 0; i < 10; i++) {
        std::cout << res[i] << " ";
    }
    std::cout << std::endl;
    return 0;
}


