<!DOCTYPE html>
<html>

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <h2>Welcome file</h2>
  <link rel="stylesheet" href="https://stackedit.io/style.css" />
</head>

<body class="stackedit">
  <div class="stackedit__html"><h1 id="terminal-environment-documentation">Terminal Environment Documentation</h1>
<p><strong>Generated on:</strong> 2025-12-23<br>
<strong>System Focus:</strong> NixOS / Bash</p>
<hr>
<h2 id="nixos-system-management">1. NixOS System Management</h2>
<p>These aliases streamline the management of the NixOS immutable system and its configuration files.</p>
<ul>
<li><strong><code>npa</code></strong>: Installs profile packages via nix profile (requires experimental features: nix-command, flakes).</li>
<li><strong><code>enc</code></strong>: Opens <code>/etc/nixos/configuration.nix</code> with sudo privileges using the Nano editor.</li>
<li><strong><code>rs</code></strong>: Performs a “Dry Activate” to test for errors before switching the system to the new configuration.</li>
<li><strong><code>nu</code></strong>: Updates all Nix channels and immediately triggers a system rebuild.</li>
<li><strong><code>ncg</code></strong>: Performs “Garbage Collection” by deleting unreachable store paths and removing old system generations to free up disk space.</li>
<li><strong><code>rnd</code></strong>: Restarts the Nix Daemon; useful for clearing memory leaks or hung processes.</li>
<li><strong><code>nxal</code></strong>: A migration tool that formats your current <code>.bashrc</code> aliases into a syntax you can copy-paste directly into your <code>configuration.nix</code> file.</li>
</ul>
<hr>
<h2 id="advanced-alias-management">2. Advanced Alias Management</h2>
<p>Custom functions that allow you to modify your shell environment dynamically.</p>
<h3 id="sa-save-alias"><code>sa</code> (Save Alias)</h3>
<p><strong>Purpose:</strong> Adds a permanent alias to your <code>.bashrc</code> without manual editing.</p>
<ul>
<li><strong>How it works:</strong> It checks if the alias already exists (deleting the old one if it does), appends the new command to your config, and uses <code>eval</code> to make it usable in the current window immediately.</li>
<li><strong>Example:</strong> <code>sa 'lg=lazygit'</code></li>
</ul>
<h3 id="ra-remove-alias"><code>ra</code> (Remove Alias)</h3>
<p><strong>Purpose:</strong> Safely deletes a permanent alias.</p>
<ul>
<li><strong>How it works:</strong> Removes the specific alias line from <code>.bashrc</code> and runs <code>unalias</code> to clear it from the current session memory.</li>
</ul>
<h3 id="pa-printsearch-aliases"><code>pa</code> (Print/Search Aliases)</h3>
<p><strong>Purpose:</strong> A high-definition, color-coded viewer for your commands.</p>
<ul>
<li><strong>How it works:</strong> It strips away the “alias” prefix and uses <code>sed</code> to highlight pipes (<code>|</code>) in purple and quotes in yellow. If your terminal window is narrow, it automatically truncates long commands with an ellipsis (…) to keep the list clean.</li>
</ul>
<hr>
<h2 id="nix-profile-management-npr-remove-installed-profile-packages">3. Nix Profile Management (<code>npr</code>-remove installed profile packages)</h2>
<p>An interactive safety wrapper for managing user-level packages.</p>
<ol>
<li><strong>Index Mapping:</strong> Creates a temporary database of your <code>nix profile</code>.</li>
<li><strong>Selection:</strong> Prompts you for a simple number instead of a long, complex Nix hash.</li>
<li><strong>Path Verification:</strong> Before running the delete command, it checks if the <code>/nix/store/</code> path actually exists on the disk.</li>
<li><strong>Staged Execution:</strong> Displays the exact command it is about to run and asks for a <code>y/n</code> confirmation.</li>
</ol>
<hr>
<h2 id="hardware--performance-monitoring">4. Hardware &amp; Performance Monitoring</h2>

