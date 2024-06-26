helm template cilium . -f values.yaml --namespace=kube-system  > cilium-install.yaml

# tell helm template gwapi is available so cilium will create the gatewayclass
helm template cilium . -f values.yaml --namespace=kube-system  --api-versions='gateway.networking.k8s.io/v1/GatewayClass' > cilium-install-gwapi.yaml

