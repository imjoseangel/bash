export ORACLE_BASE=/opt/oraclesec
export ORACLE_HOME=$ORACLE_BASE/product/10.2.0/db_1
export PATH=$PATH:$ORACLE_HOME/bin
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
export ORACLE_SID=transaction
sqlplus / as sysdba @/home/oracle/buildtransaction.sql
