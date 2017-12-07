CryptoDruid Solidity contracts
==============================

All the ERC20 tokens and seller contracts deployed by CryptoDruid are instances of these two contracts.
TokenSeller creates an ImmutableToken instance on creation, and governs the distribution of tokens in exchange of ETH.
Tokens are immutable, meaning that they can not be minted or burnt.
The seller sells tokens with a discount until the ICO end date is met (for CryptoDruid contracts this date is 2018-02-01 00:00:00 GMT).