<table>
<thead>
<tr>
<th align="left">Alias</th>
<th align="left">Function</th>
</tr>
</thead>
<tbody>
<tr>
<td align="left"><strong><code>bcpu</code></strong></td>
<td align="left">Lists top 10 CPU-heavy processes, stripping away long Nix store paths for better readability.</td>
</tr>
<tr>
<td align="left"><strong><code>bm</code></strong></td>
<td align="left">Lists top 10 Memory-heavy processes with color-coded columns.</td>
</tr>
<tr>
<td align="left"><strong><code>bh</code></strong></td>
<td align="left">Displays Btrfs-specific filesystem usage and hardware device error stats.</td>
</tr>
<tr>
<td align="left"><strong><code>bsc</code> / <code>bss</code></strong></td>
<td align="left">Checks the status or starts a “Scrub” (a check for data corruption) on Btrfs drives.</td>
</tr>
<tr>
<td align="left"><strong><code>crit</code></strong></td>
<td align="left">Filters system logs for only “Critical,” “Alert,” and “Emergency” level errors.</td>
</tr>
<tr>
<td align="left"><strong><code>port</code></strong></td>
<td align="left">Shows which applications are currently “Listening” for network connections.</td>
</tr>
</tbody>
</table><hr>
<h2 id="file--utility-shortcuts">5. File &amp; Utility Shortcuts</h2>
<ul>
<li><strong><code>ex</code></strong>: The “Universal Extractor.” It detects the file extension (<code>.zip</code>, <code>.tar.gz</code>, <code>.7z</code>, etc.) and automatically applies the correct extraction command and flags.</li>
<li><strong><code>up</code></strong>: The “Mega Update.” One command to update Nix, reload the shell, vacuum logs, clean temp files, and run a home folder backup.</li>
<li><strong><code>big</code></strong>: Quickly identifies the 10 largest files or folders in your current directory.</li>
<li><strong><code>wf</code></strong>: Fetches a clean, 2-day weather forecast directly in your terminal.</li>
<li><strong><code>m</code></strong>: Enhances <code>man</code> pages by piping them through <code>bat</code> for syntax highlighting and easier reading.</li>
<li><strong><code>bkh</code></strong>: Uses <code>rsync</code> to back up your home directory to a mount point, excluding the <code>.cache</code> folder to save space.</li>
</ul>
<hr>
<h2 id="📦-required-dependencies">📦 Required Dependencies</h2>
<p>To ensure all the above commands work, the following packages must be installed in your <code>environment.systemPackages</code>:</p>
<h3 id="standard-utilities">Standard Utilities</h3>
<ul>
<li><code>coreutils</code>, <code>procps</code>, <code>util-linux</code>, <code>findutils</code>, <code>rsync</code></li>
</ul>
<h3 id="enhanced-cli-tools">Enhanced CLI Tools</h3>
<ul>
<li><strong><code>ripgrep</code></strong>: For the <code>sss</code> systemd filter.</li>
<li><strong><code>bat</code></strong>: For colorized <code>man</code> pages in the <code>m</code> alias.</li>
<li><strong><code>fastfetch</code></strong>: For system info in <code>ff</code> and <code>gh</code>.</li>
<li><strong><code>tree</code></strong>: For the directory visualization in <code>t</code>.</li>
<li><strong><code>nethogs</code> / <code>iotop</code></strong>: For network and disk monitoring.</li>
<li><strong><code>newsboat</code> / <code>sqlite</code></strong>: For the RSS feed reader <code>rns</code>.</li>
</ul>
<h3 id="extraction-suite">Extraction Suite</h3>
<ul>
<li><code>unzip</code>, <code>unrar</code>, <code>p7zip</code>, <code>zstd</code>, <code>gnutar</code></li>
</ul>
<h3 id="notes">Notes</h3>
<p>Ensure path exist or change to fit your needs.</p>
<hr>
<h2 id="ready-to-paste--format-for-configuration.nix">Ready to paste  format for configuration.nix</h2>
<pre><code>environment.systemPackages = with pkgs; [
    # --- System Monitoring &amp; Search ---
    ripgrep     # Required for 'sss' (service filtering)
    lsof        # Required for 'port' (listening ports)
    procps      # Required for 'bm' and 'bcpu' (process monitoring)
    nethogs     # Required for 'bnet' (network monitoring)
    iotop       # Required for 'bio' (disk I/O monitoring)
    rsync       # Required for 'bkh' (home directory backups)
    
    # --- UI &amp; Information ---
    fastfetch   # Required for 'ff' and 'gh' (system splash)
    bat         # Required for 'm' (colorized man pages)
    tree        # Required for 't' (directory visualization)
    newsboat    # Required for 'rns' (RSS reader)
    sqlite      # Required for 'rns' (RSS database queries)
    
    # --- Extraction Suite (Required for 'ex' function) ---
    unzip       # For .zip files
    unrar       # For .rar files
    p7zip       # For .7z files
    zstd        # For .zst files
    atool       # Archive management helper
    gnutar      # For .tar, .gz, .xz, etc.
  ];
