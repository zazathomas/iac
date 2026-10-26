.PHONY: fmt validate test policy check

POLICY_INPUT ?= /tmp/keycloak-plan.json

fmt:
	terraform fmt -check -recursive

validate:
	terraform init -backend=false -input=false
	terraform validate

test:
	python3 -m unittest discover -s tests/unit -p 'test_*.py'

policy:
	@test -f "$(POLICY_INPUT)" || (echo "POLICY_INPUT does not exist: $(POLICY_INPUT)" && exit 1)
	@command -v conftest >/dev/null || (echo "conftest is required for policy evaluation" && exit 1)
	conftest test "$(POLICY_INPUT)" --policy policies

check: fmt validate test
