Terraform-with-GCP
=================

Requirement:
------------ 

terrform version : v0.12.23

How to use
----------
```
terraform init
terraform plan
terraform apply
```

Destroy:
--------
```
terraform destroy
```
Configure Simple webapp in Go
-----------------------------
```
sudo mkdir -p /projects/webapp
sudo -i
cat > /projects/webapp/main.go <<EOF
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
```
Create systemd service file for goapp
-------------------------------------

```
cat > /etc/systemd/system/webapp.service <<EOF

[Unit]
Description=Start the webapp

[Service]
Restart=on-failure
WorkingDirectory=/projects/webapp
ExecStart=/usr/bin/go run main.go

[Install]
WantedBy=multi-user.target
EOF
```
Start the service
-----------------
```
systemctl start webapp.service
root@terraform-instance-e90b4b8f617a6aee:~# systemctl status webapp.service
● webapp.service - Start the webapp
   Loaded: loaded (/etc/systemd/system/webapp.service; enabled; vendor preset: enabled)
   Active: active (running) since Tue 2020-05-05 17:16:12 UTC; 5s ago
 Main PID: 7213 (go)
    Tasks: 8 (limit: 4915)
   CGroup: /system.slice/webapp.service
           ├─7213 /usr/bin/go run main.go
           └─7232 /tmp/go-build177918037/command-line-arguments/_obj/exe/main

May 05 17:16:12 terraform-instance-e90b4b8f617a6aee systemd[1]: Started Start the webapp.
root@terraform-instance-e90b4b8f617a6aee:~#
```
Test the application
```
curl http://<IP of your VM>
Hello from Google Cloud !!!
```