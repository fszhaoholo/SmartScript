#include "stdio.h"
#include <map>

using namespace std;

int main()
{
	map<int, int> map_clear;
	int i = 0;
	int j = 0;
	while(1)
	{
		map_clear.insert(pair<int, int>(i,i));
		i++;
		if (i == 10737400)
		{
//			map_clear.clear();
			map<int, int>().swap(map_clear);
			printf("+++++++++%d+++++\n", j);
			i = 0;
			j++;
		}
	}
	return 0;
}
