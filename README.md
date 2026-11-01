# Synthetic worker acceptance fixture

This branch is a deliberately adverse acceptance test, not an application template.
Run only in an approved disposable stand with bounded memory, disk, network and time.
No production registration or deployment. The expanded layer uses sparse zero bytes;
a compressed OCI size limit alone does not bound its expanded size. The secret marker
is generated and was never issued. No scanner pass is asserted by this repository.
