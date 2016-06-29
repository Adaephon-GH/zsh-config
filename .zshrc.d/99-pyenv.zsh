# Set up pyenv (https://github.com/yyuu/pyenv)
PYENV_ROOT="${HOME}/local/opt/pyenv"
if [[ -d ${PYENV_ROOT} && ! -e /tmp/nopyenv ]]; then
    export PYENV_ROOT
    export PATH="${PYENV_ROOT}/bin:${PATH}"
    eval "$(pyenv init -)"
else
    unset PYENV_ROOT
fi
