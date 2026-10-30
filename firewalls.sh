#!/bin/bash
ip_address_c1=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' c1)
ip_address_c2=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' c2)
ip_address_c3=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' c3)

echo "c1: $ip_address_c1"
echo "c2: $ip_address_c2"
echo "c3: $ip_address_c3"

sudo iptables -N DOCKER-TASK-POLICY 2>/dev/null || true
sudo iptables -F DOCKER-TASK-POLICY

sudo iptables -A DOCKER-TASK-POLICY -s "$ip_address_c1" -d "$ip_address_c2" -j ACCEPT
sudo iptables -A DOCKER-TASK-POLICY -s "$ip_address_c2" -d "$ip_address_c3" -j ACCEPT
sudo iptables -A DOCKER-TASK-POLICY -s "$ip_address_c3" -d "$ip_address_c1" -j ACCEPT

sudo iptables -A DOCKER-TASK-POLICY -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

sudo iptables -A DOCKER-TASK-POLICY -j DROP

sudo iptables -D DOCKER-USER -j DOCKER-TASK-POLICY 2>/dev/null || true
sudo iptables -I DOCKER-USER 1 -j DOCKER-TASK-POLICY

echo "DOne"