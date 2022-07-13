function load_minhook(path)
    local minhook = {}
    local ffi = require("ffi")

    local dll_path = path .. "/luajit_minhook.dll"

    local lib = ffi.load(dll_path)
    minhook.lib = lib

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

    minhook.initialize = lib.mh_initialize
    minhook.uninitialize = lib.mh_initialize
    minhook.remove = lib.mh_remove_hook
    minhook.enable = lib.mh_enable_hook
    minhook.disable = lib.mh_disable_hook

    function is_function_pointer(typ)
        return tostring(typ):find("(*)") ~= nil
    end

    -- Returns a function pointer type when the given type is a function or
    -- function pointer.
    function function_pointer_type(typ)
        if is_function_pointer(typ) then
            return typ
        end

        local new_type = ffi.typeof("$*", typ)
        if not is_function_pointer(new_type) then
            error("Given type is not a function or function pointer")
        end

        return new_type
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

    return minhook
end

return load_minhook
