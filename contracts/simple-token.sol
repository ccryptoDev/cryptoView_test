// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

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
    string internal baseURI = "https://gateway.pinata.cloud/ipfs/";
    // events
    event BaseURIChanged(string newURI);
    constructor() ERC721("SimpleNFT", "SNFT") {
        tokenCounter = 0;
    }

    /// @notice	Sets the Base URI for ALL tokens
	/// @dev	Can be overriden by the specific token URI
	/// @param	newURI	URI to be used
    function setBaseURI(string calldata newURI) public {
		baseURI = newURI;
		emit BaseURIChanged(newURI);
	}

    /// @notice	Overridden function from the ERC721 contract that returns our
	///	variable base URI instead of the hardcoded URI
	function _baseURI() internal view override(ERC721) returns (string memory) {
		return baseURI;
	}

    function createNFT(string memory name, string memory description, string memory imageURL) public returns (uint256) {
        uint256 newTokenId = tokenCounter;
        _safeMint(msg.sender, newTokenId);

        // Store metadata
        tokenIdToMetadata[newTokenId] = Metadata(name, description, imageURL);

        string memory __baseURI;
        __baseURI = _baseURI();

        string memory tokenURI = string(abi.encodePacked(__baseURI, imageURL));
        _setTokenURI(newTokenId, tokenURI);

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