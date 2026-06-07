# Removal criteria

Remove this wrapper when the target stack no longer needs Firefox-specific
policy/probe glue and the generic VA-API descriptor shim is no longer needed for
hardware playback. Re-test after Firefox, Mesa, libva, virglrenderer, crosvm, or
Cloud Hypervisor upgrades.
