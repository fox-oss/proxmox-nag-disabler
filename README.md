# Proxmox-Nag-Disabler

> __⚠️ Educational Purpose Only__: This tool is intended for educational and learning purposes. Please consider supporting the Proxmox team by purchasing a [subscription](https://www.proxmox.com/en/proxmox-ve/pricing) for production environments.

A robust solution to permanently disable the Proxmox VE subscription nag screen using a dpkg trigger package that automatically re-applies the patch whenever `proxmox-widget-toolkit` is upgraded.

## 🚀 Features

- __Permanent Fix__: Creates a dpkg trigger package that automatically re-applies the nag removal patch
- __Upgrade-Safe__: Automatically triggers when `proxmox-widget-toolkit` is updated
- __Clean Uninstall__: Easily remove the package and restore original vendor files
- __Self-Testing__: Includes verification to ensure the patch is working correctly
- __No Manual Intervention__: Set it once and forget it

## 📋 Requirements

- Proxmox VE server
- Root access
- `proxmox-widget-toolkit` package installed

## 🛠️ Installation

### Quick Install (One-liner)

For a quick installation, you can use one of these one-liner commands:

__Using wget:__

```bash
wget -qO- https://raw.githubusercontent.com/fox-oss/Proxmox-Nag-Disabler/main/nag.sh | bash
```

__Using curl:__

```bash
curl -fsSL https://raw.githubusercontent.com/fox-oss/Proxmox-Nag-Disabler/main/nag.sh | bash
```

### Manual Installation

1. Clone this repository:

   ```bash
   git clone https://github.com/fox-oss/Proxmox-Nag-Disabler.git
   cd Proxmox-Nag-Disabler
   ```

2. Make the script executable:

   ```bash
   chmod +x nag.sh
   ```

3. Run the installer with root privileges:

   ```bash
   sudo ./nag.sh
   ```

The script will:

- Build a dpkg trigger package
- Install the package
- Apply the nag removal patch
- Restart the pveproxy service
- Verify the installation

## 🗑️ Uninstallation

To remove the package and restore the original Proxmox files:

```bash
sudo ./nag.sh --uninstall
```

## 🔧 How It Works

1. __Package Creation__: The script creates a dpkg trigger package that monitors changes to Proxmox JavaScript files
2. __Trigger Activation__: When `proxmox-widget-toolkit` is upgraded, the trigger automatically fires
3. __Patch Application__: The embedded patcher script removes the subscription nag screen code
4. __Service Restart__: The pveproxy service is restarted to apply changes

## 📁 Generated Files

The package creates the following files on your system:

- `/usr/local/bin/pve-nonag-patch.sh` - The patcher script
- Package triggers for JavaScript files in `/usr/share/javascript/proxmox-widget-toolkit/`

## ⚠️ Important Notes

- __Educational Purpose Only__: This tool is provided for educational and learning purposes only.
- This tool modifies Proxmox VE system files. Use at your own risk.
- Always test in a non-production environment first.
- __Support Proxmox VE__: Consider purchasing a [Proxmox VE subscription](https://www.proxmox.com/en/proxmox-ve/pricing) to support the excellent work of the Proxmox team and get professional support.
- Backups of original files are created automatically.
- This project is not affiliated with or endorsed by Proxmox Server Solutions GmbH.

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guidelines](CONTRIBUTING.md) before submitting pull requests.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

This tool is provided "as is" without warranty of any kind. The authors are not responsible for any damage or issues that may arise from its use. Always backup your Proxmox VE configuration before making changes.

## 🔗 Related Projects

- [Proxmox VE](https://www.proxmox.com/en/proxmox-ve) - Open-source server virtualization environment
- [Proxmox VE Subscription](https://www.proxmox.com/en/proxmox-ve/pricing) - Official Proxmox VE subscriptions

---

__Star ⭐ this repository if it helped you!__
