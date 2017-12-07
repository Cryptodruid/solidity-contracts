pragma solidity ^0.4.18;

import "samedir/ImmutableToken.sol";
import "ds-exec/exec.sol";

contract TokenSeller is DSExec {

    ImmutableToken public tokenContract;

    uint256 public token_price_discount;
    uint256 public token_price;
    uint public ico_end_timestamp;

    address public master;

    function TokenSeller(string name_, string symbol_, uint256 supply_, uint8 decimals_, uint256 price_discount_, uint256 price_, uint ico_end_) {

        master = msg.sender;

        token_price_discount = price_discount_;
        token_price = price_;
        ico_end_timestamp = ico_end_;

        tokenContract = new ImmutableToken(name_, symbol_, supply_, decimals_);
    }

    function masterWithdraw(uint256 _value) {
        require(msg.sender == master);
        require(tokenContract.balanceOf( address(this) ) >= _value);
        tokenContract.transfer(master, _value);
    }

    function() payable {
        uint256 current_price = now > ico_end_timestamp ? token_price : token_price_discount;
        require(msg.value >= current_price);

        uint256 tokensToTransfer = msg.value / current_price;
        tokenContract.transfer(msg.sender, tokensToTransfer);
        uint256 remainder = msg.value - (tokensToTransfer * current_price);
        uint256 masterAmount = msg.value;
        if(remainder > 0) {
            exec(msg.sender, remainder);
            masterAmount -= remainder;
        }
        exec(master, masterAmount);
    }
}