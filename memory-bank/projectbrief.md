# Project Brief

## Purpose
This project aims to manage development environments for macOS and Raspberry Pi consistently using Nix, Home Manager, and nix-darwin.

## Core Components
- **Nix**: Foundation for package management and system configuration
- **Home Manager**: User environment configuration management
- **nix-darwin**: macOS-specific configuration management

## Target Environments
1. **macOS**
   - Development environment setup
   - Application and tool management
   - Shell environment configuration

2. **Raspberry Pi**
   - Server environment configuration
   - Nginx setup
   - System settings management

## Core Values
- **Reproducibility**: Same configuration across all environments
- **Version Control**: Track configuration changes
- **Modularity**: Separated environment configs for easy management

## Success Metrics
1. Reduced setup time for new environments
2. Maintained configuration consistency
3. Portable settings across environments
4. Traceable configuration through version control

## Scope
### Included
- System package management
- Development tool configuration
- Shell environment setup
- Editor (Neovim) configuration
- Git settings
- Environment-specific configs (macOS/Raspberry Pi)

### Excluded
- Application data
- Temporary configuration files
- User-specific secrets
