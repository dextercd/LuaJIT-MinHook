#include <MinHook.h>

extern "C" __declspec(dllexport)
bool mh_initialize()
{
    return MH_Initialize() == MH_OK;
}

extern "C" __declspec(dllexport)
bool mh_uninitialize()
{
    return MH_Uninitialize() == MH_OK;
}

extern "C" __declspec(dllexport)
void* mh_create_hook(void* function, void* detour)
{
    void* original;
    if (MH_CreateHook(function, detour, &original) != MH_OK)
        return nullptr;

    return original;
}

extern "C" __declspec(dllexport)
bool mh_remove_hook(void* function)
{
    return MH_RemoveHook(function) == MH_OK;
}

extern "C" __declspec(dllexport)
bool mh_enable_hook(void* function)
{
    return MH_EnableHook(function) == MH_OK;
}

extern "C" __declspec(dllexport)
bool mh_disable_hook(void* function)
{
    return MH_DisableHook(function) == MH_OK;
}

struct CameraWorld;
struct vec2;

extern "C" __declspec(dllexport)
void (__thiscall *real_GameScreenshake)(CameraWorld* camera, vec2* pos) = nullptr;

extern "C" [[gnu::noinline]] __declspec(dllexport)
void GameScreenshake_hook_target(CameraWorld* camera, vec2* pos, float strength)
{
    asm("");
    __asm movd xmm1, strength;
    real_GameScreenshake(camera, pos);
}

extern "C" __declspec(dllexport)
void __thiscall GameScreenshake_xmm1_shim(CameraWorld* camera, vec2* pos)
{
    float strength;
    __asm movd strength, xmm1

    GameScreenshake_hook_target(camera, pos, strength);
}


BOOL WINAPI DllMain(
    HINSTANCE hinstDLL,
    DWORD fdwReason,
    LPVOID lpReserved)
{
    switch(fdwReason) { 
    case DLL_PROCESS_DETACH:
        MH_Uninitialize();
        break;
    }

    return TRUE;
}
