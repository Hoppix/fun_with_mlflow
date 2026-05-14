
.PHONY: cluster-up cluster-down cluster-reset cluster-status

cluster-up:
	./scripts/cluster.sh up

cluster-down:
	./scripts/cluster.sh down

cluster-reset: 
	./scripts/cluster.sh reset

cluster-status:
	./scripts/cluster.sh status