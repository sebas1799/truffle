const TOKEN_CONTRACT = artifacts.require("Horus");
const NFT_CONTRACT = artifacts.require("Leno");

const { assert } = require('chai')
const { expectEvent, expectRevert, time, BN } = require('@openzeppelin/test-helpers');

contract("Leno", ([alice, bob, owner]) => {
    
    const byOwner = { from: owner };

    before(async () =>{
        this.TOKEN = await TOKEN_CONTRACT.new({from:owner});
        this.NFT = await NFT_CONTRACT.new(this.TOKEN.address, {from:owner});
    })
    it("check owner is set carrectly", async () => {
        assert.equal(await this.TOKEN.owner(), owner);
        assert.equal(await this.NFT.owner(), owner);
    })
    it("check token price and rebate", async () => {
        assert.equal(await this.NFT.tokenPrice(), 10);
        assert.equal(await this.NFT.rebate(), 15);
    })
    it("Owner change the tokenPrice and rebate", async() =>{
        await expectRevert(this.NFT.newTokenPrice(7, {from:alice}), "Ownable: caller is not the owner");
        await expectRevert(this.NFT.newRebate(15, {from:alice}), "Ownable: caller is not the owner");
    })
    it("Deposit to staking", async () =>{
        await this.TOKEN.mint(owner, 10000, {from:owner});
        await this.TOKEN.deposit(100, {from:owner});
        assert.equal(await this.TOKEN.balanceOf(owner), 9900);
    })
    it("Recive rewards", async () =>{
        const getRewardsRecive = this.TOKEN.getRewards(1241);
        expectEvent(getRewardsRecive, "Reward Paid", {
            staker: owner,
            amount:1241
        })
    })
});