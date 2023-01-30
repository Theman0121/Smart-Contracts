// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "@thirdweb-dev/contracts/base/ERC721Drop.sol";
import "@thirdweb-dev/contracts/signature-drop/SignatureDrop.sol";


contract BurnToMint is ERC721Drop {
    // Store constant values for the NFT Collection:
    SignatureDrop public immutable stik;

    constructor(
        string memory _name,
        string memory _symbol,
        address _royaltyRecipient,
        uint128 _royaltyBps,
        address _stikAddress
    ) ERC721Drop(_name, _symbol, _royaltyRecipient, _royaltyBps) {
        stik = SignatureDrop(_stikAddress);
    }

     function verifyClaim(address _claimer, uint256 _quantity)
        public
        view
        virtual
        override
    {
        // 1. Override the claim function to ensure a few things:
        // - They own an NFT from the SignatureMint contract
        require(stik.balanceOf(_claimer) >= _quantity, "You don't own enough STIK NFTs");
    }

function _transferTokensOnClaim(address _receiver, uint256 _quantity) internal override returns(uint256) {
        // Burn the STIK as part of the claim
        stik.burn(
            _receiver,
            0,
            _quantity
        );
        
       // Use the rest of the inherited claim function logic
      return super._transferTokensOnClaim(_receiver, _quantity);
    }
}
