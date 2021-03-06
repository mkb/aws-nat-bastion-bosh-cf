.PHONY: all plan apply destroy provision ssh

all: plan apply provision

deploy: apply

centos-ami-ids:
	./bin/nbb centos-ami-ids

prepare:
	./bin/nbb prepare

plan:
	./bin/nbb vpc plan

apply:
	./bin/nbb vpc apply

destroy:
	./bin/nbb vpc destroy

clean:
	./bin/nbb vpc clean

provision:
	./bin/nbb provision all

provision-base:
	./bin/nbb provision base

provision-bosh:
	./bin/nbb provision bosh

provision-cf:
	./bin/nbb provision cf

provision-cf-cli:
	./bin/nbb provision cf_cli

ssh:
	./bin/nbb bastion ssh

test:
	./bin/nbb vpc test
