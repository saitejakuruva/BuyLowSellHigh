pragma solidity 0.5.8;
import "@openzeppelin/contracts/math/SafeMath.sol";


library Utils {
    using SafeMath for uint256;
    function changePrecision(uint256 _value, uint256 _actualDecimals, uint256 _desiredDecimals)
        public
        pure
        returns(uint256)
    {
        return _value.mul(10**(_desiredDecimals - _actualDecimals));
    }
    
}