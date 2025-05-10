#!/bin/bash

set -e
set -o pipefail

# Ensure Docker is running
if ! command -v docker &> /dev/null; then
    echo "❌ Docker not installed or not in PATH. Run system-prep.sh first."
    exit 1
fi

# Set timezone in .env
if [ -f "src/.env" ]; then
    timezone=$(cat /etc/timezone)
    sed -i "s|^TZ=.*$|TZ=$timezone|" src/.env
else
    echo "src/.env not found. Aborting."
    exit 1
fi

if ! command -v mysql &> /dev/null; then
    echo "[*] MySQL client not found. Installing mariadb-client..."
    sudo apt-get update
    sudo apt install -y mariadb-client
else
    echo "✔️  MySQL client is already installed."
fi

# Clone AzerothCore if not already
if [ -d "azerothcore-wotlk" ]; then
    echo "✔️ azerothcore-wotlk already exists. Cleaning SQL..."
    destination_dir="data/sql/custom"
    rm -rf "$destination_dir/db_world/"*.sql
    rm -rf "$destination_dir/db_characters/"*.sql
    rm -rf "$destination_dir/db_auth/"*.sql
else
    echo "[*] Cloning AzerothCore..."
    git clone https://github.com/liyunfan1223/azerothcore-wotlk.git --branch=Playerbot
	echo "[*] Copying environment files..."
	cp src/.env azerothcore-wotlk/
	cp src/*.yml azerothcore-wotlk/
	
	# Install modules
	cd azerothcore-wotlk/modules
	git clone https://github.com/liyunfan1223/mod-playerbots.git --branch=master
	git clone https://github.com/noisiver/mod-learnspells.git
	git clone https://github.com/azerothcore/mod-autobalance.git
	git clone https://github.com/azerothcore/mod-solo-lfg.git
	git clone https://github.com/azerothcore/mod-individual-xp.git
	cd ..
fi

# Build and start containers
docker compose up -d --build
cd ..

# Fix ownership (if needed)
sudo chown -R 1000:1000 wotlk

# Execute SQL
custom_sql_dir="src/sql"
auth="acore_auth"
world="acore_world"
chars="acore_characters"
ip_address=$(hostname -I | awk '{print $1}')

function execute_sql() {
    local db_name=$1
    local dir="$custom_sql_dir/$db_name"

    if [ -d "$dir" ] && compgen -G "$dir/*.sql" > /dev/null; then
        for sql_file in "$dir"/*.sql; do
            echo "Executing $sql_file"
            temp_sql_file=$(mktemp)
            if [[ "$(basename "$sql_file")" == "update_realmlist.sql" ]]; then
                sed "s/{{IP_ADDRESS}}/$ip_address/g" "$sql_file" > "$temp_sql_file"
            else
                cp "$sql_file" "$temp_sql_file"
            fi
            mysql -h "$ip_address" -uroot -proot "$db_name" < "$temp_sql_file"
            rm "$temp_sql_file"
        done
    else
        echo "No SQL files found in $dir, skipping..."
    fi
}

echo "[*] Running SQL imports..."
execute_sql "$auth"
execute_sql "$world"
execute_sql "$chars"

echo ""
echo "✅ AzerothCore project setup complete!"
echo "👉 `docker attach ac-worldserver` Use the worldserver console to create accounts and set GM level as needed."
