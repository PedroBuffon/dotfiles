> _This wiki is automatically published from [ohmyzsh/wiki](https://github.com/ohmyzsh/wiki). To edit this page,_
> _go to [ohmyzsh/wiki](https://github.com/ohmyzsh/wiki), make your changes and submit a Pull Request._

## Zsh?

**Oh My Zsh** is a framework for [Zsh](https://www.zsh.org), the Z shell.

- In order for **Oh My Zsh** to work, **Zsh must be installed**.
  - Please run `zsh --version` to confirm.
  - Expected result: `zsh 5.0.8` or more recent
- Additionally, Zsh should be set as your default shell.
  - Please run `echo $SHELL` from a new terminal to confirm.
  - Expected result: `/usr/bin/zsh` or similar

## Install and set up zsh as default

If necessary, follow these steps to install Zsh:

1. There are two main ways to install Zsh:

   - With the package manager of your choice, _e.g._ `sudo apt install zsh` (see [below for more examples](#how-to-install-zsh-on-many-platforms))
   - From [source](https://zsh.sourceforge.io/Arc/source.html), following [the instructions from the Zsh FAQ](https://zsh.sourceforge.io/FAQ/zshfaq01.html#l7).

2. Verify installation by running `zsh --version`. Expected result: `zsh 5.0.8` or more recent.

3. Make it your default shell: `chsh -s $(which zsh)` or use `sudo lchsh $USER` if you are on Fedora.

   - Note that this will not work if Zsh is not in your authorized shells list (`/etc/shells`)
    or if you don't have permission to use `chsh`. If that's the case [you'll need to use a different procedure](https://www.google.com/search?q=zsh+default+without+chsh).
    - If you use `lchsh` you need to type `/bin/zsh` to make it your default shell.

4. Log out and log back in again to use your new default shell.

5. Test that it worked with `echo $SHELL`. Expected result: `/bin/zsh` or similar.

6. Test with `$SHELL --version`. Expected result: 'zsh 5.8' or similar