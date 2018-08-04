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

# Maven
function mvn() {
    /usr/bin/mvn \
        --batch-mode \
        "$@"
    spd-say 'Done'
}
MAVEN_OPTS="-Xmx8g -XX:+TieredCompilation -XX:TieredStopAtLevel=1"
echo "MAVEN_OPTS: $MAVEN_OPTS"

# Install ZSH on remote ssh system
function zshri() {
    if [ -z "$1" ]; then
        echo "Usage: zshri SSH_HOST"
        exit 1
    fi
    # We want to wordsplit here on purpose
    # shellcheck disable=2068
    ssh -t -t $@ /bin/bash << EOF
set -x
workdir=\$(mktemp -d --tmpdir="\$HOME" zshsrc-XXXX)

# Compile ZSH
git clone git://github.com/zsh-users/zsh.git "\$workdir"
cd "\$workdir" || exit 1
autoheader
autoconf
date > stamp-h.in
./configure --prefix="\$HOME/.local" --enable-shared
make -j2
make install

echo '[ -f \$HOME/.local/bin/zsh ] && exec \$HOME/.local/bin/zsh -l' > \$HOME/.bashrc

git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
wget -O ~/.zshrc https://raw.githubusercontent.com/zxiiro/dotfiles-zsh/master/.zshrc
wget -O ~/.oh-my-zsh/themes/zxiiro.zsh-theme https://raw.githubusercontent.com/zxiiro/dotfiles-zsh/master/.oh-my-zsh/themes/zxiiro.zsh-theme

rm -rf "\$workdir"
exit
EOF
}

if [ -f "${HOME}/.gnupg/gpg-agent-wrapper" ]; then
    # shellcheck disable=SC1090,SC1091
    source "${HOME}/.gnupg/gpg-agent-wrapper"
    export SSH_AUTH_SOCK=/run/user/1000/gnupg/S.gpg-agent.ssh
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

# pass
export PASSWORD_STORE_SIGNING_KEY="DE0E66E32F1FDD0902666B96E63EDCA9329DD07E FA4DB93EB9034BBFB8532A263360FFB703A9DA1F 34F95A028B74AEC9425FB7EA8BC411072810846A"
