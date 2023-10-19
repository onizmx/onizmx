.SILENT:

clean:
	rm -rf \
	./build \
	./website/node_modules \
	./terraform/{bin,.terraform,terraform.tfstate.backup}

install:
	yarn --cwd ./website && \
	terraform -chdir=./terraform init

website:
	yarn --cwd ./website build

lambda:
	./script/package.sh

terraform:
	aws-vault exec onizmx-dev --no-session -- terraform -chdir=./terraform apply -auto-approve

all: clean install website lambda terraform

.PHONY: all clean install website lambda terraform