</code></pre>
<hr>
<h2 id="ready-to-paste--format-for-.bashrc">Ready to paste  format for .bashrc</h2>
<pre><code>==============================================================================
# PERMANENT ALIASES
# ==============================================================================

alias enc='sudo nano /etc/nixos/configuration.nix'
alias c=clear
alias sss="sudo systemctl --all --no-pager | rg --color=auto \"not-found|inactive|dead|$\""
alias jc="sudo journalctl --rotate &amp;&amp; sudo journalctl --vacuum-time=1d"
alias l="clear; ls -alh"
alias ll="clear; ls -l"
alias ls="clear; command ls --color=tty"
alias rs="sudo nixos-rebuild dry-activate &amp;&amp; sudo nixos-rebuild switch"
alias nu="sudo nix-channel --update &amp;&amp; rs"
alias big="clear; du -sh * .[^.]* 2&gt;/dev/null | sort -rh | head -n 10"
alias bm="clear; ps aux --sort=-%mem | head -n 11 | awk 'NR==1 {print \"\\033[1;34m\" \$0 \"\\033[0m\"} NR&gt;1 {split(\$11, a, \"/\"); cmd=a[length(a)]; printf \"\\033[1;32m%-8s\\033[0m %-7s %-5s \\033[1;31m%-5s\\033[0m %-9s %-9s %-7s %-6s %-6s %-8s \\033[1;33m%s\\033[0m\\n\", \$1, \$2, \$3, \$4, \$5, \$6, \$7, \$8, \$9, \$10, cmd}'"
alias nxal="grep \"^alias \" ~/.bashrc | sed \"s/alias //; s/=/ = /; s/$/;/\" | sudo tee /tmp/nix_aliases &amp;&amp; echo \"Aliases formatted. Manual step: Copy from /tmp/nix_aliases into your programs.bash.shellAliases block in configuration.nix\""
alias bh="clear; echo -e \"\033[1;34m--- File System Usage ---\033[0m\"; sudo btrfs filesystem usage /; echo -e \"\n\033[1;31m--- Error Stats ---\033[0m\"; sudo btrfs device stats /"
alias bsc="clear; sudo btrfs scrub status / | grep -E \"finished|errors\"; sudo btrfs device stats / | grep -v \" 0$\""
alias bs="clear; sudo btrfs scrub start /"
alias bss="clear; sudo btrfs scrub status /"
alias rns="clear; newsboat -x reload &gt;/dev/null 2&gt;&amp;1; sqlite3 ~/.newsboat/cache.db \"SELECT '● ' || title FROM rss_item WHERE unread = 1 ORDER BY pubDate DESC LIMIT 25;\""
alias ctmp="sudo systemd-tmpfiles --clean &amp;&amp; sudo du -sh /tmp"
alias crit="clear; echo -e \"\033[1;31m--- Critical Journal Errors ---\033[0m\"; sudo journalctl -p 0..2 --no-pager; echo -e \"\n\033[1;33m--- Critical Dmesg Errors ---\033[0m\"; sudo dmesg -l crit,alert,emerg"
alias ff="clear; fastfetch"
alias udb="sudo updatedb &amp;&amp; echo \"Locate database updated.\""
alias port="clear; sudo lsof -i -P -n | grep --color=auto LISTEN"
alias reboot="sudo reboot"
alias rb="source ~/.bashrc &amp;&amp; clear &amp;&amp; echo -e \"\033[1;32mEnvironment Reloaded\033[0m\""
alias mm="clear; echo -e \"\033[1;34mDEVICE\t\t\033[1;32mMOUNT\t\t\033[1;33mTYPE\t\033[1;35mOPTIONS\033[0m\"; mount | grep -v \" /nix/store\" | grep -E \"^/dev/\" | awk '{printf \"\033[1;34m%-15s\033[0m \033[1;32m%-15s\033[0m \033[1;33m%-8s\033[0m \033[0;2m%s\033[0m\\n\", \$1, \$3, \$5, \$6}'"
alias bcpu="clear; echo -e \"\033[1;32mCPU%\tPID\tCOMMAND\033[0m\"; ps -eo pcpu,pid,args --sort=-pcpu | grep -v \"%CPU\" | head -n 11 | sed -E \"s|/nix/store/[^/]+-||g\" | awk '{printf \"\033[1;32m%s%%\033[0m\t%s\t\033[1;37m%s\033[0m\\n\", \$1, \$2, \$3}'"
alias bkh="sudo rsync -avh --delete --exclude=\".cache/\" /home/dfinc/ /mnt/data/home_backup/"
alias npl="clear; nix profile list | grep \"Name:\" | sed -E \"s/Name:[[:space:]]+//\""
alias bkp="clear; nix profile list | grep \"Name:\" | sed -E \"s/Name:[[:space:]]+//\" | sudo tee /mnt/data/nixenv.bak &gt; /dev/null &amp;&amp; echo -e \"\033[1;32mPackage list backed up to /mnt/data/nixenv.bak\033[0m\""
alias up="clear; nu &amp;&amp; rb &amp;&amp; jc &amp;&amp; ctmp &amp;&amp; bkh &amp;&amp; echo -e \"\033[1;32mSystem Updated, Cleaned, and Backed Up.\033[0m\""
alias ports="clear; sudo ss -tulpn | grep LISTEN | column -t | awk '{print \"\033[1;32m\" \$5 \"\t\033[1;37m\" \$7}'"
alias his="history | grep --color=auto -i"
alias h="clear; history 15 | sed -E 's/^[[:space:]]*([0-9]+)[[:space:]]+(.*)/\x1b[1;32m● \x1b[1;34m\1\t\x1b[1;37m\2/'"
alias t="clear; tree -C -L 2 --filelimit 20 -I \".git|.cache|node_modules\""
alias gh="cd ~ &amp;&amp; clear &amp;&amp; echo -e \"\033[1;32mWelcome home, \$USER\033[0m\" &amp;&amp; echo \"-------------------\" &amp;&amp; fastfetch -l none"
alias wf="clear; echo -e \"\n\033[1;36m\$(date '+%A, %B %d, %Y')\033[0m  \033[1;33m\$(date '+%H:%M:%S')\033[0m\n\"; curl -s \"wttr.in?2\""
alias m="MANROFFOPT=\"-c\" MANPAGER=\"sh -c 'col -bx | bat -l man -p'\" man"
alias ncg="clear; sudo nix-collect-garbage -d &amp;&amp; echo -e \"\033[1;32mGarbage Collection Complete &amp; Old Generations Deleted.\033[0m\""
alias bnet="clear; sudo nethogs -v 4"
alias bio="clear; sudo iotop -oP"
alias rnd="clear; echo -e \"\033[1;33mRestarting Nix Daemon to reclaim memory...\033[0m\"; sudo systemctl restart nix-daemon &amp;&amp; echo -e \"\033[1;32mNix Daemon Reset Successfully\033[0m\""

