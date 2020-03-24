[[ ! -o rcs ]] && return

# automatically remove duplicates from these arrays
typeset -gU path cdpath fpath manpath fignore

autoload -U zargs           # smart xargs replacement
autoload -U zmv             # programmable moving, copying, and linking
autoload -U colors ; colors # make color arrays available
autoload -U zrecompile      # allow zwc file recompiling
autoload -U allopt          # add command allopt to show all opts
autoload -Uz add-zsh-hook

setopt extended_glob     # in order to use #, ~ and ^ for filename generation
zrecompile ~/.zprofile ~/.zshenv ~/.zlogin ~/.zlogout ~/.zshrc ~/.env/zsh-completions/src/*~*.(zwc|old) | while read pre file post; do
    case "$post" in
      succeeded) rm -f "${file%:}".old;;
      *) :;;
    esac
  done


zcompileall(){
    for file in ~/.zprofile ~/.zshenv ~/.zlogin ~/.zlogout ~/.zshrc ~/.env/zsh-completions/src/*~*.(zwc|old) ; do
        rm -f $file.zwc
        rm -f $file.zwc.old
        zcompile $file
    done
}


colormode() {
    local mode="${1:=eighties}"
    source ~/.env/base16-shell/scripts/base16-${mode}.sh
    echo "colorscheme base16-${mode}" >| ~/.vimrc_background
    echo "${mode}" >| ~/.colormode
}
alias lightmode="colormode classic-light"
alias darkmode="colormode eighties"

_last_colormode="$(cat ~/.colormode 2>/dev/null)"
colormode "$_last_colormode"


source ~/.env/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=58"

__venvwrapper=$(which virtualenvwrapper_lazy.sh)
[ "$__venvwrapper" ] && source $__venvwrapper

#########
# WATCH #
#########
# this function is launched every $PERIOD seconds
_rehash(){ rehash }
add-zsh-hook periodic _rehash
PERIOD=30
watch=(notme)
LOGCHECK=120
REPORTTIME=5
MAILCHECK=0

###########
# HISTORY #
###########
HISTFILE=$ZVARDIR/history
HISTSIZE=10000
SAVEHIST=$HISTSIZE
LISTMAX=1000
setopt bang_hist          # treat ! specially like csh did
setopt hist_ignore_dups   # ignore duplicates in the history
setopt extended_history   # save timestamp and duration with each event
setopt hist_find_no_dups  # skip over non-contiguous duplicates when searching history
setopt hist_ignore_space  # don't store commands starting with a space in the history file
setopt hist_no_store      # don't store history/fc -l invocations
setopt hist_reduce_blanks # remove superfluous blanks from each command line
setopt histverify         # when using ! cmds, confirm first

###############
# Interactive #
###############
setopt interactive_comments
setopt auto_cd         # a commande like % /usr/local is equivalent to cd /usr/local
setopt autopushd       # automatically append dirs to the push/pop list
setopt pushdignoredups # and don't duplicate them
setopt pushd_to_home   # cd go to home
setopt pushd_minus     # push + -
setopt pushdsilent
setopt noclobber       # do not clobber files with >
setopt nohup           # don't send HUP signal when closing term session
setopt notify          # report the status of backgrounds jobs immediately
setopt no_bgnice       # do not auto-nice background processes
setopt nocaseglob
setopt rmstarwait      # wait 10 seconds before querying for a rm which contains a *
setopt noflow_control  # desactive ^S/^Q
#setopt printexitvalue  # show the exit-value if > 0
setopt checkjobs       # do alert me of running jobs before exiting
setopt no_bad_pattern  # don't bitch about bad patterns, just use them verbatim
setopt no_nomatch      # don't bitch about no matches, just the glob character verbatim
setopt no_beep         # do. not. ever. beep.
set -C                 # Don't ecrase file with >, use >| (overwrite) or >> (append) instead

# automatically escape URLs
# /usr/share/zsh*/functions/Zle/url-quote-magic
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# bindkeys
bindkey -e              # load emacs bindkeys
bindkey " " magic-space # also do history expansion on space

# Make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        emulate -L zsh
        printf '%s' ${terminfo[smkx]}
    }
    function zle-line-finish () {
        emulate -L zsh
        printf '%s' ${terminfo[rmkx]}
    }
    zle -N zle-line-init
    zle -N zle-line-finish
else
    for i in {s,r}mkx; do
        (( ${+terminfo[$i]} ))
    done
    unset i
fi

autoload -U zed                           # what, your shell can't edit files?
autoload -U select-word-style

