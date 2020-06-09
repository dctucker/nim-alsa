
const
    sharedLib = "libasound.so" #generally in all linux distros,

type 
    openModes*{.size:sizeof(culong).} = enum
        BLOCKING_MODE = 0x00000001
        NON_BLOCKING_MODE = 0x00000002
        ASYNC_MODE = 0x00008000
        NO_AUTO_RESAMPLE = 0x00010000
        NO_AUTO_CHANNELS = 0X00020000
        NO_AUTO_FORMAT = 0x00040000
        NO_SOFTVOL = 0x00080000
    streamModes* {.size: sizeof(cint).} = enum
        SND_PCM_STREAM_PLAYBACK = 0
        SND_PCM_STREAM_CAPTURE = 1

type
    accessModes*{.size: sizeof(cint).}  = enum 
        #mmap access with simple interleaved channels 
        SND_PCM_ACCESS_MMAP_INTERLEAVED = 0,
        #mmap access with simple non interleaved channels
        SND_PCM_ACCESS_MMAP_NONINTERLEAVED,
        #mmap access with complex placement 
        SND_PCM_ACCESS_MMAP_COMPLEX,
        #snd_pcm_readi/snd_pcm_writei access 
        SND_PCM_ACCESS_RW_INTERLEAVED,          #Generally Default.
        #snd_pcm_readn/snd_pcm_writen access 
        SND_PCM_ACCESS_RW_NONINTERLEAVED,
        #SND_PCM_ACCESS_LAST = SND_PCM_ACCESS_RW_NONINTERLEAVED


#Format..Only defining INT16 bit LittleEndian...FOR MORE ../include/pcm.h #123
type 
    pcmFormats*{.size: sizeof(cint).} = enum
        SND_PCM_FORMAT_S16_LE = 2'i32
        #TODO:  Add more formats..

#incomplete structs

type 
    snd_pcm_obj{.incompleteStruct.} = object
    snd_pcm_ref* = ptr snd_pcm_obj
    snd_pcm_hw_params_obj {.incompleteStruct.} = object
    snd_pcm_hw_params_ref* = ptr snd_pcm_hw_params_obj

proc snd_pcm_hw_params_malloc_nim*(hw_params_ptr: ptr snd_pcm_hw_params_ref):cint {.importc:"snd_pcm_hw_params_malloc",cdecl, dynlib:sharedLib.}
proc snd_pcm_hw_params_free_nim*(hw_params: snd_pcm_hw_params_ref){.importc:"snd_pcm_hw_params_free",cdecl,dynlib:sharedLib.}

#open pcm device for capturing.
proc snd_pcm_open_nim*(pcm_ref: ptr snd_pcm_ref,name: cstring,streamMode:streamModes = SND_PCM_STREAM_CAPTURE,mode:openModes):cint {.importc:"snd_pcm_open",cdecl,dynlib:sharedLib.}
proc snd_pcm_hw_params_any_nim*(pcm: snd_pcm_ref,params: snd_pcm_hw_params_ref):cint {.importc: "snd_pcm_hw_params_any",cdecl,dynlib:sharedLib.}

#Hardware Params setting.
proc snd_pcm_hw_params_set_access_nim*(pcm: snd_pcm_ref,params: snd_pcm_hw_params_ref,mode:accessModes = SND_PCM_ACCESS_RW_INTERLEAVED):cint {.importc:"snd_pcm_hw_params_set_access",cdecl,dynlib:sharedLib.}
proc snd_pcm_hw_params_set_format_nim*(pcm:snd_pcm_ref,params:snd_pcm_hw_params_ref,format:pcmFormats = SND_PCM_FORMAT_S16_LE):cint {.importc:"snd_pcm_hw_params_set_format",cdecl,dynlib:sharedLib.}
proc snd_pcm_hw_params_set_rate_near_nim*(pcm:snd_pcm_ref,params:snd_pcm_hw_params_ref,val:ptr cuint,dir:ptr cint):cint {.importc:"snd_pcm_hw_params_set_rate_near",cdecl,dynlib:sharedLib.}
proc snd_pcm_hw_params_set_channels_nim*(pcm:snd_pcm_ref,params:snd_pcm_hw_params_ref,val: cuint):cint {.importc:"snd_pcm_hw_params_set_channels",cdecl,dynlib:sharedLib.}
proc snd_pcm_hw_params_set_buffer_size_nim*(pcm:snd_pcm_ref,params:snd_pcm_hw_params_ref,size:culong):cint {.importc:"snd_pcm_hw_params_set_buffer_size",cdecl,dynlib:sharedLib.}
proc snd_pcm_hw_params_set_rate_nim*(pcm:snd_pcm_ref,params:snd_pcm_hw_params_ref,val:cuint,dir:cint):cint {.importc:"snd_pcm_hw_params_set_rate",cdecl,dynlib:sharedLib.}
#Apply hardware parameters to PCM DEVICE and prepare device
proc snd_pcm_hw_params_nim*(pcm:snd_pcm_ref,params: snd_pcm_hw_params_ref):cint {.importc:"snd_pcm_hw_params",cdecl,dynlib:sharedLib.}

#readi ..reading interleaved data from MIC to buffer
proc snd_pcm_readi_nim*(pcm:snd_pcm_ref,buff:pointer,size:culong): clong {.importc:"snd_pcm_readi",cdecl,dynlib:sharedLib.}

