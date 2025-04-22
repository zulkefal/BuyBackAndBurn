# BuyBackAndBurn Contract

The `BuyBackAndBurn` contract is designed to facilitate token swaps and burning mechanisms using the Uniswap V3 protocol. It supports both single-hop and multi-hop swaps, allowing users to pay fees in tokens and burn the received tokens.

## Features

- **Multi-Hop Swaps**: Perform swaps across multiple pools (e.g., Token → WETH → Target Token).
- **Single-Hop Swaps**: Perform direct swaps between two tokens (e.g., Token → WETH).
- **Token Burning**: Automatically burns the received tokens after a swap.

---

## Functions

### `payFeeMultiHop(address _tokenAddress, uint256 _amount)`

Performs a multi-hop swap and burns the received tokens.

#### Parameters:
- `_tokenAddress`: The address of the token to be swapped.
- `_amount`: The amount of tokens to be swapped.

#### Workflow:
1. Approves the Uniswap V3 Swap Router to spend `_amount` of `_tokenAddress`.
2. Transfers `_amount` of `_tokenAddress` from the sender to the contract.
3. Encodes the swap path (e.g., Token → WETH → Target Token).
4. Executes the multi-hop swap using Uniswap's `exactInput` function.
5. Burns the received tokens using the `ERC20Burnable` interface.

---

### `payFeeSingleSwap(address _tokenAddress, uint256 _amount)`

Performs a single-hop swap and emits the received token balance.

#### Parameters:
- `_tokenAddress`: The address of the token to be swapped.
- `_amount`: The amount of tokens to be swapped.

#### Workflow:
1. Approves the Uniswap V3 Swap Router to spend `_amount` of `_tokenAddress`.
2. Transfers `_amount` of `_tokenAddress` from the sender to the contract.
3. Encodes the swap path (e.g., Token → WETH).
4. Emits the `TokenReceived` event with the received token balance.

---

## Events

### `TokenReceived(uint256 tokenReceived)`
Emitted when tokens are received after a swap.

---

## Constants

The contract relies on constants defined in the `Constants` contract:
- `SWAP_ROUTER`: Address of the Uniswap V3 Swap Router.
- `WETH_ADDRESS`: Address of the WETH token.
- `FEE_TIER_USDT_WETH`: Fee tier for the USDT-WETH pool.
- `FEE_TIER_RBOT_TOKEN`: Fee tier for the WETH-RBOT pool.
- `RBOT_TOKEN`: Address of the RBOT token.

---


## Security Considerations

- Ensure that the `Constants` contract is correctly configured with valid addresses and fee tiers.
- Only use trusted tokens and pools to avoid unexpected behavior.
- The contract assumes that the tokens being swapped are ERC20-compliant.

---


# Command for Running All Test Cases of Contracts
forge test --fork-url https://endpoints.omniatech.io/v1/arbitrum/one/public --match-contract BuyBackBurnTest -vvvvv

# Command for Testing Single Swap
forge test --fork-url https://endpoints.omniatech.io/v1/arbitrum/one/public --match-test testPaymentSentSingleSwap -vvvvv

# Command for Testing Multi Swap with Burning of Token
forge test --fork-url https://endpoints.omniatech.io/v1/arbitrum/one/public --match-test testPaymentSentMultiHop -vvvvv

