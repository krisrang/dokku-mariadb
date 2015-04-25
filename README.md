dokku-mariadb [![Build Status](https://travis-ci.org/krisrang/dokku-mariadb.svg?branch=master)](https://travis-ci.org/krisrang/dokku-mariadb)
================

dokku-mariadb is a plugin for [dokku][dokku] that provides PostgreSQL servers for your applications.

It uses the official MariadDB docker image (version 10).

This version is tested against dokku 0.3.17.

## Installation

```
git clone https://github.com/krisrang/dokku-mariadb /var/lib/dokku/plugins/mariadbkr
dokku plugins-install
```


## Commands
```
$ dokku help
    mariadb:admin_console                           Launch a mariadb admin cli
    mariadb:console     <app>                       Launch a mariadb cli for <app>
    mariadb:create      <app>                       Create a mariadb database for <app>
    mariadb:delete      <app>                       Delete mariadb database for <app>
    mariadb:url         <app>                       Get DATABASE_URL for <app>
    mariadb:dump        <app> > <filename.dump>     Dump <app> database to dump file
    mariadb:restore     <app> < <filename.*>        Restore database to <app> from file
    mariadb:list                                    List all databases
    mariadb:restart                                 Restart the mariadb docker container
    mariadb:start                                   Start the mariadb docker container if it isn't running
    mariadb:status                                  Shows status of mariadb
    mariadb:stop                                    Stop the mariadb docker container
```

## Info
This plugin adds the following environment variables to your app via config vars (they are available via `dokku config <app>`):

* DATABASE\_URL
* MYSQL\_URL
* DB\_HOST
* DB\_NAME
* DB\_DB
* DB\_USER
* DB\_PASS
* DB\_PORT

## Usage

### Start MariadDB:
```
$ dokku mariadb:start               # Server side
$ ssh dokku@server mariadb:start    # Client side
```

### Stop MariadDB:
```
$ dokku mariadb:stop                # Server side
$ ssh dokku@server mariadb:stop     # Client side
```

### Restart MariadDB:
```
$ dokku mariadb:restart             # Server side
$ ssh dokku@server mariadb:restart  # Client side
```

### Create a new database for an existing app:
```
$ dokku mariadb:create <app>              # Server side
$ ssh dokku@server mariadb:create <app>   # Client side
```

### Dump database:
```
$ dokku mariadb:dump <app> > filename.dump # Server side
```

### Restore database from dump:
```
$ dokku mariadb:restore <app> < filename.dump # Server side
```

### Copy database foo to database bar using pipe:
```
$ dokku mariadb:dump <app> | dokku mariadb:restore <app> # Server side
```

## Acknowledgements

This plugin is based originally on the [dokku-psql-single-container](https://github.com/Flink/dokku-psql-single-container).

## License

This plugin is released under the MIT license. See the file [LICENSE](LICENSE).

[dokku]: https://github.com/progrium/dokku
