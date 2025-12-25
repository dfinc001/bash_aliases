# 99% Genereated by AI ;)
# Hope they help or someone makes them better 
# test and tweak for your environment npa npr npl -nix profile add remove list requires exprimental features nix-command flakes
#
# Permanent Aliases
alias enc='sudo nano /etc/nixos/configuration.nix' #edit nixos config

##################################################set alias -overwrites if alias exist


function sa {
  # 1. Error check for empty input
  if [ -z "$1" ]; then
    echo "Usage: sa 'name=command'"
    return 1
  fi

  # 2. Extract name (everything before =)
  local alias_name="${1%%=*}"

  # 3. Clean up existing definition from file
  if grep -q "alias ${alias_name}=" ~/.bashrc; then
    sed -i "/alias ${alias_name}=/d" ~/.bashrc
    echo "Updating existing alias: $alias_name"
  fi

  # 4. Safely append to file (using printf to prevent expansion bugs)
  printf "alias %s\n" "$1" >> ~/.bashrc

  # 5. Apply immediately to the current shell
  eval "alias $1"
  echo "Success: '$alias_name' is active."
}



##################################################remove alias

function ra {
  if [ -z "$1" ]; then
    echo "Error: Provide the alias name to remove. Usage: ra alias_name"
    return 1
  fi

  if grep -q "alias $1=" ~/.bashrc; then
    sed -i "/alias $1=/d" ~/.bashrc
    unalias "$1" 2>/dev/null
    echo "Alias '$1' removed."
  else
    echo "Alias '$1' not found."
    unalias "$1" 2>/dev/null
  fi
}

##################################################print alias



