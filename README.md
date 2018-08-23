## Add as a systemd service

Add a file into `/lib/systemd/system/human-detector.service` with the following. And change the `WorkingDirectory` to the directory where the source code is located.

```bash
[Unit]
Description=Python - Human detection using Tensorflow
Documentation=https://example.com
After=syslog.target network.target

[Service]
Type=simple
User=pi
WorkingDirectory=/home/pi/repo/human-detector
ExecStart=/home/pi/venvs/tensorflow/bin/python /home/pi/repo/human-detector/app.py --serve-in-foreground
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

Run the following command to enable the service:

```bash
sudo systemctl daemon-reload
sudo systemctl start human-detector
sudo systemctl status human-detector
```

Use `journalctl` to check logs:

```bash
journalctl -u human-detector -f
```

## Know Issues

The docker image built based on the Dokcerfile prvoided as too large. 

```bash
$ docker images
REPOSITORY                  TAG                 IMAGE ID            CREATED             SIZE
tfcv                        latest              d31c6a846d9b        16 hours ago        5.59GB
```# human-detector
