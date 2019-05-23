# ------------------------------------------------------------------------
# anyenv
# ------------------------------------------------------------------------
if [ -d $HOME/.anyenv ]
    export PATH="$HOME/.anyenv/bin:$PATH"
    eval (anyenv init - | source)
end

# ------------------------------------------------------------------------
# programming language env
# ------------------------------------------------------------------------
eval (goenv init - | source)
export PATH="$GOPATH/bin:$PATH"

# ------------------------------------------------------------------------
# library env
# ------------------------------------------------------------------------
source ~/Library/google-cloud-sdk/path.fish.inc

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
    ghq list -p
    ls -ad */|perl -pe "s#^#$PWD/#"|grep -v \.git
  end | sed -e 's/\/$//' | awk '!a[$0]++' | _peco_change_directory $argv
end

function fish_user_key_bindings
  bind \cr peco_select_history # Bind for peco select history to Ctrl+R
  bind \c] peco_change_directory # Bind for peco change directory to Ctrl+F
end
