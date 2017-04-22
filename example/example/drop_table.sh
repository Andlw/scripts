#!/bin/sh
# Small script to delete the HBase tables used by OpenTSDB.
# !!!! do not use it in production environment. It is very dangerous !!!
test -n "$HBASE_HOME" || {
  echo >&2 'The environment variable HBASE_HOME must be set'
  exit 1
}
test -d "$HBASE_HOME" || {
  echo >&2 "No such directory: HBASE_HOME=$HBASE_HOME"
  exit 1
}

TSDB_TABLE=${TSDB_TABLE-'tsdb'}
UID_TABLE=${UID_TABLE-'tsdb-uid'}
TREE_TABLE=${TREE_TABLE-'tsdb-tree'}
META_TABLE=${META_TABLE-'tsdb-meta'}

# HBase scripts also use a variable named `HBASE_HOME', and having this
# variable in the environment with a value somewhat different from what
# they expect can confuse them in some cases.  So rename the variable.
hbh=$HBASE_HOME
unset HBASE_HOME
exec "$hbh/bin/hbase" shell <<EOF
disable '$UID_TABLE'
drop '$UID_TABLE'

disable '$TSDB_TABLE'
drop '$TSDB_TABLE'

disable '$TREE_TABLE'
drop '$TREE_TABLE'

disable '$META_TABLE'
drop '$META_TABLE'
EOF
