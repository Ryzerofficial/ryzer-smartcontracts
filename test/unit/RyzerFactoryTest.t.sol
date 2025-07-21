// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

import {Test, console} from "forge-std/Test.sol";
import {DeployRyzerCore} from "script/DeployRyzerCore.s.sol";
import {RyzerFactory} from "src/core/RyzerFactory.sol";
import {RyzerRegistry} from "src/core/RyzerRegistry.sol";
import {RyzerRealEstateToken} from "src/core/RyzerRealEstateToken.sol";
import {RyzerEscrow} from "src/core/RyzerEscrow.sol";
import {RyzerOrderManager} from "src/core/RyzerOrderManager.sol";
import {RyzerDAO} from "src/core/RyzerDAO.sol";
import {UsdtMock} from "src/core/UsdtMock.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract RyzerFactoryTest is Test {
    DeployRyzerCore deployerCore;
    RyzerFactory ryzerFactory;
    ERC1967Proxy factoryProxy;
    RyzerRegistry ryzerRegistry;
    ERC1967Proxy registryProxy;
    RyzerRealEstateToken project;
    RyzerEscrow escrow;
    RyzerDAO dao;
    RyzerOrderManager orderManager;
    HelperConfig helperConfig;

    address deployer;
    address usdt;
    address ryzerToken;

    address user = makeAddr("user");

    string public companyName = "Test Company";
    string public jurisdiction = "Test Jurisdiction";
    string public projectName = "Test Project";

    function setUp() external {
        deployerCore = new DeployRyzerCore();
        (
            registryProxy,
            ,
            factoryProxy,
            ,
            project,
            escrow,
            orderManager,
            dao,
            helperConfig
        ) = deployerCore.run();

        (usdt, ryzerToken, deployer) = helperConfig.activeNetworkConfig();

        ryzerFactory = RyzerFactory(address(factoryProxy));
        ryzerRegistry = RyzerRegistry(payable(registryProxy));

        vm.startPrank(deployer);
        ryzerFactory.setCoreContracts(usdt, ryzerToken, address(registryProxy)); // after  deploying factory we have to call this function
        UsdtMock(usdt).mint(user, 7000e6);
        vm.stopPrank();
    }

    function _registerCompany(
        address owner,
        string memory name,
        string memory jurisdiction
    ) internal {
        RyzerFactory.CompanyParams memory params = RyzerFactory.CompanyParams({
            name: name,
            jurisdiction: jurisdiction,
            companyType: RyzerFactory.CompanyType.LLC
        });

        vm.startPrank(owner);

        // vm.expectEmit(true, true, true, true);
        // emit RyzerFactory.CompanyRegistered({
        //     companyId: 1,
        //     owner: owner,
        //     name: companyName,
        //     jurisdiction: jurisdiction,
        //     companyType: RyzerFactory.CompanyType.LLC
        // });
        ryzerFactory.registerCompany(params);
        vm.stopPrank();
    }
    // role management
    // storage concern
    // decimal if currency changes //
    // variables redundancy

    function _createProject(
        address owner,
        uint256 companyId,
        string memory projectName
    )
        internal
        returns (
            address expectedProject,
            address expectedEscrow,
            address expectedOrderManager,
            address expectedDao
        )
    {
        RyzerFactory.ProjectParams memory params = RyzerFactory.ProjectParams({
            onchainID: address(0),
            name: projectName,
            symbol: "RYZX",
            decimals: 18,
            maxSupply: 225e18,
            tokenPrice: 1316e6,
            cancelDelay: 86400,
            projectOwner: owner, // we have to check once
            assetId: bytes32("1"),
            assetType: bytes32("Commercial"),
            metadataCID: bytes32("1"),
            legalMetadataCID: bytes32("1"),
            minInvestment: 1e18, // decimal attached
            maxInvestment: 80e18,
            eoiPct: 10, // 10% of the total amount // check once
            dividendPct: 6,
            premintAmount: 225e18,
            requiredSignatures: 3,
            lockPeriod: 365 days
        });

        vm.prank(owner);
        (
            expectedProject,
            expectedEscrow,
            expectedOrderManager,
            expectedDao
        ) = ryzerFactory.createProject(companyId, params);
    }

    function testRegisterCompany_Success() public {
        _registerCompany(deployer, companyName, jurisdiction);

        //_registerCompany(deployer, "Sample Company", "Sample Jurisdiction");

        // assertEq(ryzerFactory.ownerToCompany(deployer), 1);
        assertEq(ryzerFactory.companyCount(), 1);
    }

    function testCreateProject_Success() public {
        _registerCompany(deployer, companyName, jurisdiction);

        uint256 companyId = 1;
        (
            address projectAddress,
            address escrowAddress,
            address orderManagerAddress,
            address daoAddresss
        ) = _createProject(deployer, companyId, projectName);

        assert(
            RyzerRealEstateToken(projectAddress).maxSupply() ==
                RyzerRealEstateToken(projectAddress).balanceOf(escrowAddress)
        );

        assert(
            RyzerRealEstateToken(projectAddress).maxSupply() ==
                RyzerRealEstateToken(projectAddress).totalSupply()
        );

        assertEq(companyId, 1);
    }

    function testPlaceOrder_Success() public {
        _registerCompany(deployer, companyName, jurisdiction);

        uint256 companyId = 1;
        (
            address projectAddress,
            address escrowAddress,
            address orderManagerAddress,
            address daoAddresss
        ) = _createProject(deployer, companyId, projectName);

        uint256[11] memory holdings = [
            uint256(7000e6),
            uint256(27000e6),
            uint256(16000e6),
            uint256(30000e6),
            uint256(40000e6),
            uint256(30000e6),
            uint256(16000e6),
            uint256(40000e6),
            uint256(28000e6),
            uint256(35000e6),
            uint256(34000e6)
        ];

        uint256[11] memory approvals = [
            uint256(6580e6),
            uint256(26320e6),
            uint256(15792e6),
            uint256(28952e6),
            uint256(39480e6),
            uint256(28952e6),
            uint256(15792e6),
            uint256(39480e6),
            uint256(27636e6),
            uint256(34216e6),
            uint256(32900e6)
        ];

        uint256[11] memory tokenInvested = [
            uint256(5e18),
            uint256(20e18),
            uint256(12e18),
            uint256(22e18),
            uint256(30e18),
            uint256(22e18),
            uint256(12e18),
            uint256(30e18),
            uint256(21e18),
            uint256(26e18),
            uint256(25e18)
        ];

        for (uint256 i = 0; i < 11; i++) {
            address investor = makeAddr(
                string(abi.encodePacked("investor", vm.toString(i)))
            );

            vm.startPrank(deployer);
            UsdtMock(usdt).mint(investor, holdings[i]);
            vm.stopPrank();

            RyzerOrderManager.PlaceOrderParams memory params = RyzerOrderManager
                .PlaceOrderParams({
                    _projectAddress: projectAddress,
                    _escrowAddress: escrowAddress,
                    _amount: tokenInvested[i],
                    _assetId: bytes32("1"),
                    _currencyPrice: 1e6,
                    _paymentType: RyzerOrderManager.PaymentType.FULL,
                    _currency: RyzerOrderManager.Currency.USDT,
                    _fees: 0
                });

            assertEq(
                RyzerRealEstateToken(projectAddress).balanceOf(investor),
                0
            );

            console.log(
                "Usdc balance before: ",
                UsdtMock(usdt).balanceOf(investor)
            );

            vm.startPrank(investor);
            UsdtMock(usdt).approve(escrowAddress, approvals[i]);
            bytes32 orderId = RyzerOrderManager(orderManagerAddress).placeOrder(
                params
            );
            vm.stopPrank();

            console.log(
                "Usdc balance after: ",
                UsdtMock(usdt).balanceOf(investor)
            );

            if (params._paymentType == RyzerOrderManager.PaymentType.FULL) {
                assertGt(
                    RyzerRealEstateToken(projectAddress).balanceOf(investor),
                    0
                );

                console.log(
                    "user balance: ",
                    RyzerRealEstateToken(projectAddress).balanceOf(investor)
                );
                console.log(
                    "escrow balance: ",
                    RyzerRealEstateToken(projectAddress).balanceOf(
                        escrowAddress
                    )
                );
            }

            vm.startPrank(investor);
            RyzerOrderManager(orderManagerAddress).finalizeOrder(
                projectAddress,
                escrowAddress,
                orderId
            );
            vm.stopPrank();
        }
    }

    function testUpgrade() public {
        RyzerFactory newImplementation = new RyzerFactory();
        vm.startPrank(deployer);
        RyzerFactory(address(ryzerFactory)).upgradeToAndCall(
            address(newImplementation),
            ""
        );
        vm.stopPrank();
    }
}
