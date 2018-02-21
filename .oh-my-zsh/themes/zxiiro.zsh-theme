####################################################################################
#
#  The MIT License (MIT)
#
#  Copyright (c) 2013 Thanh Ha
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy of
#  this software and associated documentation files (the "Software"), to deal in
#  the Software without restriction, including without limitation the rights to
#  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
#  the Software, and to permit persons to whom the Software is furnished to do so,
#  subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in all
#  copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
#  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
#  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
#  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
#  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
####################################################################################

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[cyan]%}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}✱"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✗"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%}➦"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%}✂"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[grey]%}✈"

# Shows the git status when inside a valid git repo
function showgit() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    gitinfo="$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$( git_prompt_status )%{$fg[white]%B%}$ZSH_THEME_GIT_PROMPT_SUFFIX"
    text=" %{%B%}<$gitinfo>%{%b%}"
    echo $text
}

function showloc() {
    hostname=$(who am i | cut -f2 -d\( | cut -f1 -d\))
    echo $hostname
}

# Set a random colour if logged in via ssh
function setloccolour() {
    text="%{$reset_color%}"

    if [ -n "$SSH_CLIENT" ]
    then
        hostname=`hostname`
        if [ ! -f "$HOME/.zxiiro-theme/sshcolor-$hostname" ]
        then
            mkdir $HOME/.zxiiro-theme
            echo `shuf -i 133-163 -n 1` > "$HOME/.zxiiro-theme/sshcolor-$hostname"
        fi

        SSHCOLOR=`cat "$HOME/.zxiiro-theme/sshcolor-$hostname"`
        text="%{$FG[$SSHCOLOR]%}"
    fi
    echo $text
}

# Prompt line1: /--{[$job] $username @ $hostname : $terminal}----{$directory}--
# Prompt line2: | $time %|#
# Right Side Prompt: $date (YYYY-MM-DD)
# Note: spaces are there for clarity they aren't in the actual code
PROMPT=$'
%{$fg[red]%}/--{%{$reset_color%}[%!]%(!.%UROOT%u.%n)@%{$(setloccolour)%}%m%{$reset_color%}:%l%{$fg[red]%}}----{%{$reset_color%}%~%{$fg[red]%}}--
| %{$reset_color%}%T$(showgit)%{$fg[red]%} %#%{$reset_color%} '
PS2=$'%{$fg[red]%}| %{$fg[blue]%B%}>%{%b$reset_color%} '
RPS1='%D{%Y-%m-%d}'

