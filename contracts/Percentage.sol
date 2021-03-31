pragma solidity 0.6.12;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/access/Ownable.sol";

contract MyTestContract is Ownable {
    using SafeMath for uint256; // SafeMath
    address payable devaddr = 0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB;
    uint128 public marketFee = 200; // initial 2% fee in basis points (parts per 10,000)

    function calculateFee(uint256 _value) public view returns (uint256) {
        require((_value.mul(marketFee) >= 10000), "_value too small");
        return _value.mul(marketFee).div(10000);
    }

    function setMarketFee(uint128 _value) public onlyOwner {
        marketFee = _value;
    }

    function sendEther(address payable recipient)
        public
        payable
        returns (uint256)
    {
        uint256 fees = calculateFee(msg.value);
        recipient.transfer(msg.value.sub(fees));
        devaddr.transfer(fees);
    }

    function checkBalance() public view onlyOwner returns (uint256) {
        return address(this).balance;
    }
}
