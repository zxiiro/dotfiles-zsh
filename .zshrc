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

# Install ZSH on remote ssh system
function zshri() {
    if [ -z "$1" ]; then
        echo "Usage: zshri SSH_HOST"
        exit 1
    fi
    # We want to wordsplit here on purpose
    # shellcheck disable=2068
    ssh -t -t $@ /bin/bash << SSHEOF
cat << EOF > \$HOME/zshri.sh
#!/bin/bash
set -x
if ! hash zsh; then
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

    rm -rf "\$workdir"

    echo '[ -f \$HOME/.local/bin/zsh ] && exec \$HOME/.local/bin/zsh -l' > \$HOME/.bashrc
fi

git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
wget -nv -O ~/.zshrc https://raw.githubusercontent.com/zxiiro/dotfiles-zsh/master/.zshrc
wget -nv -O ~/.oh-my-zsh/themes/zxiiro.zsh-theme https://raw.githubusercontent.com/zxiiro/dotfiles-zsh/master/.oh-my-zsh/themes/zxiiro.zsh-theme
EOF

chmod +x \$HOME/zshri.sh
\$HOME/zshri.sh
rm \$HOME/zshri.sh
exit
SSHEOF
}

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
