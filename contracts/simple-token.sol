// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SimpleNFT is ERC721URIStorage, Ownable {
    uint256 public tokenCounter;

    struct Metadata {
        string name;
        string description;
        string imageURL;
    }

    // Mapping from token ID to metadata
    mapping(uint256 => Metadata) private tokenIdToMetadata;

    constructor() ERC721("SimpleNFT", "SNFT") {
        tokenCounter = 0;
    }

    function createNFT(string memory name, string memory description, string memory imageURL) public returns (uint256) {
        uint256 newTokenId = tokenCounter;
        _safeMint(msg.sender, newTokenId);

        // Store metadata
        tokenIdToMetadata[newTokenId] = Metadata(name, description, imageURL);

        // Set token URI to be just the IPFS hash or a simple identifier, not the full URL
        _setTokenURI(newTokenId, imageURL);  // Store only the hash or imageURL identifier

        tokenCounter += 1;
        return newTokenId;
    }

    // Function to retrieve metadata by token ID
    function getTokenMetadata(uint256 tokenId) public view returns (string memory name, string memory description, string memory imageURL) {
        require(_exists(tokenId), "Token ID does not exist");
        Metadata memory metadata = tokenIdToMetadata[tokenId];
        return (metadata.name, metadata.description, metadata.imageURL);
    }
}
