# Horilla HRMS - Production Deployment

This repository contains our production deployment of Horilla HRMS with custom modifications.

## Base Version
- **Horilla Version:** 1.4.0
- **License:** LGPL-2.1
- **Original Repository:** https://github.com/horilla-opensource/horilla

## Repository Structure

```
.
├── custom_modules/          # Your custom Django apps
├── deployment/              # Deployment scripts
│   ├── deploy.sh           # Initial deployment
│   └── update.sh           # Update to new versions
├── docs/                    # Additional documentation
├── CUSTOM_CHANGES.md       # Log of custom modifications
└── [Horilla core files]    # Original Horilla code
```

## Quick Start

### Initial Setup
```bash
# Clone repository
git clone https://github.com/YOUR-USERNAME/horilla-production.git
cd horilla-production
git checkout production

# Configure environment
cp .env.example .env
nano .env  # Edit with your settings

# Deploy
./deployment/deploy.sh
```

### Updating to New Versions
```bash
cd /path/to/horilla
./deployment/update.sh
```

## Branching Strategy

- `base-v1.4.0` - Clean Horilla v1.4.0 (no modifications)
- `production` - Production branch with custom changes
- `update-to-vX.X.X` - Temporary branches for updates

## Custom Modifications

See [CUSTOM_CHANGES.md](CUSTOM_CHANGES.md) for detailed list of customizations.

## Support

- Horilla Documentation: https://www.horilla.com/docs/
- Horilla Community: https://github.com/horilla-opensource/horilla/discussions
