#!/usr/bin/env zsh

export PY_VENV_DIR=".venv"

function _chpwd_py_venv() {
    local venv_path="$(_get_py_venv_path "${PWD}")"

    if [ -d "${venv_path}" ]; then
        if [ "${VIRTUAL_ENV}" != "${venv_path}" ]; then
            if [ "${VIRTUAL_ENV}" != "" ]; then
                _deactivate_venv
            fi
            echo "Python venv activated: ${venv_path}"
            source "${venv_path}/bin/activate"
        fi
    else
        _deactivate_venv
    fi
}

function _get_py_venv_path() {
    local check_dir="${1}"

    if [[ -d "${check_dir}/${PY_VENV_DIR}" ]]; then
        printf "${check_dir}/${PY_VENV_DIR}"
        return
    else
        if [[ "${check_dir}" = "/" || "${check_dir}" = "${HOME}" ]]; then
            return
        fi
        _get_py_venv_path "$(dirname "${check_dir}")"
    fi
}

function _activate_venv() {
    local target_path="$1"

    source "${target_path}/${PY_VENV_DIR}/bin/activate"
}

function _deactivate_venv() {
    if type "deactivate" >/dev/null 2>&1; then
        echo "Python venv deactivated: ${VIRTUAL_ENV}"
        deactivate
    fi
}

function mkpyvenv() {
    local target_path="$(pwd)"

    python -m venv "${PY_VENV_DIR}"
    _activate_venv "${target_path}"
}

function rmpyvenv() {
    local TMP_VIRTUAL_ENV="${VIRTUAL_ENV}"
    _deactivate_venv
    rm -rf "${TMP_VIRTUAL_ENV}"
}

add-zsh-hook chpwd _chpwd_py_venv
