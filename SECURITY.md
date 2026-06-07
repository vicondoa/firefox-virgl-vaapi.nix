# Security Policy

Report suspected vulnerabilities through GitHub Security Advisories for this
repository. Do not open public issues for embargoed or exploitable reports.

This repo wraps Firefox and adjusts its environment/policies. It does not provide
a sandbox, does not run setuid, and does not grant additional privileges.

In scope:

- unsafe wrapper behavior introduced here;
- policy or environment changes that unexpectedly broaden browser attack surface;
- supply-chain or CI issues in this repository.

Out of scope:

- upstream Firefox, libva, Mesa, virglrenderer, crosvm, kernel, or GPU driver
  vulnerabilities not caused by this wrapper.
