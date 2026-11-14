# Suite

A JMAP client built for Stalwart in .NET 11.

## Devcontainer setup

The devcontainer configures everything which can be configured automatically. That includes a stalwart mock instance and the database layout.

 However, you should still run a few scripts before you can start developing.

```bash
just stalwart-apply-snapshot
```
This command applies the stalwart snapshot so the server is correctly configured and not in the bootstrapping mode. There is also a command store the current configuration as a snapshot.

```bash
just db-reset
```
There is a database commited into the project which holds mock data and  contains the database layout. However, for development purposes we don't operate on it exactly. This command creates a copy which the code operates on (which accesses it through `$SUITE_DB`). You can also copy the working copy into the git-commited file via command so it can be commited.