# Set up shell functionality for pyenv 
# (https://github.com/pyenv/pyenv)
if [[ -n ${PYENV_ROOT} ]]; then
    eval "$(${PYENV_ROOT}/bin/pyenv init -)"
fi
