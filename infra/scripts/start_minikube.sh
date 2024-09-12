# /bin/bash

minikube start \
--nodes=3 \
--memory=no-limit \
--addons=dashboard storage-provisioner metrics-server \
--cpus=no-limit \
--listen-address=0.0.0.0
&& minikube tunnel
