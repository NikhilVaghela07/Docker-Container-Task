### Run this command in termial first
```
sudo modprobe br_netfilter
sudo sysctl -w net.bridge.bridge-nf-call-iptables=1
sysctl net.bridge.bridge-nf-call-iptables
```