function backward-kill-word-bash-match(){
	autoload backward-kill-word-match
	select-word-style normal
	backward-kill-word-match
	select-word-style bash
}
autoload -U backward-kill-word-bash-match
zle -N backward-kill-word-bash backward-kill-word-bash-match
bindkey "" backward-kill-word-bash
select-word-style bash

autoload -U edit-command-line             # later bound to C-z e
zle -N edit-command-line
bindkey "" edit-command-line
bindkey "e" edit-command-line

##############
# Completion #
##############
setopt auto_list         # automatically list choices on an ambiguous completion
setopt auto_menu         # use menu after the second completion request
setopt rec_exact         # recognise exact matches even if they're ambiguous
setopt always_to_end     # move cursor to end of word being completed
setopt correct           # try to correct the spelling if possible
setopt correctall        # correct all arguments, not just the command
setopt completeinword    # not just at the end
setopt always_to_end     # move to cursor to the end after completion
setopt chase_dots        # Replace ../ by the right directory
setopt complete_aliases
setopt listpacked        # Small list
setopt extended_glob     # in order to use #, ~ and ^ for filename generation
setopt auto_param_keys   # be magic about adding/removing final characters on tab completion
setopt auto_param_slash  # be magic about adding/removing final characters on tab completion
setopt auto_remove_slash # be magic about adding/removing final characters on tab completion
zmodload zsh/complist    # load fancy completion list and menu handler

# initialise the completion system
autoload -U compinit
compinit -i -d $ZVARDIR/comp-$HOST


# Use cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $ZVARDIR/compcache

# list of completers to use
#zstyle ':completion:*' completer _list _expand _complete _ignored _match _correct _approximate _prefix
zstyle ':completion:*::::' completer _complete _ignored _match _approximate _list _prefix

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'
# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format $fg_bold[white]'%U%d%b%u'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*:expand:*' tag-order all-expansions
zstyle ':completion:*' group-name ''

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# Use 'ps -au$USER' for fetch user process list
zstyle ':completion:*:processes' command 'ps -aux' #u$USER'
zstyle ':completion:*:*:(kill|killall):*' menu yes select
zstyle ':completion:*:*:(kill|killall):*' force-list always

# files to ignore
zstyle ':completion:*:(all-|)files' ignored-patterns '*.bk' '*.bak' '*.old' '*~' '.*.sw?'
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)svn'
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#svn'
zstyle ':completion:*:*:zless:*' file-patterns '*(-/):directories *.gz:all-files'
zstyle ':completion:*:*:lintian:*' file-patterns '*(-/):directories *.deb'
zstyle ':completion:*:*:less:*' ignored-patterns '*.gz'
zstyle ':completion:*:*:zcompile:*' ignored-patterns '(*~|*.zwc)'

zstyle ':completion:*:functions' ignored-patterns '_*'

# http://xana.scru.org/2005/08/20#ignorelatexjunk
zstyle -e ':completion:*:*:vim#:*:*' ignored-patterns \
  'texfiles=$(echo ${PREFIX}*.tex); [[ -n "$texfiles" ]] &&
  reply=(*.(aux|dvi|log|ps|pdf|bbl|toc|lot|lof|latexmain)) || reply=()'


##########
# PROMPT #
##########
setopt prompt_subst
autoload -Uz vcs_info
prompt_opts=(cr subst percent)
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '¹'  # display ¹ if there are unstaged changes
zstyle ':vcs_info:*' stagedstr '²'    # display ² if there are staged changes
zstyle ':vcs_info:*' formats '%b%u%c'
zstyle ':vcs_info:*' actionformats '%b(%a)'

_prompt_main(){
  RETVAL=$?
  local symbols=() ref ref_color venv host_color sep
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%F{yellow}⚙"
  [[ $RETVAL -ne 0 ]] && symbols+="%F{red}✘"
  [ "$symbols" ] && symbols="$symbols "

  sep="%B%F{white}:%b"

  ref="$vcs_info_msg_0_"
  if [[ -n "$ref" ]]; then
    [[ "${ref/(¹|²|¹²)/}" == "$ref" ]] && ref_color=green || ref_color=yellow
     [[ "${ref/.../}" == "$ref" ]] && ref="  $ref" || ref="✦ ${ref/.../}"
    ref="%B%F{$ref_color}$ref%b "
  fi
  [ $VIRTUAL_ENV ] && venv="%F{white}($(basename $VIRTUAL_ENV)) "

  case $HOST in
      gizmo|bob|billy|trudy|eve) logo="%F{161}🍥" ;;
      *) logo="@";;
  esac
  case $HOST in
      bob) host_color=green;;
      eve) host_color=blue;;
      billy|trudy) host_color=32;;
      gizmo) host_color=214;;
      *) host_color=242;;
  esac
  case $USER in
    root) host_color=161;;
  esac

  cwd="%~"
  # cwd=$(shrink_path -f)
  print    "%F{240}"
  print -n "%F{240}%F{$host_color}$USER%F{red}${logo}%F{$host_color}$HOST%F{red}$sep"
  print -n "%F{blue}%B${cwd}%b%F{red}%b"
  print
  print -n "$ref"
  print -n "$venv"
  print -n "$symbols"
  print -n "%F{$host_color}%(!.⚡.➤ )"
  print -n "%F{240}"
}

