// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DynamicFeeAMM is Ownable {
    IERC20 public tokenA;
    IERC20 public tokenB;

    uint256 public reserveA;
    uint256 public reserveB;

    uint256 public constant MINIMUM_LIQUIDITY = 10**3;
    uint256 public totalLiquidity;

    mapping(address => uint256) public liquidity;

    uint256 public baseFee = 30; // 0.3% initial fee (30 basis points)
    uint256 public maxFee = 100; // 1% maximum fee (100 basis points)

    event LiquidityProvided(address indexed provider, uint256 tokenAAmount, uint256 tokenBAmount);
    event LiquidityRemoved(address indexed provider, uint256 tokenAAmount, uint256 tokenBAmount);
    event TokensSwapped(address indexed swapper, address tokenIn, uint256 amountIn, uint256 amountOut);
    event FeeUpdated(uint256 newFee);

    // Pass the initial owner address to the Ownable constructor
    constructor(address _tokenA, address _tokenB, address initialOwner) Ownable(initialOwner) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    // Provide liquidity to the pool
    function provideLiquidity(uint256 amountA, uint256 amountB) external {
        require(amountA > 0 && amountB > 0, "Amounts must be greater than zero");

        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transferFrom(msg.sender, address(this), amountB);

        uint256 liquidityMinted = calculateLiquidityMinted(amountA, amountB);
        liquidity[msg.sender] += liquidityMinted;
        totalLiquidity += liquidityMinted;

        reserveA += amountA;
        reserveB += amountB;

        emit LiquidityProvided(msg.sender, amountA, amountB);
    }

    // Remove liquidity from the pool
    function removeLiquidity(uint256 liquidityAmount) external {
        require(liquidity[msg.sender] >= liquidityAmount, "Insufficient liquidity");

        uint256 amountA = (liquidityAmount * reserveA) / totalLiquidity;
        uint256 amountB = (liquidityAmount * reserveB) / totalLiquidity;

        liquidity[msg.sender] -= liquidityAmount;
        totalLiquidity -= liquidityAmount;

        reserveA -= amountA;
        reserveB -= amountB;

        tokenA.transfer(msg.sender, amountA);
        tokenB.transfer(msg.sender, amountB);

        emit LiquidityRemoved(msg.sender, amountA, amountB);
    }

    // Swap tokens using the AMM
    function swapTokens(address tokenIn, uint256 amountIn) external {
        require(tokenIn == address(tokenA) || tokenIn == address(tokenB), "Invalid token");

        bool isTokenA = tokenIn == address(tokenA);
        (uint256 reserveIn, uint256 reserveOut) = isTokenA ? (reserveA, reserveB) : (reserveB, reserveA);

        uint256 amountOut = getAmountOut(amountIn, reserveIn, reserveOut);

        // Update reserves
        if (isTokenA) {
            reserveA += amountIn;
            reserveB -= amountOut;
        } else {
            reserveB += amountIn;
            reserveA -= amountOut;
        }

        IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn);
        IERC20(isTokenA ? tokenB : tokenA).transfer(msg.sender, amountOut);

        emit TokensSwapped(msg.sender, tokenIn, amountIn, amountOut);

        // Update the fee based on new liquidity
        updateFee();
    }

    // Get the amount of output tokens
    function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) public view returns (uint256) {
        uint256 fee = getCurrentFee();
        uint256 amountInWithFee = amountIn * (10000 - fee);
        uint256 numerator = amountInWithFee * reserveOut;
        uint256 denominator = (reserveIn * 10000) + amountInWithFee;
        return numerator / denominator;
    }

    // Calculate the liquidity minted when providing liquidity
    function calculateLiquidityMinted(uint256 amountA, uint256 amountB) public view returns (uint256) {
        if (totalLiquidity == 0) {
            return sqrt(amountA * amountB) - MINIMUM_LIQUIDITY;
        } else {
            return min((amountA * totalLiquidity) / reserveA, (amountB * totalLiquidity) / reserveB);
        }
    }

    // Update the dynamic fee based on the current liquidity in the pool
    function updateFee() internal {
        uint256 currentLiquidity = reserveA + reserveB;
        uint256 newFee = baseFee;

        if (currentLiquidity < 10000 ether) {
            newFee = baseFee + ((10000 ether - currentLiquidity) / 100 ether);
        }

        if (newFee > maxFee) {
            newFee = maxFee;
        }

        emit FeeUpdated(newFee);
    }

    // Get the current fee
    function getCurrentFee() public view returns (uint256) {
        uint256 currentLiquidity = reserveA + reserveB;
        uint256 dynamicFee = baseFee;

        if (currentLiquidity < 10000 ether) {
            dynamicFee = baseFee + ((10000 ether - currentLiquidity) / 100 ether);
        }

        return dynamicFee > maxFee ? maxFee : dynamicFee;
    }

    // Utility functions
    function sqrt(uint256 x) internal pure returns (uint256) {
        uint256 z = (x + 1) / 2;
        uint256 y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
        return y;
    }

    function min(uint256 x, uint256 y) internal pure returns (uint256) {
        return x < y ? x : y;
    }
}
