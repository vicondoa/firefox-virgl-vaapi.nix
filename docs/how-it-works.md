# How it works

The wrapper copies a Firefox package and replaces its main executable with a
wrapper that sets:

- `LIBVA_DRIVER_NAME=virtio_gpu`
- `LIBVA_DRIVERS_PATH=<virgl-vaapi-compat>/lib/dri:...`
- `MOZ_ENABLE_WAYLAND=1`

It also writes a Firefox enterprise `distribution/policies.json` file with locked
VA-API/DMABUF preferences and replaces Firefox's scoped `glxtest` helper with a
small virgl probe stub. The generic libva driver shim is provided by the
`virgl-vaapi-compat` input.

The package still exposes the ordinary `bin/firefox` command so downstream
environments can make all Firefox launches go through this wrapper.
