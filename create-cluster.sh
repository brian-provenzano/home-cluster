# generate the cluster configuration files (IP of future control plane booted for USB)
talosctl gen config home-cluster https://10.0.4.201:6443

# apply the control plane config
# talosctl -n 10.0.4.201 disks --insecure # check disk for config
talosctl apply-config --insecure --nodes 10.0.4.201 --file controlplane.yaml

# check the node 
talosctl --talosconfig=./talosconfig --nodes 10.0.4.201 -e 10.0.4.201 version
talosctl --talosconfig=./talosconfig --nodes 10.0.4.201 -e 10.0.4.201 health
talosctl --talosconfig=./talosconfig --nodes 10.0.4.201 -e 10.0.4.201 -h

# bootstrap the control plane
talosctl bootstrap --nodes 10.0.4.201 --endpoints 10.0.4.201 --talosconfig=./talosconfig


# patch example on live node
talosctl --talosconfig=./talosconfig --nodes 10.0.4.201 -e 10.0.4.201 patch mc --patch-file patch-remove-cert-rotation-kubelet.yaml --dry-run


## tear down a node (reset, wipe disk, shutdown)
# worker
talosctl --talosconfig=../old/talosconfig --nodes 10.0.4.202 -e 10.0.4.201 reset

# control plane no-HA
talosctl --talosconfig=../old/talosconfig --nodes 10.0.4.201 -e 10.0.4.201 reset --graceful=false

#upgrade talos

# control plane - needs preserve=true bc single member etcd
talosctl upgrade --talosconfig=./talosconfig \
    --nodes 10.0.4.201 --preserve=true --image ghcr.io/siderolabs/installer:v1.7.6 -e 10.0.4.201

# each member - no preserve (202,203,204)
❯ talosctl upgrade --talosconfig=./talosconfig \
    --nodes 10.0.4.202 --image ghcr.io/siderolabs/installer:v1.7.6 -e 10.0.4.201

## upgrade kubernetes
