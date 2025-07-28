# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"
#ZSH_THEME="agnoster"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#plugins=(git docker docker-compose dotenv colorize colored-man-pages copyfile copypath fancy-ctrl-z fzf git-auto-fetch git-prompt golang per-directory-history safe-paste zsh-interactive-cd zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting)
plugins=(docker docker-compose dotenv colorize colored-man-pages copyfile copypath fancy-ctrl-z fzf golang per-directory-history safe-paste zsh-interactive-cd zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting)
#plugins=(dotenv colorize colored-man-pages copyfile copypath fancy-ctrl-z fzf golang per-directory-history safe-paste zsh-interactive-cd zsh-autosuggestions zsh-history-substring-search)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"
#
#

# Function to handle Space and Ctrl+Space for history navigation
function magic-space() {
  if [[ -z $LBUFFER ]]; then
    case "$KEYS" in
      " ") zle up-history ;;     # Space moves up in history
      $'\x00') zle down-history ;; # Ctrl+Space moves down in history
    esac
    zle beginning-of-line  # Keep cursor at the start
  else
    zle self-insert
  fi
}

zle -N magic-space
bindkey ' ' magic-space    # Space for up-history
bindkey '\x00' magic-space # Ctrl+Space for down-history


# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
# alias cl="clear"
alias v="nvim"
alias c="clear"
alias m='$(fc -s) | more'
alias j="!! | jq"
alias ps="ps -ax"
alias nv="nvim ."
alias dp="docker ps"
alias dpa="docker ps -a"
alias de="docker exec -it"
alias dc="docker compose"
alias lg="lazygit"
alias dcu="docker compose up --build -d && docker compose logs -f"
alias dcd="docker compose down"
alias dcl="docker compose logs -f"
alias bat="batcat"
alias sshd="/usr/sbin/sshd"
alias around="grep -A 20 -B 20"
alias bw="binwalk --dd='.*'"
alias targz="tar -czvf"
alias untargz="tar -xvzf"
alias pass="openssl rand -hex 16"
alias py="python3.13"
alias python3="python3.13"
alias pip="pip3.13"
alias pip3="pip3.13"
alias fdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
alias yy="fc -ln -1 | pbcopy"
alias k="k9s"
alias s="source ~/.zshrc"
alias g="go run ."
alias gi="go mod init"
alias gm="go mod tidy"
alias rc="nvim ~/.zshrc && source ~/.zshrc"

alias urldecode='python3 -c "import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))"'
alias urlencode='python3 -c "import sys, urllib.parse as ul;print (ul.quote_plus(sys.argv[1]))"'

alias pwn="docker run --rm -it --platform=linux/amd64 --cap-add=SYS_PTRACE -v $(pwd):/root/work -p 23946:23496 skysider/pwndocker"

alias e="rm .command.sh && nvim .command.sh && source .command.sh"
alias ed="nvim .command.sh && source .command.sh"

alias wh='f(){ ip="$1"; [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] || ip=$(dig +short "$1" | grep -m1 -Eo "([0-9]{1,3}\.){3}[0-9]{1,3}"); curl -s "https://ipinfo.io/$ip" | jq; unset -f f; }; f'

alias rsync="rsync -rvh --progress --stats --exclude '.DS_Store'"

alias gcc64="docker run --rm --platform=linux/amd64 -v $PWD:/src -w /src gcc gcc"
alias ibrew='arch -x86_64 /usr/local/bin/brew'
alias x86='arch -x86_64 zsh'

clone() {
  git clone "https://github.com/$1"
  cd "$(basename "$1")"
}

ip() {
  # If no arguments are passed, show the local IP address
  if [ $# -eq 0 ]; then
    ifconfig | grep -B 2 " active" | grep inet | cut -d' ' -f2
  else
    # Otherwise run the ip command with remaining arguments
    command ip "$@"
  fi
}

eval $(ssh-agent -s) > /dev/null 2>&1
ssh-add -A > /dev/null 2>&1

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="/usr/local/opt/python/libexec/bin:$PATH"

export PATH="$HOME/go/bin:$PATH"

#alias qiq="python3 /Users/stearns/workspace/qiq/qiq.py"
eval "$(zoxide init zsh)"

export GHIDRA_INSTALL_DIR=/Applications/ghidra

GOEXPERIMENT=rangefunc
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
