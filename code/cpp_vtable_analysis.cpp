// http://blog.csdn.net/haoel/article/details/3081385

#include <iostream>
using namespace std;

class B
{
    public:
        int ib;
        char cb;
    public:
        B():ib(0),cb('B') {}
 
        virtual void f() { cout << "B::f()" << endl;}
        virtual void Bf() { cout << "B::Bf()" << endl;}
};
class B1 :  virtual public B
{
    public:
        int ib1;
        char cb1;
    public:
        B1():ib1(11),cb1('1') {}
 
        virtual void f() { cout << "B1::f()" << endl;}
        virtual void f1() { cout << "B1::f1()" << endl;}
        virtual void Bf1() { cout << "B1::Bf1()" << endl;}
 
};
class B2:  virtual public B
{
    public:
        int ib2;
        char cb2;
    public:
        B2():ib2(12),cb2('2') {}
 
        virtual void f() { cout << "B2::f()" << endl;}
        virtual void f2() { cout << "B2::f2()" << endl;}
        virtual void Bf2() { cout << "B2::Bf2()" << endl;}
       
};
 
class D : public B1, public B2
{
    public:
        int id;
        char cd;
    public:
        D():id(100),cd('D') {}
 
        virtual void f() { cout << "D::f()" << endl;}
        virtual void f1() { cout << "D::f1()" << endl;}
        virtual void f2() { cout << "D::f2()" << endl;}
        virtual void Df() { cout << "D::Df()" << endl;}
       
};

typedef void(*Fun)(void);

int main()
{
    void* ptr = NULL;
    long** pVtab = NULL;
    Fun pFun = NULL;
    D d;

    ptr = (void*)&d; 
    cout << ptr << endl;

    pVtab = (long**)&d;
    cout << "[0] D::B1::_vptr->" << endl;
    for (int i = 0; (long)pVtab[0][i] != 24; i++)
    {
        pFun = (Fun)pVtab[0][i];
        cout << "     ["<<i<<"] ";    pFun(); //D::f1();
    }
 
    ptr = (void*)((long*)ptr+1); 
    cout << ptr << endl;
 
    cout << "[1] B1::ib1 = ";
    cout << *(int*)ptr <<endl; //B1::ib1
    ptr = (void*)((int*)ptr+1); 
    cout << "[2] B1::cb1 = ";
    cout << *(char*)ptr << endl; //B1::cb1
    ptr = (void*)((int*)ptr+1); 
 
    //---------------------
    cout << ptr << endl;

    cout << "[3] D::B2::_vptr->" << endl;
    pVtab = (long**)ptr;
    for (int i = 0; (long)pVtab[0][i] != 0; i++)
    {
        pFun = (Fun)pVtab[0][i];
        cout << "     ["<<i<<"] ";    pFun(); //D::f1();
    }
   
    ptr = (void*)((long*)ptr+1); 
    cout << ptr << endl;
 
    cout << "[4] B2::ib2 = ";
    cout << *(int*)ptr <<endl; //B1::ib1
    ptr = (void*)((int*)ptr+1); 
    cout << "[5] B2::cb2 = ";
    cout << *(char*)ptr << endl; //B1::cb1
    ptr = (void*)((int*)ptr+1); 
 
    cout << "[6] D::id = ";
    cout << *(int*)ptr <<endl; //B1::ib1
    ptr = (void*)((int*)ptr+1); 
    cout << "[7] D::cd = ";
    cout << *(char*)ptr << endl; //B1::cb1
    ptr = (void*)((int*)ptr+1); 
 
    //---------------------
    cout << ptr << endl;

    cout << "[8] D::B::_vptr->" << endl;
    pVtab = (long**)ptr;
    for (int i = 0; i < 2; i++)
    {
        pFun = (Fun)pVtab[0][i];
        cout << "     ["<<i<<"] ";    pFun(); //D::f1();
    }
   
    ptr = (void*)((long*)ptr+1); 
    cout << ptr << endl;

    cout << "[9] B::ib = ";
    cout << *(int*)ptr <<endl; //B1::ib1
    ptr = (void*)((int*)ptr+1); 
    cout << "[10] B::cb = ";
    cout << *(char*)ptr << endl; //B1::cb1

    return 0;
}
