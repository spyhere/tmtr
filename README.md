# TMTR

## Track anything within your terminal (bash)

### Usage

```bash
tmtr
# Run without arguments to start tracking. Will show error with current tracked time if it's already tracking
tmtr stop
tmtr st

tmtr restart
tmtr rst

tmtr pause
tmtr p

tmtr resume
tmtr r

tmtr status
tmtr stat

tmtr log
tmtr l
# Log tracked time (if there is any) without any additional information
```

### Installation

1. Clone the repo
2. Inside the repo run `./install.sh`

It will create a wrapper script inside `~/.local/bin/` that will point to `tmtr.sh` inside the repo.

### Uninstallation

1. Run `./uninstall.sh`

Removes wrapper at `~/.local/bin/tmtr` and this repo from your machine. After deletion you will be in non-existent directory, so use `cd ~` to get back to home.

