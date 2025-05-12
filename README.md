# 🛡️ MXSpoof

A modular and interactive toolkit to detect email spoofing vulnerabilities using SPF, DKIM, and DMARC analysis.

---

## 📋 Project Overview

This project provides a centralized Bash script that helps you check one or multiple domains for email spoofing misconfigurations. Whether you're testing your own domain or auditing others, this script gives you actionable insights into their spoofability.

---

## ✅ System Requirements

Before using this toolkit, make sure your system meets the following:

- 💻 **OS:** Linux (Kali, Ubuntu, Termux, WSL)
- 🌐 **Internet Connection:** Required for DNS lookups
- 🧰 **Tools:** dig, grep, sed, awk, tee (usually pre-installed)

---

## 📦 Pre-Installation (One-Time Setup)

Make sure `git` and required tools are installed:

```bash
sudo apt update && sudo apt install git dnsutils coreutils -y
```

---

## 🚀 Installation

After installing prerequisites, follow these steps:

```bash
# 1. Clone the repository
git clone https://github.com/tomsec8/MXSpoof.git

# 2. Enter the project directory
cd MXSpoof

# 3. Give execute permission to the script
chmod +x mxspoof.sh

# 4. Run the script
./mxspoof.sh
```

---

## 🧠 Available Modes

During execution, you can choose one or more of the following:

| Mode              | Description                                                      |
|-------------------|------------------------------------------------------------------|
| 🌐 Single Domain   | Analyze spoofability of a single domain                         |
| 📂 Domain List     | Input a file with multiple domains for batch testing            |
| 💾 Save Results    | Optionally save the results to a TXT file after each session     |

---

## 👨‍💻 Maintainer

Project by [TomSec8](https://github.com/TomSec8)  
Feel free to open issues or pull requests with suggestions or fixes.

---

## 🙏 Credits

This project includes or is inspired by public DNS lookup tools, security standards, and community best practices.

---

## 📜 License

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.

---
