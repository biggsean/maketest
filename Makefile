SHELL = bash
ANSIBLE_VERSION?=2.5.0
TEST_VENV=~/.venv-ansible-$(ANSIBLE_VERSION)
ACTIVATE=source ~/.venv-ansible-$(ANSIBLE_VERSION)/bin/activate

.PHONY: version
version: create_venv
	$(ACTIVATE) && ansible --version

.PHONY: test
test: version create_venv
	echo DONE

.PHONY: create_venv
create_venv: install_virtualenv
	virtualenv $(TEST_VENV) --no-site-packages
	$(ACTIVATE) && pip install ansible==$(ANSIBLE_VERSION)

.PHONY: install_virtualenv
install_virtualenv: install_pip
	sudo -H pip install virtualenv

.PHONY: install_pip
install_pip: update_repos
	sudo apt-get -y install python-pip

.PHONY: update_repos
update_repos:
	sudo apt-get update

