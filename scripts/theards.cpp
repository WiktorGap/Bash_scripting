#include <iostream>
#include <thread>
#include <vector>

void loop(int n)
{
    for (int i = 0; i < 2000000; i++);
    std::cout << "Koniec wątku " << n << std::endl;
}

int main()
{
    std::vector<std::thread> threads;
    unsigned int hwTheards = std::thread::hardware_concurrency();
    hwTheards = hwTheards ? hwTheards : 1;
    // Tworzenie wątków
    for (int i = 0; i < hwTheards; i++)
    {
        threads.emplace_back(loop, i);
    }
    

    // Oczekiwanie na zakończenie wątków
    for (int i = 0; i < hwTheards; i++)
    {

        std::cout << "Oczekiwanie na wątek " << i << std::endl;
        threads[i].join();
    }

    return 0;
}
