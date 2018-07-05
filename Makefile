SHELL:=bash

ANSIBLE_VERSION?=2.5.0
TEST_VENV:=~/.venv-ansible-$(ANSIBLE_VERSION)
ACTIVATE:=source $(TEST_VENV)/bin/activate
ANSIBLE_VERBOSITY:="-vv"
ANSIBLE_PLAYBOOK:=$(ACTIVATE) && ansible-playbook $(ANSIBLE_VERBOSITY)

override ANSIBLE_LINT_VERSION:=3.4.23
ANSIBLE_LINT_VERBOSITY:="-vv"
ANSIBLE_LINT:=$(ACTIVATE) && ansible-lint $(ANSIBLE_LINT_VERBOSITY)

PIP:=$(ACTIVATE) && pip

SCENARIO?=default
SCENARIOS_DIR:=./tests/scenarios
STAGES:=syntax lint play idempotence
PLAY:=$(SCENARIOS_DIR)/$(SCENARIO)/play.yml
RUN_PLAY:=$(ANSIBLE_PLAYBOOK) $(PLAY)

.PHONY: test $(STAGES)
test: test-$(SCENARIO)
syntax: syntax-$(SCENARIO)
lint: lint-$(SCENARIO)
play: play-$(SCENARIO)
idempotence: idempotence-$(SCENARIO)
test-%: $(STAGES)
	@echo $@ Completed $?
syntax-%: install-ansible
	@echo $@
	$(RUN_PLAY) --syntax-check
lint-%: install-ansible-lint
	@echo $@
	$(ANSIBLE_LINT) $(PLAY)
play-%: install-ansible
	@echo $@
	$(RUN_PLAY)
idempotence-%: play-%
	@echo $@
	$(RUN_PLAY) | tee /dev/tty |exit $$(grep -Ec '(changed|failed)=[^0]' -)

.PHONY: install-ansible
install-ansible: create-venv ansible.cfg
	$(PIP) install ansible==$(ANSIBLE_VERSION)

.PHONY: install-ansible-lint
install-ansible-lint: create-venv install-ansible
	$(PIP) install ansible-lint==$(ANSIBLE_LINT_VERSION)

.PHONY: create-venv
create-venv:
	virtualenv $(TEST_VENV) --no-site-packages

define ANSIBLECFG
[defaults]
roles_path = ..
endef
export ANSIBLECFG
.PHONY: ansible.cfg
ansible.cfg:
	echo "$$ANSIBLECFG" > $@

.PHONY: clean
clean:
	rm ansible.cfg
	rm -rf ~/.venv-ansible-*
