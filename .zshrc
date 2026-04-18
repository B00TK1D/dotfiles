if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"


plugins=(git colorize colored-man-pages fzf golang per-directory-history safe-paste zsh-interactive-cd zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

prompt_context() {}

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

export ARCHFLAGS="-arch $(uname -m)"

source ~/.env

alias pip="pip3"
alias python="python3"

alias rc="nvim ~/.zshrc && source ~/.zshrc"
alias conf="nvim ~/.config && source ~/.zshrc && tmux source-file ~/.config/tmux/tmux.conf"

alias hosts="sudo vim /etc/hosts"
alias wg="sudo wg"
alias wgs="sudo wg show"
alias wgu="sudo wg-quick up"
alias wgd="sudo wg-quick down"
wge() { sudo wg-quick down $1; nvim /etc/wireguard/$1.conf; sudo wg-quick up $1}

alias c="clear;"
alias x="exit"
alias hs="tmux split-window -h"
alias vs="tmux split-window -v"
alias d="tmux split-window -h; tmux select-pane -l; nvim ."
alias mon="tmux split-window -d; tmux split-window -d 'mactop'; btop "

alias nv="nvim ."
alias oc="opencode"
alias lg="lazygit"
alias dcu="docker compose up --build -d && docker compose logs -f"
alias dcd="docker compose down"
alias dcl="docker compose logs -f"
alias dps="docker compose ps || docker ps"

alias p="ping -c 3"
alias fdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
alias lat="ping 8.8.8.8"

alias msg="osascript -e 'tell application \"Messages\" to activate'"
alias dsc="osascript -e 'tell application \"Discord\" to activate'"
alias crm="osascript -e 'tell application \"Chrome\" to activate'"


alias rsync="rsync -rvh --progress --stats --exclude '.DS_Store'"
alias sshkey="cat ~/.ssh/id_ed25519.pub"
alias kh="nvim ~/.ssh/known_hosts"
alias cert="sudo certbot certonly --email certs@bootk.id --agree-tos --dns-cloudflare --dns-cloudflare-credentials /etc/letsencrypt/cloudflare.ini -d"
alias dns="cloudflare-cli"
dnsa() {
  domain=$(echo "$1" | awk -F. '{print $(NF-1)"."$NF}')
  subdomain=$(echo "$1" | awk -F. '{for(i=1;i<=NF-2;i++) printf "%s%s", $i, (i<NF-2?".":"")}')
  cloudflare-cli -d "$domain" add -t A --ttl 60 "$subdomain" "$2"
}
dnsd() {
  domain=$(echo "$1" | awk -F. '{print $(NF-1)"."$NF}')
  subdomain=$(echo "$1" | awk -F. '{for(i=1;i<=NF-2;i++) printf "%s%s", $i, (i<NF-2?".":"")}')
  cloudflare-cli -d "$domain" rm -t A "$subdomain"
}


eval $(ssh-agent -s) > /dev/null 2>&1
ssh-add -A > /dev/null 2>&1

be() { echo "$*" | base64 }
bd() { echo "$*" | base64 -d }

search() {
    if [ "$#" -ne 0 ]; then
        export QUERY="$*"
    fi
    open "https://www.google.com/search?q=$(python3 -c "import urllib.parse; print(urllib.parse.quote_plus('$QUERY'))")"
}

alias lchef="open 'https://cyberchef.bootk.id'"
alias ldns="open 'https://dns.bootk.id'"
alias lfile="open 'https://file.bootk.id"
alias yt="open 'https://youtube.com'"

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

function sudo() {
  if [[ $# -eq 0 ]]; then
    /usr/bin/sudo $(fc -ln | tail -2 | head -1)
  else
    /usr/bin/sudo $@
  fi
}

zle -N magic-space
bindkey ' ' magic-space    # Space for up-history
bindkey '\x00' magic-space # Ctrl+Space for down-history


export LMSTUDIO_API_BASE="http://localhost:6769"
export LMSTUDIO_ENDPOINT_URL="http://localhost:6769"
export OPENAI_API_BASE="http://localhost:6769/v1"
#export GH_COPILOT_OVERRIDE_PROXY_URL="http://localhost:8080"
export OPENAI_API_KEY="not-needed"
function ask() {
  export QUERY="$*"
  #llm -m lmstudio/qwen/qwen3.5-35b-a3b -s "answer very short, no markdown or bullets, in one line of possible for ctf" "$QUERY"
  export ASK_OUTPUT=$(llm -m lmstudio/qwen/qwen3.6-35b-a3b -s "answer very short, no markdown or bullets, in one line of possible for ctf" "$QUERY" | tee /dev/tty)
}

function hard() {
  echo
  llm -m lmstudio/openai/gpt-oss-120b -s "answer very short. do not use markdown. do not use bullets and other enumeration" "$*"
}

alias run="eval \$ASK_OUTPUT"
alias chat="lms chat"

export PATH=$PATH:$(go env GOPATH)/bin # go
export PATH=/Users/user/.opencode/bin:$PATH # opencode
export PATH="/usr/local/opt/node/bin:$PATH" # npm
export PATH=$PATH:~/.local/bin

# Added by LM Studio CLI tool (lms)
export PATH="$PATH:/Users/user/.lmstudio/bin"
export LM_STUDIO_API_KEY="not-needed"


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
