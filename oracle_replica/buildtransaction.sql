STARTUP NOMOUNT
CREATE CONTROLFILE SET DATABASE "TRANSACT" RESETLOGS FORCE LOGGING NOARCHIVELOG
    MAXLOGFILES 50
    MAXLOGMEMBERS 5
    MAXDATAFILES 100
    MAXINSTANCES 1
    MAXLOGHISTORY 453
LOGFILE
  GROUP 1 '/opt/oraclesec/oradata/transaction/redo01.log'  SIZE 100M,
  GROUP 2 '/opt/oraclesec/oradata/transaction/redo02.log'  SIZE 100M,
  GROUP 3 '/opt/oraclesec/oradata/transaction/redo03.log'  SIZE 100M,
  GROUP 4 '/opt/oraclesec/oradata/transaction/redo04.log'  SIZE 100M,
  GROUP 5 '/opt/oraclesec/oradata/transaction/redo05.log'  SIZE 100M,
  GROUP 6 '/opt/oraclesec/oradata/transaction/redo06.log'  SIZE 100M,
  GROUP 7 '/opt/oraclesec/oradata/transaction/redo07.log'  SIZE 100M,
  GROUP 8 '/opt/oraclesec/oradata/transaction/redo08.log'  SIZE 100M,
  GROUP 9 '/opt/oraclesec/oradata/transaction/redo09.log'  SIZE 100M
DATAFILE
  '/opt/oraclesec/oradata/transaction/system01.dbf',
  '/opt/oraclesec/oradata/transaction/undotbs01.dbf',
  '/opt/oraclesec/oradata/transaction/tranprod01.dbf',
  '/opt/oraclesec/oradata/transaction/tranprod02.dbf',
  '/opt/oraclesec/oradata/transaction/tranprod03.dbf',
  '/opt/oraclesec/oradata/transaction/tranprod04.dbf',
  '/opt/oraclesec/oradata/transaction/tranprod05.dbf',
  '/opt/oraclesec/oradata/transaction/tranprod06.dbf',
  '/opt/oraclesec/oradata/transaction/tranprod07.dbf',
  '/opt/oraclesec/oradata/transaction/sysaux01.dbf',
  '/opt/oraclesec/oradata/transaction/users01.dbf'
CHARACTER SET WE8ISO8859P1
;

ALTER DATABASE OPEN RESETLOGS;

ALTER TABLESPACE TEMP ADD TEMPFILE '/opt/oraclesec/oradata/transaction/temp01.dbf' SIZE 34359730176  REUSE AUTOEXTEND OFF;

ALTER USER transaction IDENTIFIED BY ar1ba9_0racle;

EXIT;
