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
