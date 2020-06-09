#reading specfied amount of data from standard microphone into an userspace buffer.
#in blocking-mode...i.e function would wait until specified amount of data is read.
#Can set a bigger kernelBuffer size if non-deterministic main thread Code to prevent buffer overrun.

#Remember sample size depends on the dataformat(like int16) and num_channels..meaning 512 samples size in bytes would be different for different number of channels used.

#CHECK INPUT AUDIO LEVEL in sound settings..sometimes set to lower.
import alsa

const
    rate = 16000'u32
    kernelBuffer = 8192'u32 #KernelBuffer size for storing micData..must not be overrun.
    nChannels = 1'u32
    #for now this format is supported only TO ADD/See available  formats see ../include/pcm.h #123
    format = SND_PCM_FORMAT_S16_LE   #int16 PCM  LITTLE ENDIAN (recommended)
    mode = BLOCKING_MODE
var buff :array[512,int16] #userSpace buffer for holding data.

let capture_handle: snd_pcm_ref = nil
let hw_params: snd_pcm_hw_params_ref = nil
let device_name = "plughw:0,0"
var err: cint
var dir:cint 
var framesLen: clong

err = snd_pcm_open_nim(unsafeAddr(capture_handle),device_name,SND_PCM_STREAM_CAPTURE,NON_BLOCKING_MODE)
doAssert err == 0'i32
#
err = snd_pcm_hw_params_malloc_nim(unsafeAddr(hw_params))
doAssert err == 0'i32
err = snd_pcm_hw_params_any_nim(capture_handle,hw_params)
doAssert err == 0'i32
#set InterLeaved access
err = snd_pcm_hw_params_set_access_nim(capture_handle,hw_params,SND_PCM_ACCESS_RW_INTERLEAVED)
doAssert err == 0'i32
#set format
err = snd_pcm_hw_params_set_format_nim(capture_handle,hw_params,SND_PCM_FORMAT_S16_LE)
doAssert err == 0'i32
#Set rate
err = snd_pcm_hw_params_set_rate_nim(capture_handle,hw_params,rate,dir)
doAssert err == 0'i32
#   set  nCHannels
err = snd_pcm_hw_params_set_channels_nim(capture_handle,hw_params,nChannels)
doAssert err == 0'i32
err = snd_pcm_hw_params_set_buffer_size_nim(capture_handle,hw_params,kernelBuffer)

#apply hw_params
err = snd_pcm_hw_params_nim(capture_handle,hw_params) 
doAssert err == 0'i32

echo("hw_params successfully applied..")
snd_pcm_hw_params_free_nim(hw_params)


#read some data
echo("Starting reading data ..press CTRL-C to stop")
while true:
    framesLen = snd_pcm_readi_nim(capture_handle,addr(buff[0]),culong(512)) #reading 512 samples ..singlechannel,each 2 bytes..hence 1024 bytes.
    echo(buff[0])

