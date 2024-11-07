// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import OpenZeppelin's ERC721 implementation
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract HaikuNFT is ERC721 {
    // Define Haiku struct
    struct Haiku {
        address author;
        string line1;
        string line2;
        string line3;
    }

    // Public array to store Haikus
    Haiku[] public haikus;

    // Public mapping to relate shared Haikus
    mapping(address => uint256[]) public sharedHaikus;

    // Public counter for Haiku IDs (starts from 1)
    uint256 public counter = 1;

    // Mapping to track used lines
    mapping(bytes32 => bool) private usedLines;

    // Custom errors
    error HaikuNotUnique();
    error NotYourHaiku(uint256 haikuId);
    error NoHaikusShared();

    // Constructor
    constructor() ERC721("HaikuNFT", "HAIKU") {}

    // Mint Haiku function
    function mintHaiku(
        string calldata line1,
        string calldata line2,
        string calldata line3
    ) external {
        // Hash the lines to check for uniqueness
        bytes32 hashLine1 = keccak256(bytes(line1));
        bytes32 hashLine2 = keccak256(bytes(line2));
        bytes32 hashLine3 = keccak256(bytes(line3));

        // Check if any line has been used before
        if (usedLines[hashLine1] || usedLines[hashLine2] || usedLines[hashLine3]) {
            revert HaikuNotUnique();
        }

        // Mark lines as used
        usedLines[hashLine1] = true;
        usedLines[hashLine2] = true;
        usedLines[hashLine3] = true;

        // Save the Haiku
        haikus.push(Haiku(msg.sender, line1, line2, line3));

        // Mint the NFT to the minter with token ID equal to counter
        _mint(msg.sender, counter);

        // Increment the counter for the next ID
        counter++;
    }

    // Share Haiku function
    function shareHaiku(uint256 haikuId, address _to) public {
        // Check if the sender is the owner of the Haiku
        if (ownerOf(haikuId) != msg.sender) {
            revert NotYourHaiku(haikuId);
        }

        // Add the haikuId to the recipient's sharedHaikus
        sharedHaikus[_to].push(haikuId);
    }

    // Get Your Shared Haikus function
    function getMySharedHaikus() public view returns (Haiku[] memory) {
        uint256[] storage haikuIds = sharedHaikus[msg.sender];
        if (haikuIds.length == 0) {
            revert NoHaikusShared();
        }

        Haiku[] memory myHaikus = new Haiku[](haikuIds.length);
        for (uint256 i = 0; i < haikuIds.length; i++) {
            uint256 haikuIndex = haikuIds[i] - 1; // Adjust for zero-based array
            myHaikus[i] = haikus[haikuIndex];
        }
        return myHaikus;
    }
}
