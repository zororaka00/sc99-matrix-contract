pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "erc721a/contracts/extensions/IERC721AQueryable.sol";
import "./interfaces/InterfaceReward.sol";

contract RewardSC99 is UUPSUpgradeable, OwnableUpgradeable, ReentrancyGuardUpgradeable, InterfaceReward {
    IERC20 private tokenUSDC;
    IERC721AQueryable private nftReward;

    uint256 public versionCode;

    uint256 private constant basePriceNFT = 100e6;
    uint256 public treasury;
    uint256 public maxTokenId;
    uint256 public totalDistributeRewards;
    uint256 public claimableRewards;
    mapping(uint256 => uint256) public notClaimedRewards;
    mapping(uint256 => uint256) public claimedRewards;

    event DistributeReward(address indexed who, uint256 indexed amount);
    event WithdrawReward(address indexed who, uint256 indexed tokenId, uint256 indexed amount);

    function initialize(address _tokenUSDC, address _nftReward) public initializer {
        __Ownable_init();
        tokenUSDC = IERC20(_tokenUSDC);
        nftReward = IERC721AQueryable(_nftReward);
    }

    function _authorizeUpgrade(address) internal override onlyOwner {
        versionCode += 1;
    }

    function distributeReward(uint256 _amount) external nonReentrant {
        address who = _msgSender();
        tokenUSDC.transferFrom(who, address(this), _amount);

        uint256 currentMaxTokenId = nftReward.totalSupply();
        if (currentMaxTokenId > maxTokenId) {
            for (uint i = maxTokenId + 1; i <= currentMaxTokenId; i++) {
                notClaimedRewards[i] = claimableRewards;
            }
            maxTokenId = currentMaxTokenId;
            treasury = currentMaxTokenId * basePriceNFT;
        }

        totalDistributeRewards += _amount;
        claimableRewards += _amount * basePriceNFT / treasury;

        emit DistributeReward(who, _amount);
    }

    function claimableReward(uint256 _tokenId) public override view returns(uint256) {
        require(_tokenId > 0 && _tokenId <= maxTokenId, "Token Id is cannot claim reward");
        return claimableRewards - claimedRewards[_tokenId] - notClaimedRewards[_tokenId];
    }

    function claimReward(uint256 _tokenId) external override nonReentrant returns(uint256) {
        uint256 amount = claimableReward(_tokenId);
        if (amount > 0) {
            tokenUSDC.transfer(nftReward.ownerOf(_tokenId), amount);
            claimedRewards[_tokenId] += amount;
        }
        return amount;
    }

    function claimableRewardBatch(uint256[] memory _tokenIds) external override view returns(uint256[] memory) {
        uint256[] memory amounts = new uint256[](_tokenIds.length);
        for (uint i = 0; i < _tokenIds.length; i++) {
            require(_tokenIds[i] > 0 && _tokenIds[i] <= maxTokenId, "Token Id is cannot claim reward");
            amounts[i] = claimableRewards - claimedRewards[_tokenIds[i]] - notClaimedRewards[_tokenIds[i]];
        }
        return amounts;
    }

    function claimRewardBatch(uint256[] memory _tokenIds) external override nonReentrant returns(uint256[] memory) {
        uint256[] memory amounts = new uint256[](_tokenIds.length);
        uint256 currentClaimableRewards = claimableRewards;
        for (uint i = 0; i < _tokenIds.length; i++) {
            require(_tokenIds[i] > 0 && _tokenIds[i] <= maxTokenId, "Token Id is cannot claim reward");
            uint256 amount = currentClaimableRewards - claimedRewards[_tokenIds[i]] - notClaimedRewards[_tokenIds[i]];
            if (amount > 0) {
                tokenUSDC.transfer(nftReward.ownerOf(_tokenIds[i]), amount);
                claimedRewards[_tokenIds[i]] += amount;
            }
            amounts[i] = amount;
        }
        return amounts;
    }

    function claimableRewardFor(address _account) public override view returns(uint256) {
        uint256 totalAmount;
        uint256[] memory tokenIds = nftReward.tokensOfOwner(_account);
        if (tokenIds.length > 0) {
            for (uint i = 0; i < tokenIds.length; i++) {
                if (tokenIds[i] <= maxTokenId) {
                    totalAmount += claimableRewards - claimedRewards[tokenIds[i]] - notClaimedRewards[tokenIds[i]];
                }
            }
        }
        return totalAmount;
    }

    function claimRewardFor(address _account) external override nonReentrant returns(uint256) {
        uint256 totalAmount;
        uint256 currentClaimableRewards = claimableRewards;
        uint256[] memory tokenIds = nftReward.tokensOfOwner(_account);
        if (tokenIds.length > 0) {
            for (uint i = 0; i < tokenIds.length; i++) {
                if (tokenIds[i] <= maxTokenId) {
                    uint256 amount = currentClaimableRewards - claimedRewards[tokenIds[i]] - notClaimedRewards[tokenIds[i]];
                    if (amount > 0) {
                        claimedRewards[tokenIds[i]] += amount;
                        totalAmount += amount;
                    }
                }
            }
            if (totalAmount > 0) {
                tokenUSDC.transfer(_account, totalAmount);
            }
        }
        return totalAmount;
    }
}