#include <iostream>
using namespace std;

class A
{
    int i;
    char a;
};

class B : public A
{
    char b;
};

class C : public B
{
    char c;
};

int main()
{
    cout<<sizeof(A)<<endl;
    cout<<sizeof(C)<<endl;
    return 0;
}
