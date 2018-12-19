# ------------------------------------------------------------------------
# 計測用
# ------------------------------------------------------------------------
ZSH_SPEED_PROF=false
if $ZSH_SPEED_PROF; then
    zmodload zsh/zprof && zprof
fi

# ------------------------------------------------------------------------
# PATH初期化
# ------------------------------------------------------------------------
# User configuration
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
export PATH=$HOME/sh:$PATH

# ------------------------------------------------------------------------
# anyenv
# ------------------------------------------------------------------------
if [ -d $HOME/.anyenv ] ; then
    export PATH="$HOME/.anyenv/bin:$PATH"
    eval "$(anyenv init -)"
fi

# ------------------------------------------------------------------------
# zplug
# ------------------------------------------------------------------------
# zplugがなければzplugをインストール後zshを再起動
if [ ! -e "${HOME}/.zplug/init.zsh" ]; then
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh
fi

# zplug
source ${HOME}/.zplug/init.zsh
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# theme
zplug "themes/eastwood", from:oh-my-zsh, as:theme
zplug "lib/completion", from:oh-my-zsh
zplug "lib/termsupport", from:oh-my-zsh
zplug "lib/theme-and-appearance", from:oh-my-zsh

# history
zplug "lib/history", from:oh-my-zsh

# syntax
zplug "zsh-users/zsh-syntax-highlighting"

# suggest
zplug "zsh-users/zsh-autosuggestions"
bindkey '^e' forward-word
bindkey '^t' autosuggest-toggle

zplug "zsh-users/zsh-completions"

# plugins
zplug "plugins/git", from:oh-my-zsh
zplug "peco/peco", as:command, from:gh-r
zplug 'BurntSushi/ripgrep', as:command, from:gh-r, rename-to:rg
zplug "motemen/ghq", as:command, from:gh-r, rename-to:ghq
git config --global ghq.root ${HOME}/workspace # ghqベースディレクトリ設定
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug "junegunn/fzf", as:command, use:bin/fzf-tmux
zplug "lib/key-bindings", from:oh-my-zsh

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load #--verbose
export PATH=${HOME}/.zplug/bin:$PATH

# ------------------------------------------------------------------------
# 環境別
# ------------------------------------------------------------------------
if [ -e "${HOME}/.zshrc_env" ]; then
  source ${HOME}/.zshrc_env
fi

# ------------------------------------------------------------------------
# 便利機能
# ------------------------------------------------------------------------
#--- ghq連携
# ghq + peco
function peco-src () {
  local selected_dir=$(ghq list | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd $(ghq root)/${selected_dir}"
    zle accept-line
    zle clear-screen
  fi
}
zle -N peco-src

# ghq + fzf
function fzf-src () {
  local selected_dir=$(ghq list | fzf --ansi)
  if [ -n "$selected_dir" ]; then
    BUFFER="cd $(ghq root)/${selected_dir}"
    zle accept-line
    zle clear-screen
  fi
}
zle -N fzf-src

bindkey '^]' peco-src

#--- cd連携
# cd + peco
function peco-cd () {
  local selected_dir=$(find . -maxdepth 5 -type d | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
    zle clear-screen
  fi
}
zle -N peco-cd

bindkey '^[' peco-cd

#--- history連携
# history + peco
peco-select-history() {
    BUFFER=$(history 1 | sort -k1,1nr | perl -ne 'BEGIN { my @lines = (); } s/^\s*\d+\s*//; $in=$_; if (!(grep {$in eq $_} @lines)) { push(@lines, $in); print $in; }' | peco --query "$LBUFFER")
    CURSOR=${#BUFFER}

    zle accept-line
    zle clear-screen
}

zle -N peco-select-history

bindkey '^r' peco-select-history

# ------------------------------------------------------------------------
# 計測用
# ------------------------------------------------------------------------
if $ZSH_SPEED_PROF; then
    if (which zprof > /dev/null) ;then
      zprof | less
    fi
fi
