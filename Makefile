all: setup build apply

build:
	docker build . -t k8sscheduler:local

apply:
	kubectl apply -f ./k8s/pod.yaml

teardown:
	-kubectl delete -f ./k8s/pod.yaml
	-kubectl delete -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.4.2/components.yaml

setup:
	kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.4.2/components.yaml
	kubectl patch deployment metrics-server -n kube-system --type 'json' -p '[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]'

shell:
	kubectl exec --stdin --tty k8sscheduler -- /bin/bash

top:
	watch kubectl top pod