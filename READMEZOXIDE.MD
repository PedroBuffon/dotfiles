<!-- markdownlint-configure-file {
  "MD013": {
    "code_blocks": false,
    "tables": false
  },
  "MD033": false,
  "MD041": false
} -->

<div align="center">

<sup>Special thanks to:</sup>

<a href="https://www.warp.dev/?utm_source=github&utm_medium=referral&utm_campaign=zoxide_20231001">
  <div>
    <img src="contrib/warp.png" width="230" alt="Warp" />
  </div>
  <b>
    Warp is a modern, Rust-based terminal with AI built in so you and your team
    can build great software, faster.
  </b>
  <div>
    <sup>Visit <u>warp.dev</u> to learn more.</sup>
  </div>
</a>

<hr />

# zoxide

[![crates.io][crates.io-badge]][crates.io]
[![Downloads][downloads-badge]][releases]
[![Built with Nix][builtwithnix-badge]][builtwithnix]

zoxide is a **smarter cd command**, inspired by z and autojump.

It remembers which directories you use most frequently, so you can "jump" to
them in just a few keystrokes.<br />
zoxide works on all major shells.

[Getting started](#getting-started) •
[Installation](#installation) •
[Configuration](#configuration) •
[Integrations](#third-party-integrations)

</div>

## Getting started

```sh
z foo              # cd into highest ranked directory matching foo
z foo bar          # cd into highest ranked directory matching foo and bar
z foo /            # cd into a subdirectory starting with foo

z ~/foo            # z also works like a regular cd command
z foo/             # cd into relative path
z ..               # cd one level up
z -                # cd into previous directory

zi foo             # cd with interactive selection (using fzf)

z foo<SPACE><TAB>  # show interactive completions (zoxide v0.8.0+, bash 4.4+/fish/zsh only)
```

Read more about the matching algorithm [here][algorithm-matching].

## Installation

zoxide can be installed in 4 easy steps:

1. **Install binary**

   zoxide runs on most major platforms. If your platform isn't listed below,
   please [open an issue][issues].

   <details>
   <summary>Linux / WSL</summary>

   > The recommended way to install zoxide is via the install script:
   >
   > ```sh
   > curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
   > ```
   >
   > Or, you can use a package manager:
   >
   > | Distribution        | Repository              | Instructions                                                                                          |
   > | ------------------- | ----------------------- | ----------------------------------------------------------------------------------------------------- |
   > | **_Any_**           | **[crates.io]**         | `cargo install zoxide --locked`                                                                       |
   > | _Any_               | [asdf]                  | `asdf plugin add zoxide https://github.com/nyrst/asdf-zoxide.git` <br /> `asdf install zoxide latest` |
   > | _Any_               | [conda-forge]           | `conda install -c conda-forge zoxide`                                                                 |
   > | _Any_               | [guix]                  | `guix install zoxide`                                                                                 |
   > | _Any_               | [Linuxbrew]             | `brew install zoxide`                                                                                 |
   > | _Any_               | [nixpkgs]               | `nix-env -iA nixpkgs.zoxide`                                                                          |
   > | Alpine Linux 3.13+  | [Alpine Linux Packages] | `apk add zoxide`                                                                                      |
   > | Arch Linux          | [Arch Linux Extra]      | `pacman -S zoxide`                                                                                    |
   > | CentOS 7+           | [Copr]                  | `dnf copr enable atim/zoxide` <br /> `dnf install zoxide`                                             |
   > | ~Debian 11+~[^1]    | ~[Debian Packages]~     | ~`apt install zoxide`~                                                                                |
   > | Devuan 4.0+         | [Devuan Packages]       | `apt install zoxide`                                                                                  |
   > | Exherbo Linux       | [Exherbo packages]      | `cave resolve -x repository/rust` <br /> `cave resolve -x zoxide`                                     |
   > | Fedora 32+          | [Fedora Packages]       | `dnf install zoxide`                                                                                  |
   > | Gentoo              | [Gentoo Packages]       | `emerge app-shells/zoxide`                                                                            |
   > | Manjaro             |                         | `pacman -S zoxide`                                                                                    |
   > | openSUSE Tumbleweed | [openSUSE Factory]      | `zypper install zoxide`                                                                               |
   > | ~Parrot OS~[^1]     |                         | ~`apt install zoxide`~                                                                                |
   > | ~Raspbian 11+~[^1]  | ~[Raspbian Packages]~   | ~`apt install zoxide`~                                                                                |
   > | Rhino Linux         | [Pacstall Packages]     | `pacstall -I zoxide-deb`                                                                              |
   > | Slackware 15.0+     | [SlackBuilds]           | [Instructions][slackbuilds-howto]                                                                     |
   > | Solus               | [Solus Packages]        | `eopkg install zoxide`                                                                                |
   > | ~Ubuntu 21.04+~[^1] | ~[Ubuntu Packages]~     | ~`apt install zoxide`~                                                                                |
   > | Void Linux          | [Void Linux Packages]   | `xbps-install -S zoxide`                                                                              |

   </details>

   <details>
   <summary>Windows</summary>

   > zoxide works with PowerShell, as well as shells running in Cygwin, Git
   > Bash, and MSYS2.
   >
   > The recommended way to install zoxide is via `winget`:
   >
   > ```sh
   > winget install ajeetdsouza.zoxide
   > ```
   >
   > Or, you can use an alternative package manager:
   >
   > | Repository      | Instructions                          |
   > | --------------- | ------------------------------------- |
   > | **[crates.io]** | `cargo install zoxide --locked`       |
   > | [Chocolatey]    | `choco install zoxide`                |
   > | [conda-forge]   | `conda install -c conda-forge zoxide` |
   > | [Scoop]         | `scoop install zoxide`                |
   >
   > If you're using Cygwin, Git Bash, or MSYS2, you can also use the install script:
   >
   > ```sh
   > curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
   > ```

   </details>

2. **Setup zoxide on your shell**

   To start using zoxide, add it to your shell.

   <details>
   <summary>Bash</summary>

   > Add this to the <ins>**end**</ins> of your config file (usually `~/.bashrc`):
   >
   > ```sh
   > eval "$(zoxide init bash)"
   > ```

   </details>

   <details>
   <summary>PowerShell</summary>

   > Add this to the <ins>**end**</ins> of your config file (find it by running
   > `echo $profile` in PowerShell):
   >
   > ```powershell
   > Invoke-Expression (& { (zoxide init powershell | Out-String) })
   > ```

   </details>

   <details>
   <summary>Zsh</summary>

   > Add this to the <ins>**end**</ins> of your config file (usually `~/.zshrc`):
   >
   > ```sh
   > eval "$(zoxide init zsh)"
   > ```
   >
   > For completions to work, the above line must be added _after_ `compinit` is
   > called. You may have to rebuild your completions cache by running
   > `rm ~/.zcompdump*; compinit`.

   </details>

3. **Install fzf** <sup>(optional)</sup>

   [fzf] is a command-line fuzzy finder, used by zoxide for completions /
   interactive selection. It can be installed from [here][fzf-installation].

   > **Note**
   > zoxide only supports fzf v0.33.0 and above.
