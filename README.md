# **Automated Market Maker (AMM) with Dynamic Fee Adjustment | Solidity | ERC-20 | DeFi**

## **Project Overview**

The **Automated Market Maker (AMM) with Dynamic Fee Adjustment** is an innovative decentralized finance (DeFi) project built on the Ethereum blockchain. It enhances the traditional AMM model, such as those seen in platforms like Uniswap, by introducing a **dynamic fee adjustment mechanism**. This feature allows the smart contract to automatically adjust trading fees in response to liquidity levels in the pool, helping balance liquidity provider incentives and trader costs while also protecting the pool from potential exploits, such as liquidity draining and flash loan attacks.

This project is developed in **Solidity** and deployed using **Remix IDE**, focusing purely on the back-end smart contract logic without reliance on front-end integration.

## **Description**

An Automated Market Maker (AMM) allows users to trade assets directly through smart contracts rather than relying on a traditional order book used in centralized exchanges. It enables liquidity providers (LPs) to deposit pairs of tokens into a pool, and traders can swap tokens from the pool, with prices determined by the constant product formula.

The **AMM with Dynamic Fee Adjustment** brings a critical improvement over traditional AMMs. While most AMMs apply a flat fee (usually 0.3%), this project adjusts fees dynamically based on the pool's liquidity. When liquidity decreases, fees increase to dissuade further draining of the pool and protect liquidity providers. When liquidity is high, fees remain low, encouraging more trading activity.

### **Key Features**

1. **Dynamic Fee Algorithm:**
   - **Dynamic Fee Adjustment:** Trading fees adjust automatically based on the liquidity levels in the pool. Lower liquidity results in higher fees, while higher liquidity leads to lower fees.
   - **Base Fee and Max Fee:** The contract starts with a base fee (e.g., 0.3%) and adjusts up to a maximum cap (e.g., 1%) depending on the current liquidity.

2. **Liquidity Provision and Removal:**
   - **Provide Liquidity:** Liquidity providers (LPs) can deposit equal amounts of two ERC-20 tokens to earn fees from traders.
   - **Remove Liquidity:** LPs can withdraw their tokens from the pool, receiving their share of the pool's reserves based on their liquidity token holdings.

3. **Token Swaps:**
   - Users can swap between two tokens in the liquidity pool. The price is automatically adjusted based on the reserves of the tokens in the pool, following the **constant product formula (x * y = k)**, where `x` and `y` are the reserve balances, and `k` is a constant.

4. **Security Features:**
   - The dynamic fee adjustment helps safeguard the pool from liquidity draining attacks and incentivizes LPs to keep their tokens in the pool when liquidity is low.
   - Basic protections against common DeFi vulnerabilities like flash loan attacks and reentrancy are incorporated.

5. **Minimal Gas Costs and Gas Efficiency:**
   - Gas-efficient code has been implemented for key operations, ensuring that trades, liquidity provision, and fee adjustments incur as low costs as possible while maintaining robust security.

## **Explanation**

### **How It Works**

1. **Liquidity Provision:**
   - Users provide liquidity to the pool by depositing equal amounts of `tokenA` and `tokenB`. In return, they receive liquidity tokens that represent their share of the pool. These liquidity tokens can later be redeemed for the underlying tokens when the user wishes to withdraw their liquidity.

2. **Token Swaps:**
   - Traders can swap between the two tokens in the pool. The price for each swap is calculated using the constant product formula. As trades happen, the price changes dynamically based on the ratio of the tokens in the pool. A fee is charged on each trade, and this fee is distributed to the liquidity providers as a reward.

3. **Dynamic Fee Adjustment:**
   - After each trade, the contract automatically recalculates the fee based on the pool's liquidity. If the liquidity drops below a certain threshold, the fee increases to protect the pool from being drained. The base fee and maximum fee ensure that fees never drop below or rise above set limits.
   - **Example:** When liquidity is high, the fee is low (e.g., 0.3%). If liquidity drops (i.e., tokens are being withdrawn or the pool is being drained), the fee rises to as high as 1% to discourage further depletion.

