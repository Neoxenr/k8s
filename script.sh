sh ./setup_ansible.sh

multipass start vbox1
multipass start vbox2
multipass start vbox3

ansible all -m ping

ansible-playbook playbooks/install_k8s.yaml
ansible-playbook playbooks/configure_cluster.yaml
ansible-playbook playbooks/install_plugins.yaml

ssh vbox1

sudo microk8s kubectl get nodes -o wide

sudo microk8s inspect

sudo microk8s kubectl get pods -A

ansible-playbook playbooks/setup_namespace.yaml
sudo microk8s kubectl get namespaces

ansible-playbook playbooks/setup_deployments.yaml
ansible-playbook playbooks/setup_dashboard.yaml
ansible-playbook playbooks/generate_dashboard_token.yaml


# INFO

sudo microk8s kubectl get ingress -n lab2
sudo microk8s kubectl describe ingress -n lab2
sudo microk8s kubectl get pods -n kube-system
sudo microk8s kubectl get pods -n lab2

sudo microk8s kubectl cluster-info
sudo microk8s kubectl get all -o wide -n lab2


sudo microk8s kubectl get deployments my-app -n lab2
sudo microk8s kubectl get pods -l app=hello-world -n lab2
sudo microk8s kubectl describe pod hello-world-59d46f88c4-9h9zh -n lab2



# Important
sudo microk8s kubectl get ingress -n lab2
sudo microk8s kubectl get all -o wide -n lab2
sudo microk8s kubectl get pods -n lab2 -o=wide
sudo microk8s kubectl get nodes


# Error
# Поды не принадлежат нодам
# Как достучаться снаружи?
sudo microk8s kubectl describe pod hello-world-59d46f88c4-s9vjb -n lab2


# reset
# cloud-init

sudo microk8s kubectrl describe service myapp-svc -n lab2
sudo microk8s kubectl patch svc backend -p '{"spec":{"externalIPs":["192.168.0.194"]}}'

sudo microk8s kubectl expose deployment hello-world -n lab2 --type=LoadBalancer --name=hello-world-test
sudo microk8s microk8s enable metallb # load balancer

# https://stackoverflow.com/questions/44110876/kubernetes-service-external-ip-pending
# Only the LoadBalancer gives value for the External-IP Colum. 
# and it only works if the Kubernetes cluster is able to assign an IP address for that particular service. 
# you can use metalLB load balancer for provision IPs to your load balancer services.


# https://stackoverflow.com/questions/57530575/how-to-expose-microk8s-containers-so-they-are-available-from-another-machine
# Unfortunately, as you are not using any cloud provider which support LoadBalancer (like AWS or GCP which provides External-IPs) you will be not able to expose service as LoadBalancer (service stuck on Pending state).


# Легенда
# https://stackoverflow.com/questions/53348677/kubernetes-cluster-is-not-exposing-external-ip-as-nodes