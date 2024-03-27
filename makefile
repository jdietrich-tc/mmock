.PHONY: build doc fmt lint dev test vet bindata

PKG_NAME =mmock-tc
NS = artifacts.cnco.tucows.systems/mse-mint-docker
VERSION ?= latest

export GO111MODULE=on
export GOARCH=amd64
export GOOS=linux


build: bindata \
	vet \
	test
	go build  -v -o ./bin/$(PKG_NAME) cmd/mmock/main.go

bindata:
	go-bindata -pkg console -o internal/console/bindata.go tmpl/*

doc:
	godoc -http=:6060

fmt:
	go fmt ./...

# https://github.com/golang/lint
# go get github.com/golang/lint/golint
lint:
	golint ./...

test:
	go test -v ./...
	
coverage:
	./coverage.sh

# https://godoc.org/golang.org/x/tools/cmd/vet
vet:
	go vet -v  ./...

release:
	goreleaser --clean

docker-push:
	docker build --no-cache=true  -t $(NS)/$(PKG_NAME):$(VERSION) .
	docker push $(NS)/$(PKG_NAME):$(VERSION)
