<h1>Chocolatey Installation Script</h1>

<p>
  <a href="./README.md">English</a> | 
  <a href="./README.ru.md">Russian</a>
</p>

<h2>Description</h2>
<p>This script is designed to automate the installation of software using <strong>Chocolatey</strong> on <strong>Windows</strong>. It simplifies the process by providing a single command to install numerous packages, making system setup easier after reinstallation.</p>

<h2>Functionality</h2>
<ul>
  <li>Installs <strong>Chocolatey</strong> if it's not already installed.</li>
  <li>Installs specified packages from a predefined list.</li>
  <li>Configures basic configurations for the installed software where applicable.</li>
  <li>Creates shortcuts for <strong>Voicemeeter Potato</strong> using <strong>RunAsDate</strong> for stable startup.</li>
  <li>Restores <strong>Voicemeeter Potato</strong> settings from a backup.</li>
  <li>Applies a fix for <strong>Discord</strong> by moving the <code>installer.db</code> file.</li>
  <li>Offers an option to activate <strong>Windows</strong> (use with caution).</li>
</ul>

<h2>Installation and Usage</h2>
<ol>
  <li>Double-click <code>start.cmd</code> to run the script. This will execute the installation process, bypassing potential restrictions on running external PowerShell scripts.</li>
</ol>

<h3 id="advanced-configuration">Advanced Configuration</h3>

You can customize the list of packages to install by editing the `chocolateyPackages.txt` file, which is included in this repository.

### Package List Format

Each package should be listed on a new line. Here's an example:

```
firefox
telegram
discord
runasdate
steam
epicgameslauncher
bitwarden
7zip
vscode
git
docker
docker-compose
docker-desktop
just
vb-cable
voicemeeter-potato
lghub
nodejs-lts
python311
```

### Script Customization

For more complex logic or additional configuration steps after installation, consider modifying the `psScript.ps1` file or creating custom scripts that run after this script completes.

#### Example: Running Additional Commands Post-Installation

You can add custom commands at the end of `psScript.ps1`. Here's an example to open <strong>Visual Studio Code</strong> after its installation:

```powershell
# At the end of the psScript.ps1 file, add:
& code .
```

This will open <strong>VSCode</strong> in the current directory after all installations are complete.

#### Troubleshooting Tips

- **Permission Issues:** Ensure you're running <strong>CMD</strong> with administrator rights.
- **Package Not Found:** Check the spelling is correct and that the package exists on [Chocolatey.org](https://chocolatey.org/packages).
- **Script Errors:** Review error messages to pinpoint specific issues; these are often related to network connectivity or dependencies.

<h3 id="license-and-contributions">License and Contributions</h3>

This project is licensed under the MIT License.

Contributions are welcome! Feel free to submit `pull requests` with improvements or fixes.

---

**Note**: This documentation assumes you are familiar with basic command-line operations and <strong>PowerShell</strong> use. If you encounter issues not described here, refer to the [<strong>Chocolatey</strong> Documentation](https://docs.chocolatey.org/en-us/getting-started) for detailed troubleshooting guides.

---

**Additional Resources**

For more information on effectively using <strong>Chocolatey</strong> in your environment:

[<strong>Chocolatey</strong> Documentation](https://docs.chocolatey.org/en-us/)

[Repository Issues on GitHub](https://github.com/Tra-va-de/chocolatey-install-script/issues)

---

**Warning**: The <strong>Windows</strong> activation feature is included for educational purposes. Use at your own risk as it might violate <strong>Microsoft's</strong> license agreement. The author does not support or encourage piracy or illegal software activation.
