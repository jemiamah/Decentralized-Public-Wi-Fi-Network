# Decentralized Public Wi-Fi Network

A blockchain-based system for managing public Wi-Fi networks using Clarity smart contracts on the Stacks blockchain.

## Overview

This system provides a decentralized approach to managing public Wi-Fi infrastructure through five interconnected smart contracts:

1. **Access Point Management** - Monitors network coverage and performance
2. **User Authentication** - Manages free internet access registration
3. **Bandwidth Allocation** - Ensures fair usage across connected devices
4. **Security Monitoring** - Protects network from cyber threats and abuse
5. **Maintenance Coordination** - Schedules equipment upgrades and repairs

## Architecture

### Smart Contracts

- \`access-point-management.clar\` - Handles access point registration, status monitoring, and performance tracking
- \`user-authentication.clar\` - Manages user registration, session management, and access control
- \`bandwidth-allocation.clar\` - Implements fair usage policies and bandwidth distribution
- \`security-monitoring.clar\` - Tracks security events, manages threat detection, and enforces security policies
- \`maintenance-coordination.clar\` - Coordinates maintenance schedules, equipment upgrades, and repair requests

### Key Features

- **Decentralized Governance** - Community-driven decision making for network policies
- **Fair Usage** - Automated bandwidth allocation based on network capacity and user needs
- **Security First** - Real-time threat monitoring and automated response systems
- **Transparent Operations** - All network operations recorded on blockchain
- **Incentive Alignment** - Token rewards for network operators and maintainers

## Getting Started

### Prerequisites

- Clarinet CLI installed
- Node.js 18+ for testing
- Stacks wallet for contract deployment

### Installation

\`\`\`bash
git clone <repository-url>
cd decentralized-wifi-network
npm install
\`\`\`

### Testing

\`\`\`bash
npm test
\`\`\`

### Deployment

\`\`\`bash
clarinet deploy --testnet
\`\`\`

## Usage

### For Network Operators

1. Register access points using the access point management contract
2. Monitor performance metrics and coverage areas
3. Coordinate maintenance schedules
4. Earn rewards for providing reliable service

### For Users

1. Register for free internet access
2. Connect to available access points
3. Enjoy fair bandwidth allocation
4. Report issues or security concerns

### For Maintainers

1. Schedule equipment upgrades
2. Respond to repair requests
3. Monitor network health
4. Earn maintenance rewards

## Contract Interactions

### Access Point Registration

\`\`\`clarity
(contract-call? .access-point-management register-access-point
"AP-001"
{latitude: 40.7128, longitude: -74.0060}
u100)
\`\`\`

### User Authentication

\`\`\`clarity
(contract-call? .user-authentication register-user
"user@example.com"
"User Name")
\`\`\`

### Bandwidth Allocation

\`\`\`clarity
(contract-call? .bandwidth-allocation allocate-bandwidth
tx-sender
u50)
\`\`\`

## Security Considerations

- All user data is encrypted and stored securely
- Access points are authenticated before joining the network
- Real-time monitoring prevents abuse and attacks
- Automated threat response systems protect network integrity

## Contributing

Please read our contributing guidelines and submit pull requests for any improvements.

## License

MIT License - see LICENSE file for details
