const {
    BN
} = require('openzeppelin-test-helpers');
const { expect } = require('chai');
const Web3 = require('web3');

const OracleStore = artifacts.require('OracleStore');

contract('price store tests', async (addresses) => {
    beforeEach(async () => {
        this.oraclestore = await OracleStore.new([addresses[1], addresses[2]]); //Web3.utils.asciiToHex(addresses[0])
        // console.log("this.oraclestore.address", this.oraclestore.address);
    });

    it('checking get price', async () => {
        let token1 = "asd";
        let token2 = "asb";
        
        console.log("oracleValidatorLength", await this.oraclestore.oracleValidatorsLength())

        await this.oraclestore.proposePriceForPair(token1, token2, 10, {from: addresses[1]});
        let vfnp = await this.oraclestore.votesForNewPrices(token1, token2);
        console.log("vfnp", vfnp.toString());
        await this.oraclestore.proposePriceForPair(token1, token2, 10, {from: addresses[2]});
        vfnp = await this.oraclestore.votesForNewPrices(token1, token2);
        console.log("vfnp", vfnp.toString());

        let ped = await this.oraclestore.pricesExpireDate(token1, token2);
        console.log("ped", ped.toString())
        let price = await this.oraclestore.getPairPrice(token1, token2, {from: addresses[1]});
        console.log("price", price.toString());
    });

    it('checking set price', async () => {
     //   this.oraclestore = await OracleStore.new();
       // await this.oraclestore.setPrice("0xA7437C148C782D260B929140262a8E873e7F7Ff4", new BN('2'));
        //expect(await this.oraclestore.getPrice.call("0xA7437C148C782D260B929140262a8E873e7F7Ff4")).to.be.bignumber.equal(new BN('2'));
    });

    it('checking get liquidity', async () => {
        //this.oraclestore = await OracleStore.new();
        //expect(await this.oraclestore.getLiquidity.call("0xA7437C148C782D260B929140262a8E873e7F7Ff4")).to.be.bignumber.equal(new BN('0'));
    });

    it('checking set liquidity', async () => {
        //this.oraclestore = await OracleStore.new();
        //await this.oraclestore.setLiquidity("0xA7437C148C782D260B929140262a8E873e7F7Ff4", new BN('2'));
        //expect(await this.oraclestore.getLiquidity.call("0xA7437C148C782D260B929140262a8E873e7F7Ff4")).to.be.bignumber.equal(new BN('2'));
    });
});
