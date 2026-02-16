# MXSpoof 🛡️✉️

![MXSpoof](https://img.shields.io/badge/MXSpoof-Bash%20Tool-brightgreen)  
![GitHub Release](https://img.shields.io/badge/Release-v1.0.0-blue)  
![License](https://img.shields.io/badge/License-MIT-yellowgreen)  

## Overview

MXSpoof is a Bash tool designed to check if a domain is vulnerable to email spoofing. It does this by analyzing the domain's SPF, DKIM, and DMARC records. Email spoofing is a common tactic used in phishing attacks, and understanding a domain's vulnerabilities is crucial for securing email communications.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [How It Works](#how-it-works)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)
- [Release Information](#release-information)

## Features

- **SPF Record Analysis**: Checks the Sender Policy Framework (SPF) records to see if the domain allows the sending of emails from unauthorized servers.
- **DKIM Verification**: Validates DomainKeys Identified Mail (DKIM) signatures to ensure that the email content has not been altered in transit.
- **DMARC Assessment**: Evaluates Domain-based Message Authentication, Reporting & Conformance (DMARC) policies to determine how the domain handles unauthorized emails.
- **User-Friendly Output**: Provides clear results to help users understand the vulnerabilities of their domains.
- **Cross-Platform Compatibility**: Works on any system that supports Bash, including Linux distributions like Kali Linux.

## Installation

To install MXSpoof, follow these steps:

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/debashishmishra1122/MXSpoof.git
   ```

2. **Navigate to the Directory**:
   ```bash
   cd MXSpoof
   ```

3. **Make the Script Executable**:
   ```bash
   chmod +x mxspoof.sh
   ```

4. **Run the Tool**:
   Execute the tool with the following command:
   ```bash
   ./mxspoof.sh
   ```

## Usage

To use MXSpoof, run the script followed by the domain you want to analyze. Here’s the syntax:

```bash
./mxspoof.sh <domain>
```

For example:
```bash
./mxspoof.sh example.com
```

The tool will return the analysis of the SPF, DKIM, and DMARC records for the specified domain.

## How It Works

MXSpoof performs the following steps to check for email spoofing vulnerabilities:

1. **SPF Record Check**:
   - The tool queries the DNS for the SPF record of the domain.
   - It analyzes the record to see which IP addresses are authorized to send emails on behalf of the domain.

2. **DKIM Verification**:
   - It retrieves the DKIM public key from the DNS.
   - The tool checks if the key is valid and matches the signatures in the email headers.

3. **DMARC Assessment**:
   - The tool queries the DMARC record.
   - It evaluates the policy set by the domain owner regarding how to handle emails that fail SPF or DKIM checks.

4. **Output**:
   - MXSpoof presents the results in a user-friendly format, highlighting any vulnerabilities.

## Contributing

Contributions are welcome! If you would like to contribute to MXSpoof, please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Make your changes and commit them.
4. Push your branch to your forked repository.
5. Create a pull request to the main repository.

Your contributions help improve the tool and make it more useful for everyone.

## License

MXSpoof is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.

## Contact

For questions or suggestions, please reach out to the maintainer:

- **Name**: Debashish Mishra
- **Email**: debashish@example.com
- **GitHub**: [debashishmishra1122](https://github.com/debashishmishra1122)

## Release Information

You can download the latest release of MXSpoof [here](https://github.com/debashishmishra1122/MXSpoof/releases). Download the file and execute it as described in the installation section.

For further updates, check the "Releases" section of the repository.

---

By understanding and using MXSpoof, you can better secure your email domains against spoofing attacks. Regular checks can help maintain the integrity of your email communications.