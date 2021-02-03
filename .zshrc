# 少し凝った zshrc
# License : MIT
# http://mollifier.mit-license.org/

########################################
export PATH

# 環境変数
export LANG=ja_JP.UTF-8


# 色を使用出来るようにする
autoload -Uz colors
colors
export LSCOLORS=cxfxcxdxbxegedabagacad

# emacs 風キーバインドにする
bindkey -e

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# プロンプト
# 1行表示
# PROMPT="%~ %# "
# 2行表示
PROMPT="%{${fg[red]}%}[%n@%m]%{${reset_color}%} %~
%# "

autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
bindkey "^o" history-beginning-search-backward-end

# 単語の区切り文字を指定する
autoload -Uz select-word-style
select-word-style default
# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

########################################
# 補完
# 補完機能を有効にする
autoload -Uz compinit
compinit

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'


########################################
# vcs_info
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

zstyle ':vcs_info:*' formats '%F{green}(%s)-[%b]%f'
zstyle ':vcs_info:*' actionformats '%F{red}(%s)-[%b|%a]%f'

function _update_vcs_info_msg() {
    LANG=en_US.UTF-8 vcs_info
    RPROMPT="${vcs_info_msg_0_}"
}
add-zsh-hook precmd _update_vcs_info_msg


########################################
# オプション
# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# beep を無効にする
setopt no_beep

# フローコントロールを無効にする
setopt no_flow_control

# '#' 以降をコメントとして扱う
setopt interactive_comments

# ディレクトリ名だけでcdする
setopt auto_cd

# cd したら自動的にpushdする
setopt auto_pushd
# 重複したディレクトリを追加しない
setopt pushd_ignore_dups

# 同時に起動したzshの間でヒストリを共有する
setopt share_history

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 高機能なワイルドカード展開を使用する
setopt extended_glob

########################################
# キーバインド

# ^R で履歴検索をするときに * でワイルドカードを使用出来るようにする
bindkey '^R' history-incremental-pattern-search-backward

########################################
# エイリアス

alias la='ls -a'
alias ll='ls -la'

alias rm='rm -i'

alias mv='mv -i'

alias mkdir='mkdir -p'

# sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '
alias vi="vim"

# グローバルエイリアス
alias -g L='| less'
alias -g G='| grep'

# C で標準出力をクリップボードにコピーする
# mollifier delta blog : http://mollifier.hatenablog.com/entry/20100317/p1
if which pbcopy >/dev/null 2>&1 ; then
    # Mac
    alias -g C='| pbcopy'
elif which xsel >/dev/null 2>&1 ; then
    # Linux
    alias -g C='| xsel --input --clipboard'
elif which putclip >/dev/null 2>&1 ; then
    # Cygwin
    alias -g C='| putclip'
fi



########################################
# OS 別の設定
case ${OSTYPE} in
    darwin*)
        #Mac用の設定
        export CLICOLOR=1
        alias ls='ls -G -F'
        ;;
    linux*)
        #Linux用の設定
        alias ls='ls -F --color=auto'
        ;;
esac

# vim:set ft=zsh:
########################################
# PECO
########################################
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi

    BUFFER=$(\history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
#    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

####################################
# Peco with Git aash

function peco-git-hash() {
    local commit_hash="$(git log --oneline | peco | awk '{print $1}')"
    BUFFER="$LBUFFER $commit_hash"
    CURSOR=$#BUFFER
}

zle -N peco-git-hash
bindkey '^g' peco-git-hash # Ctrl+o で起動


########################################
# zsh-completions
########################################
fpath=(/usr/local/src/zsh-completions/src $fpath)
########################################

alias edit="vi ~/.zshrc"
alias update="source ~/.zshrc"

alias rails="bin/rails "
alias rake="bin/rake "
alias migrate="bin/rake db:migrate "
alias rs="bundle exec rails s -b 0.0.0.0"
alias bi="bundle install --path vendor/bundle"

alias pj="cd /home/vagrant/xxxx" # 要修正

alias rspec="bundle exec rspec "
# alias rubo="bundle exec rubocop -D -a"
# alias eslint='./node_modules/.bin/eslint "./app/javascript/**/*.{js,vue}"'

########################################
# https://qiita.com/sachaos/items/34946c0085e4e391628c
function peco-git-branch() {
    local branch="$(git branch -a | peco | tr -d ' ' | tr -d '*')"
    if [ -n "$branch" ]; then
      if [ -n "$LBUFFER" ]; then
        local flbuffer=$(echo $LBUFFER | sed -e 's/[ \t]*$//' | sed -e "s/.*/'&'/g")
        if [ ${flbuffer} = "'git'" ]; then
          local new_left="${LBUFFER%\ } co $branch"
        else
          local new_left="${LBUFFER%\ } $branch"
        fi
      else
        local new_left="$branch"
      fi
      BUFFER=${new_left}${RBUFFER}
      CURSOR=${#new_left}
    fi
}

zle -N peco-git-branch
bindkey '^B' peco-git-branch # Ctrl+o で起動

#=====================================================================

function setcom(){
  if [[ -n "$*" ]]; then
    eval "__precmd_for_subsh() { print -z '$* ' }"
  else
    eval "__precmd_for_subsh() { print -z '' }"
  fi

  autoload -Uz add-zsh-hook
  add-zsh-hook precmd "__precmd_for_subsh"
}


cd "/home/vagrant/xxxx" # 要修正
export PATH=$PATH:~/dir
# export MECAB_PATH=/usr/lib64/libmecab.so.2
# alias mongo_setup="sudo mongod --fork --logpath /data/log/log.txt"

# export PATH="$HOME/.nodenv/bin:$PATH"
# eval "$(nodenv init -)"
# PATH="$HOME/.local/bin:$PATH"
