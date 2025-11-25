# Security Policy

## Supported Versions

Currently supported versions of the MNIST Shiny Super-App:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

We take security seriously. If you discover a security vulnerability, please follow these steps:

### 1. Do Not Open a Public Issue

Please do not report security vulnerabilities through public GitHub issues.

### 2. Report via Email

Send details to: **[your.email@example.com]**

Include:
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

### 3. Response Time

- **Initial response:** Within 48 hours
- **Status update:** Within 7 days
- **Fix timeline:** Depends on severity

### 4. Disclosure Policy

- We will acknowledge your report within 48 hours
- We will provide regular updates on our progress
- We will notify you when the vulnerability is fixed
- We will credit you in the CHANGELOG (if desired)

## Security Best Practices

When using this application:

### Data Privacy
- MNIST data is public domain
- No user data is collected or transmitted
- Canvas drawings are processed locally

### Dependencies
- Keep R and packages updated
- Regularly check for security updates
- Use `update.packages()` to update dependencies

### Deployment
- Do not expose Shiny apps directly to the internet without proper authentication
- Use Shiny Server Pro or ShinyProxy for production deployments
- Implement proper access controls

### Configuration
- Review `config.R` before deployment
- Do not commit sensitive information
- Use environment variables for secrets

## Known Security Considerations

### TensorFlow/Keras
- Keras models can be large (memory considerations)
- Model serialization should be from trusted sources only
- Be cautious loading pre-trained models from unknown sources

### Shiny Canvas
- User drawings are processed client-side
- No image data is transmitted to external servers
- Canvas data is temporary and not persisted

### Model Training
- Training uses local compute resources
- Be aware of resource consumption
- Training on untrusted data should be done cautiously

## Vulnerability Disclosure Timeline

1. **Day 0:** Vulnerability reported
2. **Day 1-2:** Acknowledgment sent, initial assessment
3. **Day 3-7:** Investigation and fix development
4. **Day 7-14:** Testing and validation
5. **Day 14-21:** Patch release
6. **Day 21+:** Public disclosure (if appropriate)

## Security Updates

Security updates will be released as:
- **Critical:** Immediate patch release
- **High:** Patch within 7 days
- **Medium:** Patch in next minor release
- **Low:** Patch in next major release

## Contact

For security concerns:
- **Email:** [your.email@example.com]
- **PGP Key:** [If available]

For general issues:
- **GitHub Issues:** [Repository Issues Page]

## Acknowledgments

We appreciate security researchers who responsibly disclose vulnerabilities. Contributors will be acknowledged in:
- CHANGELOG.md
- Security advisories
- README.md (if desired)

## Third-Party Dependencies

This project uses several third-party packages. Security issues in dependencies should be:
1. Reported to the original maintainers
2. Also reported to us if it affects this application
3. We will update dependencies promptly when fixes are available

### Key Dependencies
- **Shiny:** Report to RStudio
- **Keras/TensorFlow:** Report to TensorFlow team
- **R packages:** Report to package maintainers

---

**Last Updated:** 2025-11-26
**Version:** 1.0.0