4. **Security Considerations:**
   - Dynamic fees act as a deterrent to liquidity-draining attacks. As liquidity decreases, the higher fees make it more costly for attackers to drain the pool.
   - By adjusting fees in response to market conditions, the AMM can dynamically adapt to protect liquidity providers and maintain a stable pool of assets.

### **Contract Structure**

- **provideLiquidity**: Adds tokens to the pool and issues liquidity tokens to the provider.
- **removeLiquidity**: Withdraws tokens from the pool based on the user's share of the total liquidity.
- **swapTokens**: Swaps one token for the other based on the current reserves, deducting a dynamic fee based on the current liquidity levels.
- **getAmountOut**: Calculates the amount of tokens that will be received in exchange for an input amount based on the reserves and the fee.
- **updateFee**: Adjusts the fee based on liquidity levels, ensuring the contract adapts to real-time conditions.
- **getCurrentFee**: Returns the current fee to be applied on a trade, providing transparency to traders.
  
## **Value Proposition and Problem Solved**

### **Problems Addressed**

1. **Fixed Fees Are Inefficient for Liquidity Providers:**
   - Traditional AMMs use a fixed fee (e.g., Uniswap’s 0.3%), which doesn’t adapt to market conditions. In cases of low liquidity, this static fee structure leaves the pool vulnerable to being drained by large trades, reducing the returns for liquidity providers.
   - **Solution:** By dynamically adjusting fees, this AMM better protects the pool when liquidity is low and incentivizes traders when liquidity is high.

2. **Imbalance in Trader and Provider Incentives:**
   - High trading volumes in traditional AMMs can drain liquidity from the pool without adequately compensating liquidity providers, especially in volatile markets.
   - **Solution:** The dynamic fee mechanism compensates liquidity providers by charging higher fees when liquidity is low, thus increasing their returns and maintaining a healthier balance between traders and liquidity providers.

3. **Vulnerability to Flash Loan Attacks:**
   - DeFi platforms are often vulnerable to flash loan attacks, where an attacker manipulates the pool in a single transaction to gain profit and leave the pool drained.
   - **Solution:** The dynamic fee structure increases fees in situations where liquidity drops suddenly, protecting the pool from drastic drains caused by large, rapid transactions like flash loans.

### **Value to Users**

1. **For Liquidity Providers:**
   - **Increased Earnings:** The dynamic fee structure ensures that liquidity providers are rewarded with higher fees during periods of low liquidity, making it more profitable to stay in the pool.
   - **Security:** The system protects against attacks that aim to drain the pool, ensuring that liquidity providers don’t suffer large losses due to market manipulation or sudden liquidity exits.

2. **For Traders:**
   - **Fair Pricing:** Traders enjoy lower fees during times of high liquidity, encouraging trading activity and providing a fairer system compared to traditional AMMs with fixed fees.
   - **Transparency:** Traders can easily query the current fee before making a trade, giving them more control over their costs.

3. **For DeFi Ecosystem:**
   - **Sustainable AMM Model:** The dynamic fee adjustment model introduces a new standard for AMMs, ensuring a sustainable, secure, and balanced system that benefits both liquidity providers and traders.
   - **Innovation in DeFi Security:** This project showcases how smart contracts can automatically adjust based on market conditions, adding a layer of self-regulation and security.

## **Contributing

- Fork the repository.
- Create a new branch (git checkout -b feature-branch).
- Make your changes and commit them (git commit -m "Add new feature").
- Push to the branch (git push origin feature-branch).
- Open a Pull Request.

## *License*

This project is licensed under the MIT License. You are free to use, modify, and distribute the code as long as you include the original license file.

## *Connect and Collaborate*

I invite you to connect with me to discuss blockchain development, smart contract security, and decentralized finance (DeFi). Explore additional projects and insights through the following channels

- LinkedIn: https://www.linkedin.com/in/ifzsheikh/

- Website: www.sheikhfaizan.com


## **Installation and Setup**

### **1. Clone the Repository**
   ```bash
   git clone https://github.com/yourusername/Automated-Market-Maker-Dynamic-Fee-Adjustment.git
   cd Automated-Market-Maker-Dynamic-Fee-Adjustment
