# Referral-Token Built with 🏗 Scaffold-ETH 2

<h4 align="center">
  <a href="https://docs.scaffoldeth.io">Documentation</a> |
  <a href="https://scaffoldeth.io">Website</a>
</h4>

This is a basic demo for a smart contract that rewards users with an ERC20 Token for referring other users. Smart contract can be easily adapted to reward users for custom events

To run locally, first clone repository.

Then install packages using

```
yarn install
```

Then deploy local chain using

```
yarn chain
```

in a new terminal run

```
yarn deploy
```

Finally, spin up frontend by running

```
yarn start
```

You should now be able to go to localhost:3000 and see the project. Click on "debug" tab to interact with smart contract and click on "Referrals" to see referrals (surprise surprise) and the rewards collected for referrals.

> [!TIP]
> To make testing easier, go to Referral.sol and find the constructor. Replace Ownable(msg.sender) with Ownable(yourWalletAddress)
