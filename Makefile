
.PHONY: cluster-up cluster-down cluster-reset cluster-status miniio-deploy miniio-delete miniio-status

cluster-up:
	./scripts/cluster.sh up

cluster-down:
	./scripts/cluster.sh down

cluster-reset: 
	./scripts/cluster.sh reset

cluster-status:
	./scripts/cluster.sh status

miniio-deploy:
	./scripts/miniio.sh deploy

miniio-delete:
	./scripts/miniio.sh delete

miniio-status:
	./scripts/miniio.sh status