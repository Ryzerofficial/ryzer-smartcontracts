# Ryzer- Core Contracts

## Overview
Ryzer  is a decentralized platform for real estate tokenization, enabling the creation, management, and trading of tokenized real estate assets. The platform consists of several core smart contracts that work together to provide a secure and efficient ecosystem for real estate tokenization.

### WorkFlow 

![Ryzer_Flowdiagram](https://github.com/user-attachments/assets/eedb2f16-f929-4db4-9d5a-04802de03110)

## Technical Specifications

| Specification | Version/Details |
|--------------|----------------|
| EVM Version | Paris |
| Solidity Version | 0.8.29 |
| Development Framework | Foundry |
| Testing Framework | Forge |
| Key Dependencies | OpenZeppelin Contracts | 
| Network Support | XRPLEVM Testnet |

## Deployment Addresses

| Contract | Implementation Address | Proxy Address |
|----------|----------------------|---------------|
| Registry | 0x222383F16Be3dFc91303a727564C342417354E75 | 0xE46f98EB585C436BD29D0796420A0FDa41248546 |
| Factory | 0x88396B4e732f25De57E99635fB2b4629cdA4Ba28 | 0x981b7902f1eA8E7bB863acAa1BeDEa654363b81d |
| RealEstate | 0xa6bdb50c644a8359D736c5C5485846687b4F443b | - |
| Escrow | 0xB832C58a28061aFD9536B02d7ba120c7aE8822Ef | - |
| OrderManager | 0x819a8e571d8cd552C31FAF29267639beb41B1e95 | - |
| DAO | 0x61Da510A0f6294049956b96E5aDD75A2B8428846 | - |
| USDT | 0x8c99B4e51eA9Aa3df5F44FAeF0061f7Ad9Ef5102 | - |
| Ryzer Token | 0x784E7DeBd0690697B69688B6daA684611b6B8079 | - |

## Core Contracts

### 1. RyzerRegistry
The central registry contract that manages company and project metadata for real estate tokenization.
- Manages company registration and project metadata
- Handles different company types (LLC, Private Limited, DAO LLC, etc.)
- Supports various asset types (Commercial, Residential, Holiday, Land)
- Implements access control and upgradeable patterns
- Maintains mappings between companies, projects, and their associated contracts

### 2. RyzerFactory
The factory contract responsible for deploying and initializing new projects and their associated contracts.
- Creates new real estate tokenization projects
- Deploys and initializes associated contracts (Escrow, Order Manager, DAO)
- Manages project templates and configurations
- Handles company registration and project creation
- Implements upgradeable pattern with multi-signature template updates

### 3. RyzerRealEstateToken
The main token contract for representing real estate assets.
- Implements ERC20 token standard for real estate assets
- Manages token configurations and project details
- Handles metadata updates and approvals
- Controls investment limits and lock periods
- Implements dividend distribution mechanisms

### 4. RyzerEscrow
Manages the escrow functionality for real estate transactions.
- Handles fund escrow for real estate transactions
- Manages USDT token interactions
- Coordinates with project contracts and order management
- Implements secure fund holding mechanisms

### 5. RyzerOrderManager
Manages the order book and trading functionality.
- Handles buy/sell orders for real estate tokens
- Manages order matching and execution
- Coordinates with escrow and project contracts
- Implements trading rules and restrictions

### 6. RyzerDAO
Implements decentralized governance for projects.
- Manages project governance through token voting
- Handles proposal creation and voting
- Implements quorum thresholds and voting periods
- Coordinates with project contracts for execution

## Project Structure

The project folder (`src/core/project/`) contains specialized modules that handle specific aspects of the platform:

### Token Module (`/token`)
- `RyzerProjectToken.sol`: Implementation of project-specific tokens
- `TokenStorage.sol`: Storage layout for token contracts
- `IToken.sol`: Interface defining token contract interactions

### Compliance Module (`/compliance`)
- `ICompliance.sol`: Interface for compliance rules and regulations
- Handles KYC/AML requirements
- Manages regulatory compliance checks

### Onchain-ID Module (`/onchain-id`)
- Contains interfaces for identity management
- Handles user identity verification
- Manages on-chain identity records

### Registry Module (`/registry`)
- Contains interfaces for registry management
- Handles project and company registration
- Manages metadata storage and retrieval

## Technical Features

- **Upgradeable Contracts**: All core contracts use the UUPS upgradeable pattern
- **Access Control**: Role-based access control for administrative functions
- **Security Features**:
  - ReentrancyGuard implementation
  - Pausable functionality
  - Input validation and parameter checks
- **Gas Optimization**: Efficient storage patterns and batch operations
- **Modular Design**: Clear separation of concerns between different contract functionalities

## Development

### Prerequisites
- Solidity 0.8.29
- Foundry
- OpenZeppelin Contracts

### Setup
1. Clone the repository
2. Install dependencies
```bash
  forge install
```
3. Build the contracts
4. Configure environment variables
5. Run tests

### Testing
```bash
forge test
```

### Deployment

#### Local Development (Anvil)
```bash
# Start Anvil
anvil

# Deploy to Anvil
forge script script/DeployRyzerCore.s.sol:DeployRyzerCore
```

#### XRPL EVM Testnet
```bash
# Deploy to XRPL EVM Testnet
forge script script/DeployRyzerCore.s.sol:DeployRyzerCore--rpc-url xrplevm --broadcast --slow --account <keyname>
```

```bash
# Setup deployer private key securely
cast wallet import <keyname> --interactive
```

### Helper Configuration (HelperConfig.s.sol)

The `HelperConfig.s.sol` script manages network-specific configurations and contract deployments. It supports multiple networks:

#### Network Configurations
```solidity

struct NetworkConfig {
     address usdt;
     address ryzerToken;
     address deployer; 
}
```

#### Usage
```solidity
// Get network configuration
HelperConfig helperConfig = new HelperConfig();
NetworkConfig activeNetworkConfig = helperConfig.getActiveNetworkConfig();

```

## Security
- All contracts implement standard security best practices
- Regular security audits recommended
- Emergency pause functionality available
- Multi-signature requirements for critical operations

## License
MIT License

## Contact
For more information about the Ryzer platform, please visit our website or contact the development team.

