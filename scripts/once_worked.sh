#!/bin/bash

USER="cwadmin"
PASS="Network@1234"
ENABLE_PASS="Network@1234"
COMMANDS_FILE="sw-rt.txt"
IP_LIST_FILE="ip_list.txt"
LOG_DIR="logs"
TMP_DIR="tmp_expect"

mkdir -p "$LOG_DIR" "$TMP_DIR"

while read -r IP; do
  OUTFILE="$LOG_DIR/${IP}_$(date +%Y%m%d_%H%M%S).log"
  TMP_EXPECT="$TMP_DIR/expect_$IP.exp"

  echo "===== Running on $IP ====="
  echo "Starting session on $IP at $(date)" > "$OUTFILE"

  # Create the expect script
  cat > "$TMP_EXPECT" << EOF
#!/usr/bin/expect -f
log_user 1
set timeout 20

spawn ssh -o StrictHostKeyChecking=no $USER@$IP

expect {
  "yes/no" { send "yes\r"; exp_continue }
  "Password:" { send "$PASS\r" }
}

expect {
  ">" {
    send "enable\r"
    expect "Password:"
    send "$ENABLE_PASS\r"
    expect "#"
  }
  "#" {
    send "\r"
    expect "#"
  }
}

send "terminal length 0\r"
expect "#"

EOF

  while read -r CMD; do
    echo "send \"$CMD\r\"" >> "$TMP_EXPECT"
    echo "expect \"#\"" >> "$TMP_EXPECT"
  done < "$COMMANDS_FILE"

  cat >> "$TMP_EXPECT" << 'EOF'
send "exit\r"
expect eof
EOF

  chmod +x "$TMP_EXPECT"
  ./"$TMP_EXPECT" >> "$OUTFILE" 2>&1

  echo "Finished logging $IP to $OUTFILE"
  echo ""

  # Clean up
  rm -f "$TMP_EXPECT"

done < "$IP_LIST_FILE"
