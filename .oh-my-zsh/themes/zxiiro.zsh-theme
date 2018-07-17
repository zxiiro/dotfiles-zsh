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

# Prompt line1: ╔══[ $date $time ]═══[ $username @ $hostname : $terminal] $directory
# Prompt line2: ╚═[ $exit_code ] $|#
# Note: spaces are there for clarity they aren't in the actual code
PROMPT=$'
%{$fg[$FG_COLOUR]%}╔══[%{$reset_color%}%D{%Y-%m-%d} %T%{$fg[$FG_COLOUR]%}]═══[%{$reset_color%}%l%{$fg[$FG_COLOUR]%}]═══[%{$reset_color%}%(!.%UROOT%u.%n)@%{$(setloccolour)%}%m%{$reset_color%}:%~%{$fg[$FG_COLOUR]%}]
╚═[%{$reset_color%}$(battery_pct_prompt)%{$fg[$FG_COLOUR]%}]═[%{$reset_color%}%?%{$fg[$FG_COLOUR]%}]%{$reset_color%}$(git_super_status)%{$reset_color%} %(!.#.$) '
PS2=$'%{$fg[$FG_COLOUR]%}| %{$fg[blue]%B%}>%{%b$reset_color%} '
RPROMPT=""
