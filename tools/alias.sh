#----------------------------------------------------------------------------------#
#             This script define useful alias and functions.                       #
#             You can put this script under /etc/bashrc/ for global usage          #
#             Or copy the content to your ~/.bashrc                                #
#  refer to http://www.cyberciti.biz/tips/bash-aliases-mac-centos-linux-unix.html  #
#----------------------------------------------------------------------------------#


## Colorize the ls output
alias ls='ls --color=auto'

## Use a long listing format
alias ll='ls -la'
 
## Show hidden files
alias l.='ls -d .* --color=auto'

## get rid of command not found
alias cd..='cd ..'
 
## list total size of folder and subfolder as windows file explorer
lfd="for i in `ls`; do sudo du -smh  2>/dev/null  $i; done | sort -nr "

## a quick way to get out of current directory 
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'

## Colorize the grep command output for ease of use (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

## Start calculator with math support
alias bc='bc -l'

## Create parent directories on demand
alias mkdir='mkdir -pv'

## install  colordiff package
alias diff='colordiff'

## Make mount command output pretty and human readable format
alias mount='mount |column -t'

## handy short cuts
alias h='history'
alias j='jobs -l'

## Create a new set of commands
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'

## Set vim as default
alias vi=vim
alias svi='sudo vi'
alias vis='vim "+set si"'
alias edit='vim'

## Show open ports
alias ports='netstat -tulanp'

## Control firewall (iptables) output
# shortcut for iptables and pass it via sudo#
alias ipt='sudo /sbin/iptables'
 
# display all rules #
alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'
alias firewall=iptlist

# get web server headers
alias header='curl -I'
 
# find out if remote server supports gzip / mod_deflate or not
alias headerc='curl -I --compress'

## become root
alias root='sudo -i'
alias su='sudo -i'

# reboot / halt / poweroff
alias reboot='sudo /sbin/reboot'
alias poweroff='sudo /sbin/poweroff'
alias halt='sudo /sbin/halt'
alias shutdown='sudo /sbin/shutdown'

## get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
 
## get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'

## Real clear screen
alias cls='clear && echo -en "\e[3J"'
