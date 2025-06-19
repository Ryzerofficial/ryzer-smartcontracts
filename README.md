# Ryzer- Core Contracts

## Overview
Ryzer  is a decentralized platform for real estate tokenization, enabling the creation, management, and trading of tokenized real estate assets. The platform consists of several core smart contracts that work together to provide a secure and efficient ecosystem for real estate tokenization.

![Ryzer_Flowdiagram](https://github.com/user-attachments/assets/eedb2f16-f929-4db4-9d5a-04802de03110)

## Technical Specifications

| Specification | Version/Details |
|--------------|----------------|
| EVM Version | Paris |

| Solidity Version | 0.8.29 |
| Development Framework | Foundry |
| Testing Framework | Forge |
| Key Dependencies | OpenZeppelin Contracts | 
| Network Support | EVM Compatible Chains |

## Deployment Addresses

| Contract | Implementation Address | Proxy Address |
|----------|----------------------|---------------|
| Registry | 0xdBD2b75E72B3EbEcdaA1E4b5ec82Ec2fA0e7f7CD | 0xd72858dBA0C95af2bC8A4b442836455f790223d0 |
| Factory | 0x75ea086E9690465fF169c2941820A26f135C6dd6 | 0xf26F90656e8Db116fFDbdEf129D6191E3A8BF7Ff |
| RealEstate | 0x25c70bC5e38A92C71404011AD91009221Dbc6818 | - |
| Escrow | 0x4e19ac8CF9C72666ea2A3476EEBf08dE45d9938E | - |
| OrderManager | 0x1f0B1fc67B2a49CF8419123396331d046f1d4641 | - |
| DAO | 0xb02A2a61eCd641132a0d99b2E76d7E37268573FB | - |
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

