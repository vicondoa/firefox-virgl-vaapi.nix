# Troubleshooting

## Firefox is still using software decode

Check `vainfo` first. If the virtio-gpu VA driver does not advertise the needed
profile, fix the graphics stack before debugging this wrapper.

## The wrapper is not being used

Confirm the executable path resolves to this package and that no stock Firefox
package also owns `bin/firefox` in the profile.

## The shim cannot load the real driver

The generic shim compiles in an absolute real-driver path. Rebuild after graphics
stack upgrades so that path still exists.
