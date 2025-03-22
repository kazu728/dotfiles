# Technical Context

## Core Technologies

### 1. Nix Package Manager
- Version: Latest stable
- Purpose: Package management and system configuration
- Key Features:
  - Declarative configuration
  - Reproducible builds
  - Atomic upgrades
  - Rolling back changes

### 2. Home Manager
- Purpose: User environment management
- Integration: Nix-based configuration
- Scope: User-specific packages and settings

### 3. nix-darwin
- Purpose: macOS system configuration
- Integration: Nix ecosystem
- Scope: macOS-specific settings and packages

## Development Environment

### Required Tools
- Nix package manager
- Home Manager
- nix-darwin (for macOS)
- Git

### Core Packages
```nix
home.packages = [
  bottom     # System monitoring
  deno       # JavaScript runtime
  gh         # GitHub CLI
  ghq        # Repository management
  mise       # Runtime version manager
  nil        # Nix LSP
  nodejs_22  # Node.js runtime
  procs      # Process viewer
  rustup     # Rust toolchain
]
```

### Development Tools
1. **Shell Environment**
   - ZSH
   - Starship prompt
   - fzf fuzzy finder
   - direnv

2. **Editor**
   - Neovim
   - Custom configurations
   - Language servers

3. **Version Control**
   - Git with SSH signing
   - GitHub integration
   - Custom aliases

## Configuration Structure

### macOS Configuration
```
mac/
├── nixpkgs/
│   ├── darwin-configuration.nix
│   └── home.nix
├── neovim/
│   └── init.vim
└── zsh/
    └── .zshrc
```

### Raspberry Pi Configuration
```
rpi/
├── nixpkgs/
│   ├── configuration.nix
│   └── secrets.nix
└── nginx/
    ├── dockerfile
    ├── nginx.conf
    └── conf.d/
```

## Dependencies

### System Requirements
- macOS or Raspberry Pi OS
- Internet connection for package downloads
- Sufficient disk space
- Administrative privileges

### External Services
- GitHub (repository hosting)
- Nix package repositories

### Version Requirements
- Nix: Latest stable version
- Git: 2.0+
- ZSH: 5.0+

## Development Workflow

### Setting Up
1. Install Nix
2. Install Home Manager
3. Install nix-darwin (macOS only)
4. Clone repository
5. Run installation commands

### Making Changes
1. Edit Nix configuration files
2. Test changes locally
3. Commit and push changes
4. Update flake lock files

### Maintenance
1. Regular updates of Nix packages
2. Periodic garbage collection
3. Configuration testing
4. Documentation updates
