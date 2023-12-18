CONTAINER_IMAGE := gcr.io/$(PROJECT_ID)/service-1
VER := $(VER)
SERVICE := $(if $(SERVICE),$(SERVICE),service-1)

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

.PHONY: deploy-no-traffic
deploy-no-traffic:
	gcloud run deploy $(SERVICE) --image=$(CONTAINER_IMAGE) --region=us-central1 \
	--allow-unauthenticated \
	--cpu=2 --memory=1Gi \
	--set-env-vars=VERSION=$(VER) \
	--no-traffic

.PHONY: image
image:
	gcloud services enable containerregistry.googleapis.com
	docker build -t $(CONTAINER_IMAGE) --platform=linux/amd64 .
	docker push $(CONTAINER_IMAGE)

.PHONY: remove-tag
remove-tag:
	gcloud run services update-traffic $(SERVICE) --region=us-central1 --remove-tags=$(VER)

.PHONY: update-traffic-latest
update-traffic-latest:
	gcloud run services update-traffic $(SERVICE) --region=us-central1 --to-latest

.PHONY: update-traffic-tag
update-traffic-tag:
	gcloud run services update-traffic $(SERVICE) --region=us-central1 \
	--to-tags=$(VER)=100
