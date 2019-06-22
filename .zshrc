#shellcheck disable=SC2148
# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"
ZSH_THEME="zxiiro"
HIST_STAMPS="yyyy-mm-dd"
plugins=(battery git-prompt pip thefuck virtualenv)
echo "zsh theme: $ZSH_THEME"
echo "zsh plugins: ${plugins[*]}"
echo "zsh history datestamp: $HIST_STAMPS"
# shellcheck disable=SC1090
source "$ZSH/oh-my-zsh.sh"

# User configuration
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:/opt/bin:/usr/x86_64-pc-linux-gnu/gcc-bin/4.7.3:/usr/games/bin:$PATH"
export LANG=en_CA.UTF-8

##########
# Python #
##########

if [[ "$OSTYPE" == "darwin"* ]]; then
    if command -v pyenv 1>/dev/null 2>&1; then
        eval "$(pyenv init -)"
    fi
fi

# Maven
function mvn() {
    command mvn \
        --batch-mode \
        "$@"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        say 'Done'
    else
        spd-say 'Done'
    fi
}
MAVEN_OPTS="-Xmx8g -XX:+TieredCompilation -XX:TieredStopAtLevel=1"
echo "MAVEN_OPTS: $MAVEN_OPTS"

if [ -f "${HOME}/.gnupg/gpg-agent-wrapper" ]; then
    # shellcheck disable=SC1090,SC1091
    source "${HOME}/.gnupg/gpg-agent-wrapper"

    if [[ "$OSTYPE" == "darwin"* ]]; then
        export SSH_AUTH_SOCK="${HOME}/.gnupg/S.gpg-agent.ssh"
    else
        export SSH_AUTH_SOCK="/run/user/1000/gnupg/S.gpg-agent.ssh"
    fi
fi

if [ -f /usr/bin/virtualenvwrapper.sh ]; then
    export WORKON_HOME=~/.virtualenvs
    # shellcheck disable=SC1091
    source /usr/bin/virtualenvwrapper.sh
fi

if [ -f /usr/share/fzf/key-bindings.zsh ]; then
    # shellcheck disable=SC1091
    source /usr/share/fzf/key-bindings.zsh
fi

# XDG
export XDG_CONFIG_HOME="$HOME/.config"
