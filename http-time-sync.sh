SERVER_TIME=$(curl -sI http://10.10.11.212 | grep -i '^Date:' | sed 's/^Date: //i' | tr -d '\r' | xargs -I {} date -d "{}" "+%Y-%m-%d %H:%M:%S")
echo "Server time: $SERVER_TIME"
sudo timedatectl set-ntp false 2>/dev/null
sudo date -s "$SERVER_TIME"
echo "Updated to: $(date)"
