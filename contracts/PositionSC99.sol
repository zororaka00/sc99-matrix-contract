pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/IRouterPlugin.sol";
import "./interfaces/IPositionRouter.sol";

contract PositionSC99 is UUPSUpgradeable, OwnableUpgradeable {
    IERC20 private tokenUSDC;
    IRouterPlugin private routerPlugin;
    IPositionRouter private positionRouter;

    uint256 public versionCode;

    // USDC Contract: https://optimistic.etherscan.io/token/0x7f5c764cbc14f9669b88837ca1490cca17c31607
    // Router Plugin Contract: https://optimistic.etherscan.io/address/0x68d1ca32aee9a73534429d8376743bf222ff1870
    // Position Router Contract: https://optimistic.etherscan.io/address/0xc5129208cb1dc2b3c916011c9d94632e602b9811
    function initialize(address _tokenUSDC, address _routerPlugin, address _positionRouter) public initializer {
        __Ownable_init();
        tokenUSDC = IERC20(_tokenUSDC);
        routerPlugin = IRouterPlugin(_routerPlugin);
        positionRouter = IPositionRouter(_positionRouter);
    }

    function _authorizeUpgrade(address) internal override onlyOwner {
        versionCode += 1;
    }
}