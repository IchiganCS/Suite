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
There is a database schema commited into the project with some additional seed data and. However, for development purposes we create the database for it through this command. The code operates on it through an environment variable (`SUITE_DB`). You can also export the changed datbase through another just command.