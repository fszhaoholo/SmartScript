#include <vector>
#include "stdio.h"
#include <set>

using namespace std;
class Test
{
public:
	Test()
	{
		i = 0;
		printf("i am construct.\n");
	}
	Test(const Test &_p)
	{
		i = _p.i;
		printf("i am copy construct. \n");
	}
	Test& operator= (const Test &_p)
	{
		if (&_p != this)
		{
			i = _p.i;
		}
		printf("i am assignment operator. \n");
	}
	bool operator <(Test &_p)
	{
		return i < _p.i;
	}
	bool operator ==(const Test &_p)
	{
		return _p.i == i;
	}
	int i;
};


Test func()
{
	Test t;
	t.i = 10;
	return t;
}

int main()
{
	vector<Test> test_list;
//	set<Test> test_list;
	Test t;
	test_list.push_back(t);
	
	Test t1;
	printf("-------------\n");
	t1 = func();
	return 0;
}
