# AgentSpore A4 acceptance fixture

This repository contains synthetic public test data for AgentSpore deployment acceptance.
It is not a product and contains no credentials, user data, external API integrations,
package installation, or persistent storage. The same pinned official BusyBox image
serves static files on port 8080 as UID/GID 10001.

The healthy revision contains `www/health`, which returns HTTP 200 at `/health`.
The deliberately unhealthy revision removes only that file: `/health` returns HTTP 404,
while `/` still serves a static page. Use immutable commit IDs when testing the normal
fetch, scan, build, deployment and promotion pipeline. A failed unhealthy replacement
must leave the previous healthy deployment active.

Local runtime checks confirmed both responses under a read-only root filesystem.
This does not establish scanner acceptance, public fetch availability, production
approval, or successful operation of the complete deployment pipeline. Never disable
security gates to make this fixture pass. The pinned base still requires operator
approval under the platform's existing base-image policy.

## Expanded ZIP64 pressure revision

This revision keeps the healthy static service unchanged and adds `/pressure.jar`.
The JAR is a valid stored ZIP64 archive containing `padding.bin` with exactly
21,474,836,480 zero bytes (20 GiB), including its CRC and 64-bit size/offset records.
The two committed binary fragments total 236 bytes. During Docker build, `dd`
seeks past the header and zero-filled sparse gap, then writes the central directory
and footer. No large payload is stored in Git or generated on the preparation host.

Only execute this fixture in the approved disposable worker acceptance environment
with bounded build, scanner memory and writable storage. Sparse filesystem storage
does not bound expanded scanner data or image-export I/O. A successful build alone
is not acceptance: the intended test requires an observed scanner resource-limit
refusal, preservation of the previous route, bounded cleanup and a subsequent
healthy job. `runtime_unavailable` is inconclusive for that purpose. No gate may be
bypassed. This revision has not been built or executed during preparation.

The generated fragments use the reviewed `jar_parts` ZIP64 format. Small actual
archives of 0, 1, 65,537 and 1,048,576 bytes passed ZIP parsing and CRC checks.
The BusyBox [dd documentation](https://busybox.net/downloads/BusyBox.html) specifies
`bs`, `seek` and `conv=notrunc`; the pinned image still needs native verification.
