# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="zxiiro"
HIST_STAMPS="yyyy-mm-dd"
plugins=(battery git-prompt pip thefuck virtualenv)
source $ZSH/oh-my-zsh.sh

# User configuration
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:/opt/bin:/usr/x86_64-pc-linux-gnu/gcc-bin/4.7.3:/usr/games/bin:$PATH"
export LANG=en_CA.UTF-8

# ssh authentication component
source ${HOME}/.gnupg/gpg-agent-wrapper
export SSH_AUTH_SOCK=/run/user/1000/gnupg/S.gpg-agent.ssh

# Maven
function mvn() {
    /usr/bin/mvn \
        --batch-mode \
        "$@"
    spd-say 'Done'
}
MAVEN_OPTS="-Xmx8g -XX:+TieredCompilation -XX:TieredStopAtLevel=1"

# Python virtualenv
export WORKON_HOME=~/.virtualenvs
source /usr/bin/virtualenvwrapper.sh

[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh

# XDG
export XDG_CONFIG_HOME="$HOME/.config"

# pass
export PASSWORD_STORE_SIGNING_KEY="DE0E66E32F1FDD0902666B96E63EDCA9329DD07E FA4DB93EB9034BBFB8532A263360FFB703A9DA1F 34F95A028B74AEC9425FB7EA8BC411072810846A"

