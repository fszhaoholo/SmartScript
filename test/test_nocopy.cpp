#include "stdio.h"

class NoCopy
{
protected:
	NoCopy(){}
	~NoCopy(){}
	
private:
	NoCopy(const NoCopy&) = delete;
	NoCopy& operator=(const NoCopy&) = delete;
	
};

class Test : private NoCopy
{
public:
	Test()
	{
		printf("i am your father\n");
		i = 0;
	}
	Test(const Test& _p):NoCopy(_p)
	{
		
	}
	int i;
};


// struct Uncopyable
// {
//     ~Uncopyable() {}
 
//     Uncopyable(const Uncopyable&) = delete;
//     Uncopyable& operator=(const Uncopyable&) = delete;
// };
 
// struct Dervied : private Uncopyable
// {
// 	// Dervied(int w)
// 	// {
// 	// 	i = w;
// 	// }
// 	// Dervied()
// 	// {
// 	// }
// 	int i;
// };

int main()
{
	Test t1;
	// Test t2(t1);
	// Dervied test1;
	// Dervied test2(test1);

	// Dervied test1;
	// Dervied test2(test1);
	return 0;
}
