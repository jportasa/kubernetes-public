#!/bin/bash
#set -e

if [ "${1:0:1}" = '-' ]; then
    set -- postgres "$@"
fi

if [ "$1" = 'postgres' ]; then
    if [ ! -s "$PGDATA/PG_VERSION" ]; then

# Creamos directorios de datos
        mkdir -p ${PGDATA} ${PGXLOG} ${PGWTNDATA} ${PGWTNINDX} ${PGWTNBACK} 
        chown -R ${PGOSUSER}.${PGOSGROUP} ${PGHOME}
        chmod -R 700 ${PGHOME}

# Creamos la base de datos
        gosu ${PGOSUSER} ${PGBINDIR}/initdb --username=${PGOSUSER} ${PGINITDBARGS}

# Cambiamos la configuracion de base de datos
        sed -ri "s/^#(listen_addresses\s*=\s*)\S+/\1'*'/"                                     ${PGDATA}/postgresql.conf
        sed -ri "s/^#(shared_preload_libraries\s*=\s*)\S+/\1'pg_stat_statements'/"            ${PGDATA}/postgresql.conf
        sed -i -e"s/^max_connections = 100.*$/max_connections = 20/"                          ${PGDATA}/postgresql.conf
        sed -i -e"s/^#log_min_duration_statement = -1.*$/log_min_duration_statement = 1000/"  ${PGDATA}/postgresql.conf
        sed -i -e"s/^#log_line_prefix = ''.*$/log_line_prefix = '%t:%r:%u:%d:%p:%x '/"        ${PGDATA}/postgresql.conf

# Permitimos el acceso a la base de datos
        echo "host    all             all             0.0.0.0/0               md5"         >> ${PGDATA}/pg_hba.conf
# Creamos el directorio de log
        mkdir -p ${PGLOG}
        chown -R ${PGOSUSER}.${PGOSGROUP} ${PGLOG}
        chmod -R 700 ${PGLOG}

# Arrancamos el servidor para permitir conectar sólo desde localhost
        echo "Arrancamos base de datos"
        gosu ${PGOSUSER} ${PGBINDIR}/pg_ctl -D "${PGDATA}" -o "-c listen_addresses='localhost'" -w start
        echo "Cambiamos la contraseña del usuario postgres"
        gosu ${PGOSUSER} /usr/bin/psql -c "alter user ${PGDBUSER} with password '${PGDBPASS}';"

# Scripts en local
        echo "Ejecución de scripts del developer:"
        cd ${PGINSTALLDIR}

        for f in ${PGINSTALLDIR}/*; do
            case "$f" in
                *.sh)      
			echo "$0: Ejecutando $f"
			gosu ${PGOSUSER} bash $f 
			;;
#                 *.sql)    
# 			echo "$0: Ejecutando $f"
# 			gosu ${PGOSUSER} /usr/bin/psql -d ${PGDATABASE} -f $f
# 			;;
#                 *.dmp)    
# 			echo "$0: Ejecutando $f"
# 			gosu ${PGOSUSER} /usr/bin/pg_restore -Fd -d ${PGDATABASE} $f
# 			;;
#                 *.dmp.tgz) 
# 			echo "$0: Ejecutando $f"
# 			tar -xzf $f
# 			echo "Archivo $f descomprimido"
# 			gosu ${PGOSUSER} /usr/bin/pg_restore -Fd -d ${PGDATABASE} ${f%.*}
# 			rm -R ${f%.*}
# 			echo "Dump ${f%.*} borrado"
# 			;;
                *)         
			echo "$0: Ignorado   $f" 
			;;
            esac
        done
        cd /
       
        echo "Paramos base de datos"
        gosu ${PGOSUSER} ${PGBINDIR}/pg_ctl -D "${PGDATA}" -m fast -w stop
    fi
fi

echo
echo 'PostgreSQL inicializado, arrancando base de datos...'
echo

# Ejecutamos el comando que se pasa como parametro, por defecto, postgresql
exec gosu ${PGOSUSER} "${PGBINDIR}/$@"
