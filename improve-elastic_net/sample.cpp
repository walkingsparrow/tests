#include <vector>
#include <iostream>

using namespace std;

vector<int> generate(int min,int max,int num)
{
    int range = max - min;
    int r = range / num;
    vector<int> result(num);
    for(int i=0;i<num;i++)
        result[i] = rand() % r;

    result[0] += rand() % (range);
    for(int i=1;i<num;i++)
        result[i] += result[i-1];

    for(int i=0;i<num;i++)
        result[i] = result[0]%range + min;
    return result;
}

int main()
{
    vector<int> res = generate(1, 10, 10);
    for (int i = 0; i < 10; i++) cout << res[i] << " ";
    cout << endl;
    return 0;
}
