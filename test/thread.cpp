
#include "stdio.h"
#include <unistd.h>
#include <thread>
#include <mutex>
#include <chrono>
#include <fstream>

std::mutex mtx;
using namespace std;

void thread_func1()
{
	int i = 0;
	ofstream oss("file_thead.txt");
	while(1)
	{
		if (i == 1000) break;
//		mtx.lock();
		i++;
		printf("%d_%d\n",::std::this_thread::get_id(), i);
//		::std::this_thread::sleep_for(std::chrono::seconds(1));
//		mtx.unlock();
		oss << i << endl;
	}
	oss.close();
}

int main()
{
//	::std::thread (thread_func1).detach();
	::std::thread t1(thread_func1);
//	t1.detach();
//	::std::thread t2(thread_func1);
	if(t1.joinable()) t1.join();
//	if(t2.joinable()) t2.join();
//	printf("%d\n", t1.joinable());
	return 0;
}