_prompt_precmd() {
  vcs_info 'prompt'
  PROMPT='%{%f%b%k%}$(_prompt_main)'
  SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [Nyae]? '
}
add-zsh-hook precmd _prompt_precmd

_title_set() {
  if [[ $TERM = screen* ]]; then
    #In screen this is %w
    print -nR $'\033k'$1$'\033'\\
  fi
  #In screen this is %h
  if [[ $TERM != linux ]]; then
    print -nR $'\033]0;'$2$'\007'
  else
    print -nR $'\033]0;'$1' - '$2$'\007'
  fi
}

_cutted_line(){
    local line="$1" cut_at=${2:-15}
    if [ ${#line} -gt $cut_at ]; then
        print -n -- "…$line[${#line}-$cut_at,${#line}]"
    else
        print -n -- "$line"
    fi
}
_title_precmd() {
  local pwd=${PWD/$HOME/"~"}
  _title_set "$(_cutted_line $pwd)" "[$pwd]"
}

add-zsh-hook precmd _title_precmd


_git_set_config(){
    key="$1"
    value="$2"
    cur=$(git config --get $key)
    ret=$?
    if [ $ret -ne 0 -o "$cur" != "$value" ]; then
        echo "-> set git '$key' to '$value' <-"
        git config "$key" "$value"
    fi
}

_set_git_account(){
    if [ "$vcs_info_msg_0_" ]; then
        if [ "${PWD/$HOME\/workspace\/wazo/}" == "${PWD}" ]; then
            _git_set_config user.email "sileht@sileht.net"
        else
            _git_set_config user.email "mabaakouk@wazo.io"
            _git_set_config git-pull-request.branch-prefix ""
            _git_set_config git-pull-request.fork never

            if [ -d .git -a ! -f .git/hooks/pre-commit ]; then
                echo "-> install pre commit hook"
                ln $HOME/workspace/wazo/xivo-tools/dev-tools/git-hooks/copyright-check \
                    .git/hooks/pre-commit
            fi
        fi
    fi
}
add-zsh-hook precmd _set_git_account

_prompt_preexec() {
        emulate -L zsh
        local -a cmd
        local pwd=${PWD/$HOME/"~"} arf
        cmd=(${(z)1})
        if [ "$cmd[1]" = "fg" ]; then
            cmd=($(jobs | grep -v "continued" | sed 's,.*suspended *,,g' | head -n1 ))
        fi
        arg=$(_cutted_line "$cmd[2,-1]")
        print -nR "${reset_color}"
        _title_set "$cmd[1] $arg" "["$PWD"] "$cmd[1,-1]
        if [ "$cmd[1]" = "scr" -o "$cmd[1]" = "sr" -o "$cmd[1]" = "sn" ]; then
            print -nR "${reset_color}"
            _title "$cmd[1]$arg" "Other"
        fi
}
add-zsh-hook preexec _prompt_preexec

mka () { time schedtool -B -n 1 -e ionice -n 1 make -j $(nproc) "$@" }
imka () { time schedtool -D -n 19 -e ionice -c 3 make -j $(nproc) "$@" }
masq (){ sudo iptables -t nat -A POSTROUTING -s "$1" ! -d "$1" -j MASQUERADE }
ban(){ sudo iptables -I INPUT 1 -s "$1" -j DROP }
unban(){ sudo iptables -D INPUT -s "$1" -j DROP }
alias idletask='schedtool -D -n 19 -e ionice -c 3'
alias batchtask='schedtool -B -n 1 -e ionice -n 1'

function cdt() { cd $(mktemp -td cdt.$(date '+%Y%m%d-%H%M%S').XXXXXXXX) ; pwd }
function s() { pwd >| $ZVARDIR/.saved_dir; }
function i() { sp="$(cat $ZVARDIR/.saved_dir 2>/dev/null)"; [ -d $sp -a -r $sp ] && cd $sp }
function p() {
    local -a working_dirs=($(ls -1d ~/workspace/*/(wazo-|xivo-|)${1}*/.git/.. | sed -e 's@/\.git/\.\./@@g'))
    if [ ${#working_dirs[@]} -eq 1 ] ; then
        cd "${working_dirs}" ; s ; return
    else
        for wd in ${working_dirs[@]}; do
            if [ "$(basename $wd)" == "${1}" ] || \
               [ "$(basename $wd)" == "wazo-${1}" ] || \
               [ "$(basename $wd)" == "xivo-${1}" ]; then
                cd "$wd"; s; return
            fi
        done
        select wd in ${working_dirs[@]}; do
            cd "$wd"; s; return
        done
    fi
}
i
add-zsh-hook chpwd s

inw(){ Xephyr :1 & pid=$! ; DISPLAY=:1 $*; kill $pid ;}

alias Q='exec zsh'
#alias sc="screen -RDD"
function sc() { tmux attach -d 2>/dev/null || tmux new-session ; }
alias open="xdg-open"
alias rm="nocorrect rm -i"
alias mv="nocorrect mv -i"
alias cp="nocorrect cp -i"
alias ln='nocorrect ln'
alias mkdir='nocorrect mkdir'
[ ${UID} -eq 0 ] && alias sudo="" || alias sudo="nocorrect sudo"
alias wget='noglob wget'
alias curl='noglob curl'
alias man="LANG=C man"
alias df="df -h"
alias diff='diff -rNu'
alias ip='ip -color'
alias optimutt="find ~/.mutt/cache/headers -type f -exec tcbmgr optimize -nl {} \;"
if [ $commands[kubectl] ]; then
  source <(kubectl completion zsh)
fi

function lsp() {
    local p="$1"
    while [ $p != "/" ]; do
        ls -ld $p
        p=$(dirname $p)
    done | tac | column -t
}

alias vim="nvim"
alias r="ranger"
alias vi="nvim"
alias vid="nvim --servername sileht"
alias vir="nvim --servername sileht --remote-silent"
alias svi="sudo -E /home/sileht/.bin/nvim"
alias psql="sudo -i -u postgres psql"
# alias pyclean='find . \( -type f -name "*.py[co]" \) -o \( -type d -path "*__pycache__*" \) ! -path "./.tox*" -delete"'
alias pyclean='find . \( -type f -name "*.py[co]" \) ! -path "./.tox*" -delete'
alias getaptkey='sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com'
alias more=less
function gcal() { gcalcli --military --monday -w $(($(tput cols)/8)) "$@"; }
alias did="nvim +'normal Go' +'r!date' ~/did.txt"
alias wwdk="wdk --dev-dir /home/sileht/workspace/wazo --hostname wazo"
alias nwdk="wdk --dev-dir /home/sileht/workspace/wazo --hostname nestbox"
function of() { lsof -np "$1" }
compdef _pids of

# FIND STUFF
alias locate='noglob locate'
alias find='noglob find'
alias qf='find . -iname '
alias findnosecure="find . -perm +4000 -print"
function sfind(){ find "$@" | egrep -v '(binaire|\.svn|\.git|\.bzr)' ; }

# GREP STUFF
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
function sgrep(){ grep "$@" --color=always| egrep -v '(Binary|binaire|\.svn|\.git)' ; }
function g(){ grep --color=always "$@" | more }

# ZSH STUFF
alias zmv="nocorrect noglob zmv"
alias mmv="nocorrect noglob zmv -W"
alias zcp='zmv -C'
alias zln='zmv -L'

hash -d doc=/usr/share/doc
hash -d log=/var/log

alias ls="LC_COLLATE=POSIX ls -h --color=auto -bCF --color=auto --group-directories-first"
alias ll="ls -lF"
alias la="ls -aF"
alias lla="ls -alF"
alias lsd='ls -ld *(-/DN)'
alias lsdir="for dir in *;do;if [ -d \$dir ];then;du -xhsL \$dir 2>/dev/null;fi;done"
function l(){ ls -hla --color="always" "$@" | more }
#zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
unset _LS_OPTS

# handy documentation lookup on Debian
# from http://www.michael-prokop.at/computer/config/.zshrc
doc() { cd /usr/share/doc/$1 && ls }
_doc() { _files -W /usr/share/doc -/ }
compdef _doc doc

function killd(){ DISPLAY="" ps xae | grep DISPLAY=:$1 | grep -v grep | awk '{print $1}' | zargs -r kill -9 }

function fwget(){
    local filename=$(wget -S --spider "$*" 2>&1| grep 'Content-disposition: attachment' | sed -e '/Content-disposition: attachment/s/.*filename="\(.*\)"/\1/g')
    if [ -n "$filename" ] ; then
       wget -O $filename "$*"
    else
       echo " * No attachement found"
    fi
}

# CD STUFF
function cd () {
if [[ -z $2 ]]; then
  if [[ -f $1 ]]; then
    builtin cd $1:h
  else
    if [[ $1 = ".." ]]; then
        new_pwd=${PWD%/*}
        [ -z "$new_pwd" ] && new_pwd="/"
        builtin cd $new_pwd
    else
        builtin cd $1
    fi
  fi
else
  if [[ -z $3 ]]; then
    builtin cd $1 $2
  else
    echo cd: too many arguments
  fi
fi
}

diclean () {
    docker images -q -f dangling=true | xargs docker rmi
}
dclean () {
    filter=${1:=whatever}
    for d in $(docker ps -a | grep --color=auto -v -e 'CONTAINER ID' -e " ${filter}_" | awk '{print $1}'); do
        docker stop $d
        docker rm $d
    done
    docker ps -a
}

sshclean(){
    hostname=$(echo $1 | sed -e 's/.*@\([^@]*\)/\1/g' -e 's/\.t$/.tetaneutral.net/g')
    for i in $hostname $(getent ahosts $hostname | awk '{print $1}' | sort -u); do
        ssh-keygen -R "$i"
        ssh-keygen -R "[$i]:22"
        ssh-keygen -R "[$i]:2222"
        ssh-keygen -R "[$i]:22222"
        ssh-keygen -R "[$i]:5555"
        ssh-keygen -R "[$i]:55555"
    done
}

sshrefresh(){
    sshclean "$1"
    hostname=$(echo $1 | sed 's/\.t$/.tetaneutral.net/g')
    for i in $hostname $(getent ahosts $hostname | awk '{print $1}' | sort -u); do
        new=$(ssh-keyscan -H "$i")
        if [ -z "$new" ]; then
            new=$(ssh-keyscan -p 2222 -H "$i")
        fi
        [ "$new" ] && echo "$new" >> /home/sileht/.ssh/known_hosts
    done
}

update-flash() {
    sudo update-pepperflashplugin-nonfree --status
    sudo update-pepperflashplugin-nonfree --install
    sudo update-pepperflashplugin-nonfree --status
}
update-widevine() {
    rm -f ~/.local/lib/libwidevinecdm.so
    widevine_version="$(wget -q -O- https://dl.google.com/widevine-cdm/current.txt)"
    wget -q "https://dl.google.com/widevine-cdm/${widevine_version}-linux-x64.zip" -O- | busybox unzip - -d ~/.local/lib libwidevinecdm.so
}

alias tox="eatmydata tox";

function etox() {
    zparseopts -D e+:=env
    typeset -A helper
    helper=($(seq 1 ${#env}))
    rootdir="$(pwd)"
    [ ! -d "$rootdir/.tox" ] && rootdir=".."
    [ ! -d "$rootdir/.tox" ] && rootdir="../.."
    [ ! -d "$rootdir/.tox" ] && rootdir="../../.."
    [ ! -d "$rootdir/.tox" ] && rootdir="../../../.."
    export OLDPATH=$PATH
    for item in ${(@v)helper}; do
        for e in "${(@s/,/)env[$item]}" ; do
            export VIRTUAL_ENV=$rootdir/.tox/$e
            if [ ! -d "$VIRTUAL_ENV" ] ; then
                tox -e$e --notest
            fi
            source $VIRTUAL_ENV/bin/activate
            eatmydata $*
            deactivate
        done
    done
    export PATH=$OLDPATH
    unset OLDPATH
    unset VIRTUAL_ENV
}

alias pipnodev="find /workspace/pip_cache/ -name '*.dev*' -delete"
function utox() {
    pipnodev
    zparseopts -D e+:=env
    typeset -A helper
    helper=($(seq 1 ${#env}))
    for item in ${(@v)helper}; do
        for e in "${(@s/,/)env[$item]}" ; do
            etox -e $e "$@" pip install -U pip
            etox -e $e "$@" pip install -U --upgrade-strategy eager -e . $(tox --notest --showconfig | awk '/^\[testenv:'$e'\]$/{while ($1 != "deps") { getline ; }; print $0 ; }' | sed -e 's/\s*deps\s*=\s*\[\(.*\)\]/\1/g' | sed -e 's/, / /g')
        done
    done
}

alias etox="nocorrect etox"
alias utox="nocorrect utox"
alias upip="pip install -U --upgrade-strategy eager"

source ~/.env/shrink-path.plugin.zsh
source ~/.env/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.env/zsh-history-substring-search/zsh-history-substring-search.zsh

typeset -A key
key=(
    BackSpace  "${terminfo[kbs]}"
    Home       "${terminfo[khome]}"
    End        "${terminfo[kend]}"
    Insert     "${terminfo[kich1]}"
    Delete     "${terminfo[kdch1]}"
    Up         "${terminfo[kcuu1]}"
    Down       "${terminfo[kcud1]}"
    Left       "${terminfo[kcub1]}"
    Right      "${terminfo[kcuf1]}"
    PageUp     "${terminfo[kpp]}"
    PageDown   "${terminfo[knp]}"
)

function bind2maps () {
    local i sequence widget
    local -a maps

    while [[ "$1" != "--" ]]; do
        maps+=( "$1" )
        shift
    done
    shift

    sequence="${key[$1]}"
    widget="$2"

    [[ -z "$sequence" ]] && return 1

    for i in "${maps[@]}"; do
        bindkey -M "$i" "$sequence" "$widget"
    done
}

bind2maps emacs             -- BackSpace   backward-delete-char
bind2maps       viins       -- BackSpace   vi-backward-delete-char
bind2maps             vicmd -- BackSpace   vi-backward-char
bind2maps emacs             -- Home        beginning-of-line
bind2maps       viins vicmd -- Home        vi-beginning-of-line
bind2maps emacs             -- End         end-of-line
bind2maps       viins vicmd -- End         vi-end-of-line
bind2maps emacs viins       -- Insert      overwrite-mode
bind2maps             vicmd -- Insert      vi-insert
bind2maps emacs             -- Delete      delete-char
bind2maps       viins vicmd -- Delete      vi-delete-char
bind2maps emacs viins vicmd -- Up          history-substring-search-up
bind2maps emacs viins vicmd -- Down        history-substring-search-down
bind2maps emacs viins vicmd -- PageUp      history-substring-search-up
bind2maps emacs viins vicmd -- PageDown    history-substring-search-down
bind2maps emacs             -- Left        backward-char
bind2maps       viins vicmd -- Left        vi-backward-char
bind2maps emacs             -- Right       forward-char
bind2maps       viins vicmd -- Right       vi-forward-char
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down


unfunction bind2maps


# https://st.suckless.org/patches/right_click_to_plumb/
__vte_urlencode() (
  # This is important to make sure string manipulation is handled
  # byte-by-byte.
  LC_ALL=C
  str="$1"
  while [ -n "$str" ]; do
    safe="${str%%[!a-zA-Z0-9/:_\.\-\!\'\(\)~]*}"
    printf "%s" "$safe"
    str="${str#"$safe"}"
    if [ -n "$str" ]; then
      printf "%%%02X" "'$str"
      str="${str#?}"
    fi
  done
)

__vte_osc7 () {
  printf "\033]7;%s%s\a" "${HOST:-}" "$(__vte_urlencode "${PWD}")"
}

precmd_functions+=(__vte_osc7)

function sgpg(){
    gpg_run_path=$(gpgconf --list-dirs socketdir)
    if [ -L $gpg_run_path/S.gpg-agent ]; then
        echo "* gpg-agent uses local systemd sockets"
        rm -rf $gpg_run_path
        systemctl --user start gpg-agent.socket gpg-agent-ssh.socket gpg-agent-extra.socket gpg-agent-browser.socket dirmngr.socket gpg-agent.service
    else
        echo "* gpg-agent uses ssh forwarded sockets"
        systemctl --user stop gpg-agent.socket gpg-agent-ssh.socket gpg-agent-extra.socket gpg-agent-browser.socket dirmngr.socket gpg-agent.service
        rm -rf $gpg_run_path
        source ~/.zlogin
    fi
}
##########
# SCREEN #
##########

INSIDE_TMUX_SCREEN="$WINDOW$TMUX_PANE"
if [ "$HOST" == "gizmo" -a ! "$INSIDE_TMUX_SCREEN" ]; then
    sc ; exit 0;
fi

if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi
