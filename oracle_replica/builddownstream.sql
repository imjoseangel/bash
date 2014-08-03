STARTUP NOMOUNT
CREATE CONTROLFILE SET DATABASE "DOWNSTRE" RESETLOGS FORCE LOGGING NOARCHIVELOG
    MAXLOGFILES 50
    MAXLOGMEMBERS 5
    MAXDATAFILES 100
    MAXINSTANCES 1
    MAXLOGHISTORY 453
LOGFILE
  GROUP 1 '/opt/oraclesec/oradata/downstream/redo01.log'  SIZE 100M,
  GROUP 2 '/opt/oraclesec/oradata/downstream/redo02.log'  SIZE 100M,
  GROUP 3 '/opt/oraclesec/oradata/downstream/redo03.log'  SIZE 100M,
  GROUP 4 '/opt/oraclesec/oradata/downstream/redo04.log'  SIZE 100M,
  GROUP 5 '/opt/oraclesec/oradata/downstream/redo05.log'  SIZE 100M,
  GROUP 6 '/opt/oraclesec/oradata/downstream/redo06.log'  SIZE 100M,
  GROUP 7 '/opt/oraclesec/oradata/downstream/redo07.log'  SIZE 100M,
  GROUP 8 '/opt/oraclesec/oradata/downstream/redo08.log'  SIZE 100M,
  GROUP 9 '/opt/oraclesec/oradata/downstream/redo09.log'  SIZE 100M
DATAFILE
  '/opt/oraclesec/oradata/downstream/system01.dbf',
  '/opt/oraclesec/oradata/downstream/undotbs01.dbf',
  '/opt/oraclesec/oradata/downstream/downprod01.dbf',
  '/opt/oraclesec/oradata/downstream/downprod02.dbf',
  '/opt/oraclesec/oradata/downstream/downprod03.dbf',
  '/opt/oraclesec/oradata/downstream/downprod04.dbf',
  '/opt/oraclesec/oradata/downstream/downprod05.dbf',
  '/opt/oraclesec/oradata/downstream/sysaux01.dbf',
  '/opt/oraclesec/oradata/downstream/users01.dbf'
CHARACTER SET WE8ISO8859P1
;

ALTER DATABASE OPEN RESETLOGS;

ALTER TABLESPACE TEMP ADD TEMPFILE '/opt/oraclesec/oradata/downstream/temp01.dbf' SIZE 34359730176  REUSE AUTOEXTEND OFF;

ALTER USER downstream IDENTIFIED BY ar1ba9_0racle;

EXIT;
