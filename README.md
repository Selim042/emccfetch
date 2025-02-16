# emccfetch

Install with:
`pastebin fun w8dPRNHR`

## Todo
- [ ] Preset themes (pride flags)
- [ ] More OS support
- [X] Extensions for more info
  - [ ] Error handling for extensions

## Extensions
See `emccfetch.lua` for examples, all default info is provided by extensions.  As of now, they supply a single field, `name`, and a single function, `getInfo`.

## Run on Startup
Add this line to your `startup.lua` file, or to a new file in the `/startup` directory:
```lua
shell.run('emccfetch')
```
Change the path of the shell command if you move the `emccfetch.lua` file.
