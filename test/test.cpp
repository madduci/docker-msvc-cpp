#include <iostream>

int main()
{
    #ifdef _WIN64
    std::cout << "Hello from MSVC Wine 64!\n";
    #else
  std::cout << "Hello from MSVC Wine 32!\n";
#endif
    return 0;
}