# ==============================================================================
# FUNCTIONS
# ==============================================================================

# Save Alias: sa 'name=command'
function sa {
  if [ -z "$1" ]; then
    echo "Usage: sa 'name=command'"
    return 1
  fi
  local alias_name="${1%%=*}"
  if grep -q "alias ${alias_name}=" ~/.bashrc; then
    sed -i "/alias ${alias_name}=/d" ~/.bashrc
    echo "Updating existing alias: $alias_name"
  fi
  printf "alias %s\n" "$1" &gt;&gt; ~/.bashrc
  eval "alias $1"
  echo "Success: '$alias_name' is active."
}

# Remove Alias: ra alias_name
function ra {
  if [ -z "$1" ]; then
    echo "Error: Provide the alias name to remove. Usage: ra alias_name"
    return 1
  fi
  if grep -q "alias $1=" ~/.bashrc; then
    sed -i "/alias $1=/d" ~/.bashrc
    unalias "$1" 2&gt;/dev/null
    echo "Alias '$1' removed."
  else
    echo "Alias '$1' not found."
    unalias "$1" 2&gt;/dev/null
  fi
}

# Print/Search Aliases: pa or pa search_term
pa() {
    clear
    local search_term="$1"
    local cols=$(tput cols)
    local limit=$((cols - 13))

    alias | sed -E "s/^alias //; s/='(.*)'$/ \1/; s/=(.*)$/ \1/" | while read -r line; do
        local name=$(echo "$line" | awk '{print $1}')
        local cmd=$(echo "$line" | cut -d' ' -f2-)

        if [[ -n "$search_term" &amp;&amp; "$name" != "$search_term" ]]; then
            continue
        fi

        cmd=$(echo "$cmd" | sed -E "s/;/\\x1b[1;31m;\\x1b[0m/g; s/&amp;/\\x1b[1;34m&amp;\\x1b[0m/g; s/\|/\\x1b[1;35m|\\x1b[0m/g")
        local cmd_color=$(echo "$cmd" | sed -E "s/([\"'][^\"']*[\"'])/\x1b[1;33m\1\x1b[0m/g")

        if [[ -z "$search_term" &amp;&amp; ${#cmd} -gt $limit ]]; then
            printf "\x1b[1;32m%-10s \x1b[0m%.${limit}s...\n" "$name" "$cmd_color"
        else
            printf "\x1b[1;32m%-10s \x1b[0m%s\n" "$name" "$cmd_color"
        fi
    done
}

# Nix Profile Remover: npr (Interactive)
npr() {
    clear
    local db_file="$HOME/.nix_profile.tmpdb"
    nix profile list | grep "Name:" | sed -E 's/Name:[[:space:]]+//' | awk '{print NR-1 "," $0}' &gt; "$db_file"

    echo -e "\033[1;34mIndex    Package Name\033[0m"
    echo -e "\033[1;30m---------------------\033[0m"
    while IFS=, read -r idx name; do
        printf "\033[1;32m%-8s\033[0m %s\n" "$idx" "$name"
    done &lt; "$db_file"

    echo -e "\n\033[1;33mEnter index number to remove:\033[0m"
    read -r -p "&gt; " choice

    if [[ -z "$choice" ]] || ! [[ "$choice" =~ ^[0-9]+$ ]]; then
        [[ -f "$db_file" ]] &amp;&amp; rm -f "$db_file"
        return
    fi

    local target_name=$(grep "^${choice}," "$db_file" | cut -d',' -f2)
    if [[ -z "$target_name" ]]; then
        echo -e "\033[1;31mInvalid index: $choice\033[0m"
        rm -f "$db_file"
        return
    fi

    echo -e "\n\033[1;32mSelected Name:\033[0m $target_name"
    local target_occurrence=$((choice + 1))
    local target_path=$(echo $(nix profile list | grep "Store paths:" | sed -n "${target_occurrence}p" | sed -E 's/.*(\/nix\/store\/[^[:space:]]+).*/\1/'))

    echo -e "\033[1;36mFound Store Path:\033[0m $target_path"
    if [[ ! -e "$target_path" ]]; then
        echo -e "\033[1;31mError: Path does not exist on disk. Removal cannot proceed.\033[0m"
        rm -f "$db_file"
        return
    fi

    echo -e "\033[1;32mDisk Status: Verified OK\033[0m"
    local cmd="nix profile remove $target_path"
    echo -e "\n\033[1;35m--- STAGED COMMAND ---\033[0m"
    echo -e "\033[1;37m  $cmd\033[0m"
    echo -e "\033[1;35m----------------------\033[0m"

    read -r -p "Execute the removal command? (y/n): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        echo -e "\n\033[1;31mExecuting removal...\033[0m"
        $cmd
        echo -e "\n\033[1;32mSuccess: Removal operation complete.\033[0m"
    else
        echo -e "\n\033[1;33mAction cancelled.\033[0m"
    fi
    rm -f "$db_file"
}

# Universal Extract: ex filename
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
</code></pre>
<hr>
<p><em>Generated by Gemini for <a href="http://StackEdit.io">StackEdit.io</a></em></p>
</div>
</body>

</html>
