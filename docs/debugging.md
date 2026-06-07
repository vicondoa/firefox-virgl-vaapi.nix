# Debugging

First verify the guest has a working virtio-gpu VA-API path:

```bash
LIBVA_DRIVER_NAME=virtio_gpu vainfo
```

Look for H.264 decode profiles and `VAEntrypointVLD`. The wrapper cannot create
missing decoder capabilities.

Run Firefox with extra logging when diagnosing playback:

```bash
VIRGL_VAAPI_COMPAT_DEBUG=1 \
MOZ_LOG="PlatformDecoderModule:5,FFmpegVideo:5,DMABUF:5,WidgetDMABuf:5,VAAPI:5" \
MOZ_LOG_FILE=firefox-vaapi.log \
firefox
```

Useful evidence includes hardware decode selection, `VAAPI_VLD`, and shim logs
showing I420 `DRM_PRIME_2` descriptors rewritten to YV12 with a U/V layer swap.
