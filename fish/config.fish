# ------------------------------------------------------------------------
# anyenv
# ------------------------------------------------------------------------
# if [ -d $HOME/.anyenv ]
#     export PATH="$HOME/.anyenv/bin:$PATH"
#     eval (anyenv init - | source)
# end

# ------------------------------------------------------------------------
# programming language env
# ------------------------------------------------------------------------
# eval (goenv init - | source)
# export PATH="$GOPATH/bin:$PATH"
#
# eval (rbenv init - | source)
# export PATH="$HOME/.gem/ruby/2.3.0/bin:$PATH"

# ------------------------------------------------------------------------
# library env
# ------------------------------------------------------------------------

# git
# export PATH="/usr/local/Cellar/git/2.23.0/bin:$PATH"

# gcp
# source ~/Library/google-cloud-sdk/path.fish.inc

set -g fish_user_paths "/usr/local/opt/binutils/bin" $fish_user_paths

# ------------------------------------------------------------------------
# function
# ------------------------------------------------------------------------
function _peco_change_directory
  if [ (count $argv) ]
    peco --layout=top-down --query "$argv "|perl -pe 's/([ ()])/\\\\$1/g'|read foo
  else
    peco --layout=top-down |perl -pe 's/([ ()])/\\\\$1/g'|read foo
  end
  if [ $foo ]
    builtin cd $foo
  else
    commandline ''
  end
end
function peco_change_directory
  begin
    echo $HOME/.config
    ls -ad */|perl -pe "s#^#$PWD/#"|egrep -v "^$PWD/\."|head -n 5
    ghq-list
    ls -ad */|perl -pe "s#^#$PWD/#"|grep -v \.git
  end | sed -e 's/\/$//' | awk '!a[$0]++' | _peco_change_directory $argv
end

function ghq-list
    find (ghq root) -d 2 -maxdepth 2 | grep -v DS_Store | sed -e "s#(ghq root)/##g"
end

# merge history
function history-merge --on-event fish_preexec
  history --save
  history --merge
end
function peco_sync_select_history
  history-merge
  peco_select_history $argv
end

function fish_user_key_bindings
  bind \cr peco_sync_select_history # Bind for peco select history to Ctrl+R
  bind \c] peco_change_directory # Bind for peco change directory to Ctrl+F
end

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.fish ]; and . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.fish
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.fish ]; and . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.fish
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.fish ]; and . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.fish
