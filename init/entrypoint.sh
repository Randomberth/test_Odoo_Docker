#!/bin/bash
set -e

echo "=== Odoo 19 - Configuración de Inicio ==="

# Configurar permisos de desarrollo
echo "→ Configurando permisos de addons..."
chown -R 100:101 /mnt/extra-addons 2>/dev/null || true
chmod -R 775 /mnt/extra-addons

# Crear directorio de logs si no existe
mkdir -p /var/log/odoo
chown -R 100:101 /var/log/odoo 2>/dev/null || true

# Generar odoo.conf dinámicamente desde variables de entorno
echo "→ Generando configuración de Odoo..."
cat > /etc/odoo/odoo.conf << EOF
[options]
addons_path = /mnt/extra-addons
data_dir = /var/lib/odoo

; Configuración de la base de datos
db_host = ${DB_HOST:-postgres}
db_port = ${DB_PORT:-5432}
db_user = ${DB_USER:-odoo}
db_password = ${DB_PASSWORD:-myodoo2024}

; Configuración del servidor
http_port = 8069
logfile = /var/log/odoo/odoo.log
log_level = info

; Seguridad
admin_passwd = ${ADMIN_PASSWORD:-admin12345}
EOF

echo "→ Configuración generada correctamente"

echo "=== Permisos OK - Iniciando Odoo 19 ==="
exec /entrypoint.sh "$@"