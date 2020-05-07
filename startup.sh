#!/bin/bash
# Install golang and create project directory
sudo bash -c 'apt-get update && \
    apt-get install -yq golang && \
    mkdir -p /projects/webapp'

# Create go app file with content and create webapp systemd service file
sudo bash -c 'cat > /projects/webapp/main.go <<EOF
package main

import (
    "fmt"
    "log"
    "net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Hello from Google Cloud !!!")
}

func main() {
    http.HandleFunc("/", handler)
    log.Fatal(http.ListenAndServe(":80", nil))
}
EOF

cat > /etc/systemd/system/webapp.service <<EOF
[Unit]
Description=Start the webapp

[Service]
Restart=on-failure
WorkingDirectory=/projects/webapp
ExecStart=/usr/bin/go run main.go

[Install]
WantedBy=multi-user.target
EOF'

sudo bash -c 'chmod +x /projects/webapp/main.go && \
    systemctl start webapp.service && \
    systemctl enable webapp.service'