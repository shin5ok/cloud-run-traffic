CONTAINER_IMAGE := gcr.io/$(PROJECT_ID)/standard
VER := $(VER)
SERVICE := service-1

.PHONY: tag-deploy
tag-deploy:
	gcloud run deploy $(SERVICE) --image=$(CONTAINER_IMAGE) --region=us-central1 \
	--allow-unauthenticated \
 	--tag=$(VER) \
	--cpu=2 --memory=1Gi \
	--set-env-vars=VERSION=$(VER) \
	--no-traffic

.PHONY: deploy
deploy:
	gcloud run deploy $(SERVICE) --image=$(CONTAINER_IMAGE) --region=us-central1 \
	--allow-unauthenticated \
	--cpu=2 --memory=1Gi \
	--set-env-vars=VERSION=standard

.PHONY: image
image:
	docker build -t $(CONTAINER_IMAGE) --platform=linux/amd64 .
	docker push $(CONTAINER_IMAGE)

.PHONY: update-traffic
update-traffic:
	gcloud run services update-traffic $(SERVICE) --region=us-central1 \
	--to-tags=$(VER)=100
