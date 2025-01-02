#include <iostream>
#include <thread>
#include <vector>
#include <cmath>

class IfPrime
{
public:
    IfPrime(unsigned int theards)
    {
        this->theards=theards;
    }
    bool check(unsigned int n)
    {
        if(n==1) return false;
        const unsigned int limit = sqrt(n);
        for(unsigned int i =2 ; i<limit;i++)
        {
            if(n % i ==0 )
                return false;
        }
        return true;
    }

private:
    unsigned int theards;
};



void work(int n)
{
    for (int i = 0; i < 2000000; i++);
    std::cout << "Koniec wątku " << n << std::endl;
}

int main()
{
    
    unsigned int hwTheards = std::thread::hardware_concurrency();
    hwTheards = hwTheards ? hwTheards : 1;
    IfPrime p(hwTheards);
    if(p.check(12356186))
    {
        std::cout<<"Liczba "<<hwTheards<< "nie jest pierwsza";

    }
    

    return 0;
}
