const NTF_CONTRACT = artifacts.require("Horus");

contract("MetaCoin", ([alice, bob, owner]) => {
    before(async () =>{
        this.NTF = await NTF_CONTRACT.new({from:owner});
    })
    it("check owner is set carrectly", async () => {
        assert.equal(await this.NTF.owner(), owner);
    })
})