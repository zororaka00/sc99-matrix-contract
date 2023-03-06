pragma solidity ^0.8.0;

interface InterfaceReward {
    function reward(uint256) external returns (uint256);
    function claimableReward(uint256) external view returns (uint256);
    function rewardBatch(uint256[] memory) external returns (uint256);
    function claimableRewardBatch(uint256[] memory) external view returns (uint256);
    function rewardFor(address) external returns (uint256);
    function claimableRewardFor(address) external view returns (uint256);
}