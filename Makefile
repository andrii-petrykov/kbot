PLATFORMS = linux darwin windows
ARCHITECTURES = amd64 arm64

REGISTRY = andriipetr
APP = $(shell basename $(shell git remote get-url origin))
VERSION = $(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

linux:
	$(MAKE) build TARGETOS=linux TARGETARCH=arm64

windows:
	$(MAKE) build TARGETOS=windows TARGETARCH=amd64

macos:
	$(MAKE) build TARGETOS=darwin TARGETARCH=amd64

build:
	CGO_ENABLED=0 GOOS=$(TARGETOS) GOARCH=$(TARGETARCH) go build -v -o $(APP) -ldflags "-X=github.com/andrii.petrykov/kbot/cmd.appVersion=$(VERSION)"

image:
	docker build . -t $(REGISTRY)/$(APP):$(VERSION)-$(TARGETOS)-$(TARGETARCH) --build-arg TARGETOS=$(TARGETOS) --build-arg TARGETARCH=$(TARGETARCH)

push:
	docker push $(REGISTRY)/$(APP):$(VERSION)-$(TARGETOS)-$(TARGETARCH)

clean:
	rm -rf $(APP)
	docker rmi $(REGISTRY)/$(APP):$(VERSION)-$(TARGETOS)-$(TARGETARCH)
