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

FG_COLOUR="yellow"
PROMPT_PREFIX="[%f"
PROMPT_SUFFIX="%F{$FG_COLOUR}]"
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[white]%}"
ZSH_THEME_GIT_PROMPT_PREFIX="${PROMPT_PREFIX}🌀"
ZSH_THEME_GIT_PROMPT_SUFFIX="${PROMPT_SUFFIX}━"
ZSH_THEME_VIRTUALENV_PREFIX="${PROMPT_PREFIX}🐍"
ZSH_THEME_VIRTUALENV_SUFFIX="${PROMPT_SUFFIX}━"

function precmd {
    local TERMWIDTH="${COLUMNS}"

    PR_FILLBAR=""
    PR_PWDLEN=""

    local promptsize=${#${(%):--[]---[]---[]---[]---}}

    local batsize="$(battery_pct_remaining)"
    if [ ! -z "$batsize" ]; then
        ((promptsize += 5 + ${#batsize} + 3))
    fi

    local pwdsize=${#${(%):-%~}}
    local hostsize=${#${(%):-%(!.%UROOT%u.%n)@%m:}}
    local ramsize="$(raminfo)"
    ((ramsize = ${#ramsize} + 3))
    local termsize=${#${(%):-%l}}
    local timesize=${#${(%%):-%D{%Y-%m-%d} %T}}  # %Y-%m-%d %T

    if [[ "$promptsize + $pwdsize + $hostsize + $ramsize + $termsize + $timesize" -gt $TERMWIDTH ]]; then
        ((PR_PWDLEN = TERMWIDTH - promptsize))
    else
        PR_FILLBAR="\${(l.(($TERMWIDTH - ($promptsize + $pwdsize + $hostsize + $ramsize + $termsize + $timesize)))..━.)}"
    fi
}

function raminfo() {
    raminfo="$(free | grep Mem | awk '{print $3/$2 * 100}' | awk -F'.' '{print $1}')"
    echo "$raminfo"
}

function showloc() {
    hostname=$(who am i | cut -f2 -d\( | cut -f1 -d\))
    echo "$hostname"
}

# Set a random colour if logged in via ssh
function setloccolour() {
    text="%{$reset_color%}"

    if [ -n "$SSH_CLIENT" ]
    then
        hostname=$(hostname)
        if [ ! -f "$HOME/.zxiiro-theme/sshcolor-$hostname" ]
        then
            mkdir "$HOME/.zxiiro-theme"
            shuf -i 133-163 -n 1 > "$HOME/.zxiiro-theme/sshcolor-$hostname"
        fi

        SSHCOLOR=$(cat "$HOME/.zxiiro-theme/sshcolor-$hostname")
        text="%{$FG[$SSHCOLOR]%}"
    fi
    echo "$text"
}

function setup_prompt() {
    local prompt

    echo ""

    prompt+="%F{$FG_COLOUR}┏"
    prompt+="${PROMPT_PREFIX}%D{%Y-%m-%d} %T${PROMPT_SUFFIX}━━━"
    prompt+="${PROMPT_PREFIX}%(!.%UROOT%u.%n)@%{$(setloccolour)%}%m%f:%~${PROMPT_SUFFIX}━━━"
    prompt+="${(e)PR_FILLBAR}"
    prompt+="${PROMPT_PREFIX}🐏$(raminfo)%%${PROMPT_SUFFIX}━━━"

    local batinfo="$(battery_pct_remaining)"
    if [ ! -z "$batinfo" ]; then
        prompt+="${PROMPT_PREFIX}🔋$(battery_pct_remaining)%%${PROMPT_SUFFIX}━━━"
    fi

    prompt+="${PROMPT_PREFIX}%l${PROMPT_SUFFIX}━━━"
    echo "$prompt"

    local prompt2
    prompt2+="%F{$FG_COLOUR}┗"
    prompt2+="$(virtualenv_prompt_info)"
    prompt2+="$(git_super_status)"
    prompt2+="${PROMPT_PREFIX}%f%?%F{$FG_COLOUR}${PROMPT_SUFFIX}━"
    prompt2+="%f%(!.#.$) "
    echo "$prompt2"
}

PROMPT=$'$(setup_prompt)'
PS2=$'%F{$FG_COLOUR}| %F{blue}%B>%b%f '
RPROMPT=""
