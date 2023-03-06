pragma solidity ^0.8.0;

interface InterfaceReward {
    function claimableReward(uint256) external view returns (uint256);
    function claimReward(uint256) external returns (uint256);
    function claimableRewardBatch(uint256[] memory) external view returns (uint256);
    function claimRewardBatch(uint256[] memory) external returns (uint256);
    function claimableRewardFor(address) external view returns (uint256);
    function claimRewardFor(address) external returns (uint256);
}