#include <utility>
#include <string>
#include <vector>

using namespace std;

class ElementBase
{
public:
	virtual ~ElementBase(){}
};
class Element
{
public:
	Element()
	{
		printf("construct is called\n");
		i = -1;
	}
	Element(const Element& other)
	{
		this->i = other.i;
		printf("copy construct is called, i = %d\n", i);
	}
	Element(Element&& other)
	{
		this->i = other.i;
		other.i = 100;
		printf("copy && construct is called, i = %d\n", i);
	}
	~Element()
	{
		printf("destroy is called, i = %d\n", i);
	}
	Element& operator=(const Element& other)
	{
		if (&other == this) return *this;
		this->i = other.i;
		printf("assign function is called\n");
		return *this;
	}
	Element& operator=(Element&& other)
	{
		if (&other == this) return *this;
		this->i = other.i;
		other.i = 101;
		printf("assign && function is called\n");
		return *this;
	}
	int i;
};
int w = 0;
vector<Element> g_elements;
vector<Element> g_add_elements;

Element GetElement()
{
	Element ele;
	printf("addr = %p\n", &ele);
	ele.i = w;
	w++;
	if (w == 1)
	{
		return ele;
	}
	else
	{
		return ele;
	}
}

void SetElements(const vector<Element>& _elements)
{
	//g_elements.swap(_elements);
}

void SetElement(const Element& _elements)
{
	g_elements.push_back(_elements);
}
void AddElement(const Element& _element)
{
	g_add_elements.push_back(std::move(_element));	
}

//void AddElements(const vector<Element>& _elements)
//{
//	g_add_elements.
//}

int main()
{
	Element ele;
	ele.i = 1000;	
#if 0
	vector<Element> ele_list;
	printf("function would be called， i = %d\n", ele.i);
	SetElement(ele);
	printf("SetElement function was called, i = %d\n", ele.i);
	AddElement(ele);
	printf("AddElement function was called, i = %d\n", ele.i);
	ele_list.push_back(std::move(ele));
	printf("push back  was called, i = %d\n", ele.i);
#endif	
	Element e = GetElement();
	printf("addr = %p\n", &e);
//	GetElement();
	return 0;
}
