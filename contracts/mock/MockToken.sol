// solhint-disable
pragma solidity 0.5.8;

contract MockToken {
    string public name     = "Mock Token";
    string public symbol   = "MOT";
    uint8  public decimals = 18;
    uint256 public totalSupply = (10**24);

    event  Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event  Transfer(address indexed _from, address indexed _to, uint256 _value);

    mapping (address => uint256)                       public  balanceOf;
    mapping (address => mapping (address => uint256))  public  allowance;

    constructor() public {
        balanceOf[msg.sender] = totalSupply;
    }

    function approve(address guy, uint256 wad) public returns (bool) {
        allowance[msg.sender][guy] = wad;
        emit Approval(msg.sender, guy, wad);
        return true;
    }

    function transfer(address dst, uint256 wad) public returns (bool) {
        return transferFrom(msg.sender, dst, wad);
    }

    function transferFrom(address src, address dst, uint256 wad)
        public
        returns (bool)
    {
        require(balanceOf[src] >= wad);

        if (src != msg.sender && allowance[src][msg.sender] != uint256(-1)) {
            require(allowance[src][msg.sender] >= wad);
            allowance[src][msg.sender] -= wad;
        }

        balanceOf[src] -= wad;
        balanceOf[dst] += wad;

        emit Transfer(src, dst, wad);

        return true;
    }
}
