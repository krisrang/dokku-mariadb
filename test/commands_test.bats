#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$MARIADB_ROOT"
  dokku apps:create testapp
  # $dokkucmd mariadb:start
}

teardown() {
  # dokku apps:destroy testapp
  rm -rf "$DOKKU_ROOT"
}

@test "mariadb:create requires an app name" {
  run dokku mariadb:create
  assert_exit_status 1
  assert_output "(verify_app_name) APP must not be null"
}

@test "mariadb:create creates files and sets env" {
  run dokku mariadb:create testapp
  assert_db_exists
  assert_success
  assert_output "-----> Creating database testapp
-----> Setting config vars for testapp"
  run dokku config testapp
  assert_contains "$output" "mysql://testapp"
}

@test "mariadb:delete deletes database" {
  run dokku mariadb:create testapp
  assert_success
  run dokku mariadb:delete testapp
  assert_success
  assert_output "-----> Deleting database testapp
-----> Unsetting config vars for testapp"
  [ ! -f "$MARIADB_ROOT/db_testapp" ]
}

@test "mariadb:list lists databases" {
  run dokku mariadb:create testapp
  run dokku mariadb:list --quiet
  assert_success
  assert_output "exec called with exec --interactive --tty dokku-psqlkr env TERM=$TERM psql -h localhost -U postgres -c \l"
}

@test "mariadb:url returns psql url" {
  run dokku mariadb:create testapp
  run dokku mariadb:url testapp
  PASS=$(cat "$MARIADB_ROOT/pass_testapp")
  assert_success
  assert_output "mysql://testapp:$PASS@mariadb:3306/testapp"
}

@test "mariadb:console calls docker exec" {
  run dokku mariadb:create testapp
  run dokku mariadb:console testapp
  PASS=$(cat "$MARIADB_ROOT/pass_testapp")
  assert_success
  assert_output "exec called with exec --interactive --tty dokku-psqlkr env TERM=$TERM PGPASSWORD=$PASS psql -h localhost -U testapp testapp"
}

@test "mariadb:stop stops psql container" {
  run dokku mariadb:stop
  assert_success
  assert_output "-----> Stopping MariaDB server"
}

@test "mariadb:dump feeds database dump" {
  run dokku mariadb:create testapp
  run dokku mariadb:dump testapp
  assert_success
  assert_output "pg_dump"
}

@test "mariadb:docker_args gives correct link" {
  run dokku mariadb:create testapp
  run bash -c "echo 'test' | dokku mariadb:docker_args testapp"
  assert_success
  assert_output "test --link dokku-mariadbkr:mariadb"
}
