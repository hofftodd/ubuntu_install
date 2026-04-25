#!/bin/bash
set -e

# Install PostgreSQL server, contrib extensions, and pgcli (a nicer psql).
sudo apt-get update
sudo apt-get install -y postgresql postgresql-contrib pgcli

# Make sure the service is up and enabled at boot.
sudo systemctl enable --now postgresql

# Create a Postgres role + db matching the current Linux user, so `psql` "just works".
if ! sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='${USER}'" | grep -q 1; then
    sudo -u postgres createuser --superuser "$USER"
fi
if ! sudo -u postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='${USER}'" | grep -q 1; then
    sudo -u postgres createdb "$USER"
fi

echo "PostgreSQL running: $(sudo -u postgres psql -tAc 'SELECT version()')"
echo "Connect with: psql   (or: pgcli)"
