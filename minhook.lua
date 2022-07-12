function load_minhook(path)
    local dll_path = path .. "/luajit_minhook.dll"
    local ffi = require("ffi")
    ffi.cdef([[
    bool mh_initialize();
    bool mh_uninitialize();
    void* mh_create_hook(void* function, void* detour);
    bool mh_remove_hook(void* function);
    bool mh_enable_hook(void* function);
    bool mh_disable_hook(void* function);

    void (*real_GameScreenshake)(struct CameraWorld*, struct vec2*);
    void GameScreenshake_hook_target(struct CameraWorld* camera, struct vec2* pos, float strength);
    void __thiscall GameScreenshake_xmm1_shim(struct CameraWorld* camera, struct vec2* pos);
    ]])

    local minhook = {}

    local lib = ffi.load(dll_path)
    minhook.lib = lib

    function minhook.initialize()
        return lib.mh_initialize()
    end

    function minhook.uninitialize()
        return lib.mh_initialize()
    end

    function is_function_pointer(typ)
        return tostring(typ):find("(*)") ~= nil
    end

    function function_pointer_type(typ)
        if is_function_pointer(typ) then
            return typ
        end

        return ffi.typeof("$*", typ)
    end

    function minhook.create_hook(func, hook)
        local func_type = function_pointer_type(ffi.typeof(func))
        local hook_func = ffi.cast(func_type, hook)
        local ret = lib.mh_create_hook(func, hook_func)

        if ret == nil then
            return nil
        end

        local original = ffi.cast(func_type, ret)
        return {
            func = func,
            hook_func = hook_func,
            original = original
        }
    end

    function minhook.remove(func)
        return lib.mh_remove_hook(func)
    end

    function minhook.enable(func)
        return lib.mh_enable_hook(func)
    end

    function minhook.disable(func)
        return lib.mh_disable_hook(func)
    end

    return minhook
end

return load_minhook
