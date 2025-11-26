//Licencia
// SPDX-License-Identifier: LGPL-3.0-only

//Version
pragma solidity 0.8.30;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";

contract CryptoReal is ERC20, ERC20Pausable, AccessControl {

    uint public immutable maxSupply;

    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    constructor(string memory name_, string memory symbol_, uint maxSupply_) ERC20(name_, symbol_) {
        _mint(msg.sender, 1000 * 10**decimals());
        maxSupply = maxSupply_;
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(BURNER_ROLE, msg.sender);

    }

    event burnToken(address indexed account, uint256 amount);
    event mintToken(address indexed account, uint256 amount);
    event burnerAdded(address indexed account);
    event PauserAdded(address indexed account);
    event burnerRemoved(address indexed account);
    event PauserRemoved(address indexed account);

    function mint(address to, uint amount) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(totalSupply() + amount <= maxSupply, "Max supply exceeded");
        _mint(to, amount);
        emit mintToken(to, amount);
    }

    function addBurner(address burner) external onlyRole(DEFAULT_ADMIN_ROLE) {
        grantRole(BURNER_ROLE, burner);
        emit burnerAdded(burner);
    }

    function removeBurner(address burner) external onlyRole(DEFAULT_ADMIN_ROLE) {
        revokeRole(BURNER_ROLE, burner);
        emit burnerRemoved(burner);
    }

    function addPauser(address pauser) external onlyRole(DEFAULT_ADMIN_ROLE) {
        grantRole(PAUSER_ROLE, pauser);
        emit PauserAdded(pauser);
    }

    function removePauser(address pauser) external onlyRole(DEFAULT_ADMIN_ROLE) {
        revokeRole(PAUSER_ROLE, pauser);
        emit PauserRemoved(pauser);
    }

    function burn(uint256 amount) external onlyRole(BURNER_ROLE) {
        _burn(msg.sender, amount);
        emit burnToken(msg.sender, amount);

    }    
    function pause() external onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() external onlyRole(PAUSER_ROLE) {
        _unpause();
    }
    function _update(address from, address to, uint256 amount) internal override(ERC20, ERC20Pausable) {
        super._update(from, to, amount);
    }

}