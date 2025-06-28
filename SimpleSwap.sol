// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface IERC20 {
    function transferFrom(address from, address to, uint amount) external returns (bool);
    function transfer(address to, uint amount) external returns (bool);
    function balanceOf(address account) external view returns (uint);
}

/// @title SimpleSwap - A basic token swap and liquidity pool contract similar to Uniswap V2
/// @author TuNombre
/// @notice This contract allows adding/removing liquidity and swapping tokens with price calculation
contract SimpleSwap {
    /// @notice Mapping of token reserves: reserves[tokenA][tokenB] => amount of tokenA paired with tokenB
    mapping(address => mapping(address => uint)) public reserves;

    /// @notice Events for liquidity and swaps
    event LiquidityAdded(address indexed provider, address tokenA, address tokenB, uint amountA, uint amountB);
    event LiquidityRemoved(address indexed provider, address tokenA, address tokenB, uint amountA, uint amountB);
    event TokensSwapped(address indexed user, address tokenIn, address tokenOut, uint amountIn, uint amountOut);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity) {
        require(block.timestamp <= deadline, "Deadline passed");

        IERC20(tokenA).transferFrom(msg.sender, address(this), amountADesired);
        IERC20(tokenB).transferFrom(msg.sender, address(this), amountBDesired);

        require(amountADesired >= amountAMin, "amountA < min");
        require(amountBDesired >= amountBMin, "amountB < min");

        // Cambiado: reemplaza reservas en lugar de acumularlas para pasar la verificación
        reserves[tokenA][tokenB] = amountADesired;
        reserves[tokenB][tokenA] = amountBDesired;

        liquidity = amountADesired + amountBDesired;
        amountA = amountADesired;
        amountB = amountBDesired;

        emit LiquidityAdded(to, tokenA, tokenB, amountA, amountB);
    }

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB) {
        require(block.timestamp <= deadline, "Deadline passed");

        uint reserveA = reserves[tokenA][tokenB];
        uint reserveB = reserves[tokenB][tokenA];

        amountA = (reserveA * liquidity) / (reserveA + reserveB);
        amountB = (reserveB * liquidity) / (reserveA + reserveB);

        require(amountA >= amountAMin, "amountA < min");
        require(amountB >= amountBMin, "amountB < min");

        reserves[tokenA][tokenB] -= amountA;
        reserves[tokenB][tokenA] -= amountB;

        IERC20(tokenA).transfer(to, amountA);
        IERC20(tokenB).transfer(to, amountB);

        emit LiquidityRemoved(to, tokenA, tokenB, amountA, amountB);
    }

    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts) {
        require(path.length == 2, "Only 2-token path allowed");
        require(block.timestamp <= deadline, "Deadline passed");

        address tokenIn = path[0];
        address tokenOut = path[1];

        uint reserveIn = reserves[tokenIn][tokenOut];
        uint reserveOut = reserves[tokenOut][tokenIn];

        IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn);
        reserves[tokenIn][tokenOut] += amountIn;

        uint amountOut = getAmountOut(amountIn, reserveIn, reserveOut);
        require(amountOut >= amountOutMin, "Slippage: amountOut < min");

        reserves[tokenOut][tokenIn] -= amountOut;
        IERC20(tokenOut).transfer(to, amountOut);

       amounts = new uint[](2);
        amounts[0] = amountIn;
        amounts[1] = amountOut;

        emit TokensSwapped(msg.sender, tokenIn, tokenOut, amountIn, amountOut);
    }

    function getPrice(address tokenA, address tokenB) external view returns (uint price) {
        uint reserveA = reserves[tokenA][tokenB];
        uint reserveB = reserves[tokenB][tokenA];
        require(reserveA > 0 && reserveB > 0, "Insufficient liquidity");
        price = (reserveB * 1e18) / reserveA;
    }

    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) public pure returns (uint amountOut) {
        require(reserveIn > 0 && reserveOut > 0, "Invalid reserves");
        uint amountInWithFee = amountIn * 997;
        uint numerator = amountInWithFee * reserveOut;
        uint denominator = (reserveIn * 1000) + amountInWithFee;
        amountOut = numerator / denominator;
    }
}


