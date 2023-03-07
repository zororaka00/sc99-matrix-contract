pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "erc721a/contracts/extensions/ERC721AQueryable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/InterfaceReward.sol";

contract NFTRewardSC99 is Ownable, ReentrancyGuard, ERC721AQueryable {
    IERC20 private tokenUSDC;
    InterfaceReward private proxyReward;

    string private defaultURI;
    uint256 public constant MAX_SUPPLY = 5000; // Max Supply 5.000 NFT
    uint256 public constant price = 100e6;
    address public receivedAddress;

    constructor(address _addressUSDC, address _receivedAddress) ERC721A("NFT Reward SC99", "NFTRewardSC99") {
        tokenUSDC = IERC20(_addressUSDC);
        receivedAddress = _receivedAddress;
    }

    function updateProxyReward(address _proxyReward) external onlyOwner {
        proxyReward = InterfaceReward(_proxyReward);
    }

    function updateBaseURI(string memory _defaultURI) external onlyOwner {
        defaultURI = _defaultURI;
    }

    function updateReceivedAddress(address _receivedAddress) external onlyOwner {
        receivedAddress = _receivedAddress;
    }

    function _startTokenId() internal override view virtual returns (uint256) {
        return 1;
    }

    function _baseURI() internal override view virtual returns (string memory) {
        return defaultURI;
    }

    function mint(uint256 quantity) external nonReentrant {
        require(quantity > 0, "Min quantity is 1");
        require(quantity <= 10, "Max quantity is 10");
        require(totalSupply() + quantity <= MAX_SUPPLY, "Max minted is 5.000 NFT");

        address who = _msgSender();
        uint256 totalPrice = price * quantity;
        tokenUSDC.transferFrom(who, receivedAddress, totalPrice);

        _mint(who, quantity);
    }

    function claimableReward(uint256 _tokenId) external view returns(uint256) {
        uint256 result = proxyReward.claimableReward(_tokenId);
        return result;
    }

    function claimReward(uint256 _tokenId) external returns(uint256) {
        uint256 result = proxyReward.claimReward(_tokenId);
        return result;
    }

    function claimableRewardBatch(uint256[] memory _tokenIds) external view returns(uint256[] memory) {
        uint256[] memory result = proxyReward.claimableRewardBatch(_tokenIds);
        return result;
    }

    function claimRewardBatch(uint256[] memory _tokenIds) external returns(uint256[] memory) {
        uint256[] memory result = proxyReward.claimRewardBatch(_tokenIds);
        return result;
    }

    function claimableRewardFor(address _account) external view returns(uint256) {
        uint256 result = proxyReward.claimableRewardFor(_account);
        return result;
    }

    function claimRewardFor(address _account) external returns(uint256) {
        uint256 result = proxyReward.claimRewardFor(_account);
        return result;
    }
}