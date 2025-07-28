# Contributing to Proxmox Nag Disabler

Thank you for your interest in contributing to proxmox-nag-disabler! We welcome contributions from the community and are grateful for your help in making this project better.

## 📋 Table of Contents

- [Contributing to proxmox-nag-disabler](#contributing-to-proxmox-nag-disabler)
  - [📋 Table of Contents](#-table-of-contents)
  - [Code of Conduct](#code-of-conduct)
  - [Getting Started](#getting-started)
  - [Development Setup](#development-setup)
    - [Prerequisites](#prerequisites)
    - [Install Development Dependencies](#install-development-dependencies)
  - [Making Changes](#making-changes)
  - [Submitting Changes](#submitting-changes)
  - [Code Style Guidelines](#code-style-guidelines)
    - [Shell Script Standards](#shell-script-standards)
    - [Example](#example)
    - [Commit Message Format](#commit-message-format)
  - [Testing](#testing)
    - [Manual Testing Checklist](#manual-testing-checklist)
    - [Automated Testing](#automated-testing)
  - [Reporting Issues](#reporting-issues)
  - [Types of Contributions](#types-of-contributions)
  - [Questions](#questions)

## Code of Conduct

By participating in this project, you agree to abide by our Code of Conduct. We expect all contributors to be respectful and constructive in their interactions.

## Getting Started

1. __Fork the repository__ on GitHub
2. __Clone your fork__ locally:

   ```bash
   git clone https://github.com/your-username/proxmox-nag-disabler.git
   cd proxmox-nag-disabler
   ```

3. __Add the upstream repository__ as a remote:

   ```bash
   git remote add upstream https://github.com/original-owner/proxmox-nag-disabler.git
   ```

## Development Setup

### Prerequisites

- Proxmox VE test environment (recommended: VM or container)
- shellcheck for script linting
- Git for version control

### Install Development Dependencies

```bash
# Install shellcheck (macOS)
brew install shellcheck

# Install shellcheck (Ubuntu/Debian)
sudo apt-get install shellcheck

# Install pre-commit hooks
pip install pre-commit
pre-commit install
```

## Making Changes

1. __Create a feature branch__ from main:

   ```bash
   git checkout -b feature/your-feature-name
   ```

2. __Make your changes__ following the code style guidelines

3. __Test your changes__ thoroughly:
   - Run shellcheck on all shell scripts
   - Test on a Proxmox VE environment
   - Verify both installation and uninstallation work correctly

4. __Commit your changes__ with a descriptive commit message:

   ```bash
   git add .
   git commit -m "feat: add support for new Proxmox version"
   ```

## Submitting Changes

1. __Push your branch__ to your fork:

   ```bash
   git push origin feature/your-feature-name
   ```

2. __Create a Pull Request__ on GitHub with:
   - Clear title describing the change
   - Detailed description of what was changed and why
   - Reference to any related issues
   - Screenshots or output if applicable

3. __Wait for review__ and address any feedback

## Code Style Guidelines

### Shell Script Standards

- Use `#!/usr/bin/env bash` shebang
- Enable strict mode: `set -euo pipefail`
- Use `readonly` for constants
- Quote variables: `"$variable"`
- Use meaningful function and variable names
- Add comments for complex logic
- Follow the existing indentation style (2 spaces)

### Example

```bash
#!/usr/bin/env bash
set -euo pipefail

readonly SCRIPT_NAME="${0##*/}"
readonly VERSION="1.0"

log_info() {
    printf '%s %s\n' '-' "$1"
}

main() {
    local input_file="$1"
    log_info "Processing file: $input_file"
    # Process the file...
}
```

### Commit Message Format

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

- `feat:` - New features
- `fix:` - Bug fixes
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting, etc.)
- `refactor:` - Code refactoring
- `test:` - Adding or updating tests
- `chore:` - Maintenance tasks

## Testing

### Manual Testing Checklist

Before submitting changes, test the following scenarios:

- [ ] Fresh installation on clean Proxmox VE system
- [ ] Upgrade scenario (install, upgrade toolkit, verify patch persists)
- [ ] Uninstallation (verify original files are restored)
- [ ] Error handling (invalid parameters, permission issues)
- [ ] Multiple Proxmox VE versions (if applicable)

### Automated Testing

Run the following checks before submitting:

```bash
# Lint shell scripts
shellcheck nag.sh

# Run pre-commit hooks
pre-commit run --all-files
```

## Reporting Issues

When reporting issues, please include:

1. __Proxmox VE version__ (`pveversion -v`)
2. __Steps to reproduce__ the issue
3. __Expected behavior__ vs __actual behavior__
4. __Error messages__ or logs
5. __System information__ (OS, architecture)

Use the issue templates provided in the repository when available.

## Types of Contributions

We welcome several types of contributions:

- __Bug fixes__ - Fix issues in the existing code
- __Features__ - Add new functionality
- __Documentation__ - Improve or add documentation
- __Testing__ - Add or improve tests
- __Performance__ - Optimize existing code
- __Compatibility__ - Support for new Proxmox VE versions

## Questions

If you have questions about contributing, please:

1. Check existing issues and discussions
2. Open a new issue with the "question" label
3. Be patient - we're volunteers!

Thank you for contributing to proxmox-nag-disabler! 🚀