pa() {
    clear
    local search_term="$1"
    local cols=$(tput cols)
    local limit=$((cols - 13))

    # Process aliases, apply all colors, then filter if a term is provided
    alias | sed -E "s/^alias //; s/='(.*)'$/ \1/; s/=(.*)$/ \1/" | while read -r line; do
        local name=$(echo "$line" | awk '{print $1}')
        local cmd=$(echo "$line" | cut -d' ' -f2-)

        # If an argument is provided, skip aliases that don't match
        if [[ -n "$search_term" && "$name" != "$search_term" ]]; then
            continue
        fi

        # 1. Colorize operators: ; (Red), & (Blue), | (Purple)
        cmd=$(echo "$cmd" | sed -E "s/;/\\x1b[1;31m;\\x1b[0m/g; s/&/\\x1b[1;34m&\\x1b[0m/g; s/\|/\\x1b[1;35m|\\x1b[0m/g")

        # 2. Highlight quoted text in Bold Yellow
        local cmd_color=$(echo "$cmd" | sed -E "s/([\"'][^\"']*[\"'])/\x1b[1;33m\1\x1b[0m/g")

        # 3. Truncate with ellipsis, UNLESS we are looking for a specific alias
        if [[ -z "$search_term" && ${#cmd} -gt $limit ]]; then
            printf "\x1b[1;32m%-10s \x1b[0m%.${limit}s...\n" "$name" "$cmd_color"
        else
            printf "\x1b[1;32m%-10s \x1b[0m%s\n" "$name" "$cmd_color"
        fi
    done
}


##################################################nix profile remove


npr() {
    clear
    local db_file="$HOME/.nix_profile.tmpdb"

    # 1. Generate local index map of package names
    nix profile list | grep "Name:" | sed -E 's/Name:[[:space:]]+//' | awk '{print NR-1 "," $0}' > "$db_file"

    # 2. Display the current profile list
    echo -e "\033[1;34mIndex    Package Name\033[0m"
    echo -e "\033[1;30m---------------------\033[0m"
    while IFS=, read -r idx name; do
        printf "\033[1;32m%-8s\033[0m %s\n" "$idx" "$name"
    done < "$db_file"

    # 3. User Selection
    echo -e "\n\033[1;33mEnter index number to remove:\033[0m"
    read -r -p "> " choice

    # Exit if no choice made or if input is not a number
    if [[ -z "$choice" ]] || ! [[ "$choice" =~ ^[0-9]+$ ]]; then
        [[ -f "$db_file" ]] && rm -f "$db_file"
        return
    fi

    # 4. Map the index to the Name (for verification display)
    local target_name=$(grep "^${choice}," "$db_file" | cut -d',' -f2)

    if [[ -z "$target_name" ]]; then
        echo -e "\033[1;31mInvalid index: $choice\033[0m"
        rm -f "$db_file"
        return
    fi

    echo -e "\n\033[1;32mSelected Name:\033[0m $target_name"

    # 5. Extract Store Path (Precision Nth Line Logic)
    # Using your logic: pick exactly the (choice + 1)th line of "Store paths:"
    local target_occurrence=$((choice + 1))
    local target_path

    target_path=$(echo $(nix profile list | grep "Store paths:" | sed -n "${target_occurrence}p" | sed -E 's/.*(\/nix\/store\/[^[:space:]]+).*/\1/'))

    echo -e "\033[1;36mFound Store Path:\033[0m $target_path"

    # 6. Verify path exists on disk using the ! -e test as requested
    if [[ ! -e "$target_path" ]]; then
        echo -e "\033[1;31mError: Path does not exist on disk. Removal cannot proceed.\033[0m"
        rm -f "$db_file"
        return
    fi

    echo -e "\033[1;32mDisk Status: Verified OK\033[0m"

    # 7. Generate and DISPLAY the command before execution
    local cmd="nix profile remove $target_path"

    echo -e "\n\033[1;35m--- STAGED COMMAND ---\033[0m"
    echo -e "\033[1;37m  $cmd\033[0m"
    echo -e "\033[1;35m----------------------\033[0m"

    # 8. Confirmation Prompt
    read -r -p "Execute the removal command? (y/n): " confirm

    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        echo -e "\n\033[1;31mExecuting removal...\033[0m"
        # Run the command
        $cmd
        echo -e "\n\033[1;32mSuccess: Removal operation complete.\033[0m"
    else
        echo -e "\n\033[1;33mAction cancelled.\033[0m"
    fi

    # Cleanup temporary database
    rm -f "$db_file"
}


##################################################nix profile add


npa() {
    if [[ -z "$1" ]]; then
        echo "Usage: npa <search_term>"
        return 1
    fi

    local db_file="$HOME/.nix_search.tmpdb"
    clear
    echo -e "\033[1;34mSearching for: $1...\033[0m"

    # 1. Search and process output using JSON
    # - Extracts the attribute name (the part after the last dot)
    # - tac reverses the list so the bottom results are indexed 1
    local results=$(nix search --json nixpkgs "$1" 2>/dev/null | jq -r 'keys[]' | sed -E 's/.*\.//' | tac)

    if [[ -z "$results" ]]; then
        echo -e "\033[1;31mNo packages found for: $1\033[0m"
        return 1
    fi

    # 2. Store in temporary DB with index
    echo "$results" | awk '{print NR "," $1}' > "$db_file"

    # 3. Display list
    echo -e "\033[1;34mIndex    Package Name\033[0m"
    echo -e "\033[1;30m---------------------\033[0m"
    while IFS=, read -r idx name; do
        printf "\033[1;32m%-8s\033[0m %s\n" "$idx" "$name"
    done < "$db_file"

    # 4. User Selection
    echo -e "\n\033[1;33mEnter index number to add to profile:\033[0m"
    read -r -p "> " choice

    if [[ -z "$choice" ]] || ! [[ "$choice" =~ ^[0-9]+$ ]]; then
        [[ -f "$db_file" ]] && rm -f "$db_file"
        return
    fi

    # 5. Map choice to Package Name
    local target_pkg=$(grep "^${choice}," "$db_file" | cut -d',' -f2)

    if [[ -z "$target_pkg" ]]; then
        echo -e "\033[1;31mInvalid index: $choice\033[0m"
        rm -f "$db_file"
        return
    fi

    # 6. Execute Command
    echo -e "\n\033[1;32mExecuting: nix profile add nixpkgs#$target_pkg\033[0m"
    nix profile add "nixpkgs#$target_pkg"

    rm -f "$db_file"
}



##################################################nix generations differences - using nvd


ngd() {
    local sp="/nix/var/nix/profiles/"
    local sys1
    local sys2

    # Get the latest and earliest profiles
    sys1=$(/run/current-system/sw/bin/ls "$sp" | grep link | tail -1)
    sys2=$(/run/current-system/sw/bin/ls "$sp" | grep link | head -1)

    clear
    echo "${sp}${sys2}"
    echo "${sp}${sys1}"

    if [ "$sys1" = "$sys2" ]; then
        echo "No secondary gen to compare"
    else
        sudo nvd diff "${sp}${sys2}" "${sp}${sys1}"
    fi
}




##################################################found in another website extractor 
ex() {
    if [ -f "$1" ] ; then
        echo -e "\033[1;32mExtracting '$1'...\033[0m"
        case "$1" in
            *.tar.bz2|*.tbz2) tar xvjf "$1"    ;;
            *.tar.gz|*.tgz)   tar xvzf "$1"    ;;
            *.tar.xz|*.txz)   tar xvf "$1"     ;;
            *.tar.zst)        tar --zstd -xvf "$1" ;;
            *.bz2)            bunzip2 "$1"     ;;
            *.rar)            unrar x "$1"     ;;
            *.gz)             gunzip "$1"      ;;
            *.tar)            tar xvf "$1"     ;;
            *.zip)            unzip "$1"       ;;
            *.Z)              uncompress "$1"  ;;
            *.7z)             7z x "$1"        ;;
            *)                echo "can't extract '$1'..." ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}



