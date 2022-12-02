.PHONY: all clean test

# Private variables ====================================================================================================

_DOCKER_FILELINT_IMAGE=cytopia/file-lint:0.4
_DOCKER_MAKEFILELINT_IMAGE=cytopia/checkmake:0.1.0
_DOCKER_MARKDOWNLINT_IMAGE=markdownlint/markdownlint:0.11.0
_DOCKER_YAMLLINT_IMAGE=cytopia/yamllint:1.26
_PROJECT_DIRECTORY=$(dir $(realpath $(firstword $(MAKEFILE_LIST))))
_WORK_DIR=/srv

# Helper functions =====================================================================================================

# $1: image
# $2: command
define run-docker-alpine
	@docker run -it --rm \
	--entrypoint="" \
	-v ${_PROJECT_DIRECTORY}:${_WORK_DIR} \
	-w ${_WORK_DIR} \
	$1 \
	/bin/sh -c "apk update && apk add make && $2"
endef

# $1: image
# $2: command
define run-docker-bare
	@docker run -it --rm \
	--entrypoint="" \
	-v ${_PROJECT_DIRECTORY}:${_WORK_DIR} \
	-w ${_WORK_DIR} \
	$1 \
	/bin/sh -c "$2"
endef

# $1: type
# $2: name
# $3: command
define find-exec
	@find . \
	-type $1 \
	-not -path "**/data/**" \
	-not -path "**/node_modules/**" \
	-not -path ".git" \
	-not -path ".github" \
	-not -path ".vscode" \
	-not -path ".idea" \
	-name $2 \
	-print0 | \
	xargs -I {} -0 sh -c $3
endef


# QA ===================================================================================================================

.PHONY: file-lint file-lint-docker
.PHONY: makefile-lint makefile-lint-docker
.PHONY: markdown-lint markdown-lint-docker
.PHONY: yaml-lint yaml-lint-docker

file-lint:
	@file-cr \
	--text \
	--ignore '.git/,.github/,.vscode/,.idea/,**/.terraform,**/data/,**/node_modules,themes/slimer/assets/' \
	--path . && \
	file-crlf \
	--text \
	--ignore '.git/,.github/,.vscode/,.idea/,**/.terraform,**/data/,**/node_modules,themes/slimer/assets/' \
	--path . && \
	file-trailing-single-newline \
	--text \
	--ignore '.git/,.github/,.vscode/,.idea/,**/.terraform,**/data/,**/node_modules,themes/slimer/assets/' \
	--path . && \
	file-trailing-space \
	--text \
	--ignore '.git/,.github/,.vscode/,.idea/,**/.terraform,**/data/,**/node_modules,themes/slimer/assets/' \
	--path . && \
	file-utf8 \
	--text \
	--ignore '.git/,.github/,.vscode/,.idea/,**/.terraform,**/data/,**/node_modules,themes/slimer/assets/' \
	--path . && \
	file-utf8-bom \
	--text \
	--ignore '.git/,.github/,.vscode/,.idea/,**/.terraform,**/data/,**/node_modules,themes/slimer/assets/' \
	--path .

file-lint-docker:
	$(call run-docker-alpine,${_DOCKER_FILELINT_IMAGE},make file-lint)

makefile-lint:
	$(call find-exec,"f","Makefile","checkmake {}")

makefile-lint-docker:
	$(call run-docker-alpine,${_DOCKER_MAKEFILELINT_IMAGE},make makefile-lint)

markdown-lint:
	$(call find-exec,"f","*.md","mdl -c .rules/.mdlrc {}")

markdown-lint-docker:
	$(call run-docker-bare,${_DOCKER_MARKDOWNLINT_IMAGE},make markdown-lint)

yaml-lint:
	yamllint -c .rules/yamllint.yaml .

yaml-lint-docker:
	$(call run-docker-alpine,${_DOCKER_YAMLLINT_IMAGE},make yaml-lint)

# ======================================================================================================================
