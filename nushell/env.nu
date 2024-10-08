# Nushell Environment Config File
#
# version = 0.82.0

def create_left_prompt [] {
    mut home = ""
    try {
        if $nu.os-info.name == "windows" {
            $home = $env.USERPROFILE
        } else {
            $home = $env.HOME
        }
    }

    let dir = ([
        ($env.PWD | str substring 0..($home | str length) | str replace $home "~"),
        ($env.PWD | str substring ($home | str length)..)
    ] | str join)

    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
    let path_segment = $"($path_color)($dir)"

    $path_segment | str replace --all (char path_sep) $"($separator_color)/($path_color)"
}

def create_right_prompt [] {
    let time_segment_color = (ansi magenta)

    let time_segment = ([
        (ansi reset),
        $time_segment_color,
        (date now | format date '%m/%d/%Y %r')
    ] | str join | str replace --all "([/:])" $"(ansi light_magenta_bold)${1}($time_segment_color)" |
        str replace --all "([AP]M)" $"(ansi light_magenta_underline)${1}")

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi rb),
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else { "" }

    ([$last_exit_code, (char space), $time_segment] | str join)
}
# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
    to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
    to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
  }
}

# Directories to search for scripts when calling source or use
#
# By default, <nushell-config-dir>/scripts is added
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts')
]

# Directories to search for plugin binaries when calling register
#
# By default, <nushell-config-dir>/plugins is added
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins')
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')

$env.KEYS_PATH = "/home/velocitatem/.config/nushell/keys.json"

$env.PATH = ($env.PATH | prepend '/home/velocitatem/.local/bin')
$env.PATH = ($env.PATH | prepend '/home/velocitatem/.cargo/bin')
# ~/.bun/bin
$env.PATH = ($env.PATH | prepend '/home/velocitatem/.bun/bin')
$env.PATH = ($env.PATH | prepend '/usr/bin/clion')
$env.PATH = ($env.PATH | prepend '/home/velocitatem/.dotnet/')
$env.HOME_PATH = /mnt/s/Documents/Projects/system_2/
$env.WORKON_HOME = /mnt/s/ENVS/

load-env (open $env.KEYS_PATH)
alias docat = /usr/bin/cat
alias dofind = /usr/bin/find
alias cat = bat --theme=Coldark-Cold
alias killemacs = pkill -SIGUSR2 emacs
alias labd1 = xrandr --output DP1-1 --above eDP1 --auto
alias labd2 = xrandr --output DP1-3 --right-of DP1-1 --auto
alias ollamaui = docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main
alias ollamaui-stop = docker stop (docker ps -q --filter ancestor=ghcr.io/open-webui/open-webui:main )
alias bayes = bash /mnt/s/scripts/bayes.sh
alias lab = bash /mnt/s/scripts/lab.sh


# ownerproof-3209348-1699973265-5c96ddbca989
$env.SSH_AUTH_SOCK = $"($env.XDG_RUNTIME_DIR)/ssh-agent.socket"

mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu

source ~/.config/nushell/secrets.nu
source ~/.cache/starship/init.nu
zoxide init nushell | save -f ~/.zoxide.nu
