#include <string>
#include <string_view>

extern "C" __declspec(dllexport)
char* std_string_data(std::string* str)
{
    return str->data();
}

extern "C" __declspec(dllexport)
std::string* std_string_new(const char* cstr)
{
    return new std::string{cstr};
}

extern "C" __declspec(dllexport)
std::string* std_string_new_n(const char* cstr, std::size_t n)
{
    return new std::string{cstr, n};
}

extern "C" __declspec(dllexport)
void std_string_delete(std::string* str)
{
    delete str;
}

extern "C" __declspec(dllexport)
void std_string_assign(std::string* str, const char* cstr)
{
    str->assign(cstr);
}

extern "C" __declspec(dllexport)
void std_string_assign_n(std::string* str, const char* cstr, std::size_t n)
{
    str->assign(cstr, n);
}

extern "C" __declspec(dllexport)
bool std_string_eq(std::string* str, const char* cstr)
{
    return *str == cstr;
}

extern "C" __declspec(dllexport)
int std_string_cmp(std::string* str, const char* cstr)
{
    return str->compare(cstr);
}

extern "C" __declspec(dllexport)
int std_string_cmp_n(std::string* str, const char* cstr, std::size_t n)
{
    return str->compare(std::string_view{cstr, n});
}