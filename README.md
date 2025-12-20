# TMTR

## Track anything within your terminal (bash)

### Usage

```bash
tmtr
# Run without arguments to start tracking. Will show error with current tracked time if it's already tracking

tmtr stop
tmtr s

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
3. Select "y" or anything else when asked about colors in output.

At any time you can run `./install.sh` again and choose to have colors or get rid of them, it won't remove currently tracked time.
It will create a wrapper script inside `~/.local/bin/` that will point to `src/main.sh` inside the repo.

If you are using this inside vim then having colors is not the best option, since you will see ASCII codes for colors instead of colors itself.

### Uninstallation

1. Run `./uninstall.sh`

Removes wrapper at `~/.local/bin/tmtr` and this repo from your machine. After deletion you will be in non-existent directory, so use `cd ~` to get back to home.

