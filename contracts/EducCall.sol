// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./protocols/bep/groww/IPancakeRouter.sol";

//without deploying contract you can call EDUCToken APIs using interfaces, using At address option
interface EducCallFactory{
    function totalSupply() external view returns (uint256);
    function balanceOf(address tokenOwner) external view returns (uint);
}

//By deploying contract you can call EDUCToken APIs
contract EducCall{
    IPancakeRouter02 public immutable pancakeRouter;
    address public immutable pancakePair;

    constructor (
        address payable routerAddress
    ) public {
       
        IPancakeRouter02 _pancakeRouter = IPancakeRouter02(routerAddress);
        // Create a pancake pair for this new token
        pancakePair = IPancakeFactory(_pancakeRouter.factory())
        .createPair(address(this), _pancakeRouter.WETH());

        // set the rest of the contract variables
        pancakeRouter = _pancakeRouter;
    }
    address private factory = 0x205F17e759ce99B562D21F606A3dEd0f50547EfF;
    function getTotalSupply() external view returns(uint256)
    { 
        uint totalSupply = EducCallFactory(factory).totalSupply();
        return totalSupply;
    }
    function getBalanceOf(address tokenOwner) external view returns (uint)
    {
        uint bal = EducCallFactory(factory).balanceOf(tokenOwner);
        return bal;
    }
    function getAmountsOut(address tokenaddr,uint256 amount) public view returns(uint256 amount1,uint256 amount2) {
        
        // generate the pancake pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = pancakeRouter.WETH();                         
        path[1] = address(tokenaddr);

        // fetch current rate
        uint[] memory amounts =  pancakeRouter.getAmountsOut(amount,path);
        return (amounts[0],amounts[1]);
    }
    function getAmountsIn(address tokenaddr,uint256 amount) public view returns(uint256 amount1,uint256 amount2) {
        
        // generate the pancake pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = pancakeRouter.WETH();                         
        path[1] = address(tokenaddr);

        // fetch current rate
        uint[] memory amounts =  pancakeRouter.getAmountsIn(amount,path);
        return (amounts[0],amounts[1]);
    }
    /*
    function bytesToString(bytes memory byteCode) public pure returns(string memory stringData)
    {
        uint256 blank = 0; //blank 32 byte value
        uint256 length = byteCode.length;

        uint cycles = byteCode.length / 0x20;
        uint requiredAlloc = length;

        if (length % 0x20 > 0) //optimise copying the final part of the bytes - to avoid looping with single byte writes
        {
            cycles++;
            requiredAlloc += 0x20; //expand memory to allow end blank, so we don't smack the next stack entry
        }

        stringData = new string(requiredAlloc);

        //copy data in 32 byte blocks
        assembly {
            let cycle := 0

            for
            {
                let mc := add(stringData, 0x20) //pointer into bytes we're writing to
                let cc := add(byteCode, 0x20)   //pointer to where we're reading from
            } lt(cycle, cycles) {
                mc := add(mc, 0x20)
                cc := add(cc, 0x20)
                cycle := add(cycle, 0x01)
            } {
                mstore(mc, mload(cc))
            }
        }

        //finally blank final bytes and shrink size (part of the optimisation to avoid looping adding blank bytes1)
        if (length % 0x20 > 0)
        {
            uint offsetStart = 0x20 + length;
            assembly
            {
                let mc := add(stringData, offsetStart)
                mstore(mc, mload(add(blank, 0x20)))
                //now shrink the memory back so the returned object is the correct size
                mstore(stringData, length)
            }
        }
    }
    function convertingToString()public returns(string){
        bytes32  hw = "Hello World";
        string  converted = string(hw);
        return converted;
    }
   */
}
