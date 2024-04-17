// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract AIModelVerification is ERC721URIStorage {
    uint256 private _tokenIdCounter;

    // Struct for token metadata
    struct TokenMetadata {
        string ipfs_hash;
        string model_hash;
        string name;
        string description;
        address parent;
    }

    // Mapping from token ID to metadata
    mapping(uint256 => TokenMetadata) private _tokenMetadata;

    constructor(string memory baseURI) ERC721("AI Model Verification", "AMV") {
        _setBaseURI(baseURI);
    }

    // Function to mint a new token
    function mintToken(
        address to,
        string memory ipfs_hash,
        string memory model_hash,
        string memory name,
        string memory description,
        address parent
    ) external returns (uint256) {
        _tokenIdCounter++;
        uint256 newTokenId = _tokenIdCounter;

        _mint(to, newTokenId);
        _setTokenURI(newTokenId, string(abi.encodePacked(ipfs_hash, model_hash, name, description, parent)));

        _tokenMetadata[newTokenId] = TokenMetadata({
            ipfs_hash: ipfs_hash,
            model_hash: model_hash,
            name: name,
            description: description,
            parent: parent
        });

        return newTokenId;
    }

    // Function to check if token exists
    function tokenExists(uint256 tokenId) public view returns (bool) {
        return _exists(tokenId);
    }

    // Function to get token metadata
    function getTokenMetadata(uint256 tokenId)
        external
        view
        returns (
            string memory,
            string memory,
            string memory,
            string memory,
            address
        )
    {
        require(tokenExists(tokenId), "Token does not exist");
        TokenMetadata memory metadata = _tokenMetadata[tokenId];
        return (metadata.ipfs_hash, metadata.model_hash, metadata.name, metadata.description, metadata.parent);
    }
}