##################################################


alias c="clear"
alias sss="sudo systemctl --all --no-pager | rg --color=auto \"not-found|inactive|dead|$\"" 
alias jc="sudo journalctl --rotate && sudo journalctl --vacuum-time=1d" # journal clean
alias l="clear; ls -alh"
alias ll="clear; ls -l"
alias rs="sudo nixos-rebuild dry-activate && sudo nixos-rebuild switch"
alias nu="sudo nix-channel --update && rs" #ref another alias rs- reload switch after channel update
alias big="clear; du -sh * .[^.]* 2>/dev/null | sort -rh | head -n 10" #top 10 big files in current dir
#big memory
alias bm="clear; ps aux --sort=-%mem | head -n 11 | awk 'NR==1 {print \"\\033[1;34m\" \$0 \"\\033[0m\"} NR>1 {split(\$11, a, \"/\"); cmd=a[length(a)]; printf \"\\033[1;32m%-8s\\033[0m %-7s %-5s \\033[1;31m%-5s\\033[0m %-9s %-9s %-7s %-6s %-6s %-8s \\033[1;33m%s\\033[0m\\n\", \$1, \$2, \$3, \$4, \$5, \$6, \$7, \$8, \$9, \$10, cmd}'"
#probably never use it just here for reference nix aliases
alias nxal="grep \"^alias \" ~/.bashrc | sed \"s/alias //; s/=/ = /; s/$/;/\" | sudo tee /tmp/nix_aliases && echo \"Aliases formatted. Manual step: Copy from /tmp/nix_aliases into your programs.bash.shellAliases block in configuration.nix\""
alias bh="clear; echo -e \"\033[1;34m--- File System Usage ---\033[0m\"; sudo btrfs filesystem usage /; echo -e \"\n\033[1;31m--- Error Stats ---\033[0m\"; sudo btrfs device stats /"
alias bsc="clear; sudo btrfs scrub status / | grep -E \"finished|errors\"; sudo btrfs device stats / | grep -v \" 0$\"" #just added this comment because extra quote"
alias bs="clear; sudo btrfs scrub start /"
alias bss="clear; sudo btrfs scrub status /"
alias rns="clear; newsboat -x reload >/dev/null 2>&1; sqlite3 ~/.newsboat/cache.db \"SELECT '● ' || title FROM rss_item WHERE unread = 1 ORDER BY pubDate DESC LIMIT 25;\"" #requires newsboat and sqlite3
alias ctmp="sudo systemd-tmpfiles --clean && sudo du -sh /tmp"
alias crit="clear; echo -e \"\033[1;31m--- Critical Journal Errors ---\033[0m\"; sudo journalctl -p 0..2 --no-pager; echo -e \"\n\033[1;33m--- Critical Dmesg Errors ---\033[0m\"; sudo dmesg -l crit,alert,emerg"
alias ff="clear; fastfetch"
alias udb="sudo updatedb && echo \"Locate database updated.\""
alias port="clear;sudo lsof -i -P -n | grep --color=auto LISTEN" #needs lsof installed
alias reboot="sudo reboot"
alias rb="source ~/.bashrc && clear && echo -e \"\033[1;32mEnvironment Reloaded\033[0m\"" # reload bashrc
#modern mount
alias mm="clear; echo -e \"\033[1;34mDEVICE\t\t\033[1;32mMOUNT\t\t\033[1;33mTYPE\t\033[1;35mOPTIONS\033[0m\"; mount | grep -v \" /nix/store\" | grep -E \"^/dev/\" | awk '{printf \"\033[1;34m%-15s\033[0m \033[1;32m%-15s\033[0m \033[1;33m%-8s\033[0m \033[0;2m%s\033[0m\\n\", \$1, \$3, \$5, \$6}'"
#big cpu
alias bcpu="clear; echo -e \"\033[1;32mCPU%\tPID\tCOMMAND\033[0m\"; ps -eo pcpu,pid,args --sort=-pcpu | grep -v \"%CPU\" | head -n 11 | sed -E \"s|/nix/store/[^/]+-||g\" | awk '{printf \"\033[1;32m%s%%\033[0m\t%s\t\033[1;37m%s\033[0m\\n\", \$1, \$2, \$3}'"
alias bkh="sudo rsync -avh --delete --exclude=\".cache/\" /home/dfinc/ /mnt/data/home_backup/" 
alias npl="clear; nix profile list | grep \"Name:\" | sed -E \"s/Name:[[:space:]]+//\"" #list profile packages installed
alias bkp="clear; nix profile list | grep \"Name:\" | sed -E \"s/Name:[[:space:]]+//\" | sudo tee /mnt/data/nixenv.bak > /dev/null && echo -e \"\033[1;32mPackage list backed up to /mnt/data/nixenv.bak\033[0m\"" #change path to your back up folder or drive 
alias up="clear; nu && rb && jc && ctmp && bkh && echo -e \"\033[1;32mSystem Updated, Cleaned, and Backed Up.\033[0m\"" #ref other aliases 
alias ports="clear; sudo ss -tulpn | grep LISTEN | column -t | awk '{print \"\033[1;32m\" \$5 \"\t\033[1;37m\" \$7}'" #needs ss installed 
alias his="history | grep --color=auto -i"
alias h="clear; history 15 | sed -E 's/^[[:space:]]*([0-9]+)[[:space:]]+(.*)/\x1b[1;32m● \x1b[1;34m\1\t\x1b[1;37m\2/'"
alias t="clear; tree -C -L 2 --filelimit 20 -I \".git|.cache|node_modules\"" #needs tree installed
alias gh="cd ~ && clear && echo -e \"\033[1;32mWelcome home, \$USER\033[0m\" && echo \"-------------------\" && fastfetch -l none" #needs fastfetch
alias wf="clear; echo -e \"\n\033[1;36m\$(date '+%A, %B %d, %Y')\033[0m  \033[1;33m\$(date '+%H:%M:%S')\033[0m\n\"; curl -s \"wttr.in?2\""
alias m="MANROFFOPT=\"-c\" MANPAGER=\"sh -c 'col -bx | bat -l man -p'\" man"
alias ncg="clear; sudo nix-collect-garbage -d && echo -e \"\033[1;32mGarbage Collection Complete & Old Generations Deleted.\033[0m\""
alias bnet="clear; sudo nethogs -v 4" #needs nethogs installed
alias bio="clear; sudo iotop -oP" #needs iotop installed
alias rnd="clear; echo -e \"\033[1;33mRestarting Nix Daemon to reclaim memory...\033[0m\"; sudo systemctl restart nix-daemon && echo -e \"\033[1;32mNix Daemon Reset Successfully\033[0m\"" #restat nix daemon
alias ccon="clear; sudo cat /etc/nixos/configuration.nix"  #cat config
alias bketc="clear; sudo rsync -avh /etc/ /mnt/data/etc/"  #change path to your backup of etc
alias npu="nix profile upgrade --all"
alias psg="ps auxww --sort size | grep --color"
alias ld="clear;ls -dl"
alias nb="nano ~/.bashrc"
