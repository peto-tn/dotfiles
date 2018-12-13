# User configuration
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
export PATH=$HOME/sh:$PATH

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
zplug "motemen/ghq", as:command, from:gh-r, rename-to:ghq
git config --global ghq.root ${HOME}/workspace # ghqベースディレクトリ設定
zplug "mollifier/anyframe"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load
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
# ghq + peco
function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey '^]' peco-src

# cd + peco
function peco-cd () {
  local selected_dir=$(find . -maxdepth 3 -type d | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-cd
bindkey 'pcd' peco-cd
