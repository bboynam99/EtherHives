const { time } = require('openzeppelin-test-helpers');
// const { expect } = require('chai');

const EtherHives = artifacts.require('EtherHives');

async function timeIncreaseTo (seconds) {
    const delay = 1000 - new Date().getMilliseconds();
    await new Promise(resolve => setTimeout(resolve, delay));
    await time.increaseTo(seconds);
}

contract('EtherHives', function ([_, wallet1, wallet2, wallet3]) {
    describe('EtherHives', async function () {
        beforeEach(async function () {
            this.hive = await EtherHives.new();
            this.started = (await time.latest()).addn(10);
            await timeIncreaseTo(this.started);
        });

        it('test', async function () {
            this.hive.deposit('0x0000000000000000000000000000000000000000', { value: web3.utils.toWei('0'), from: wallet1 });
            this.hive.deposit('0x0000000000000000000000000000000000000000', { value: web3.utils.toWei('0'), from: wallet2 });
            this.hive.deposit('0x0000000000000000000000000000000000000000', { value: web3.utils.toWei('0'), from: wallet3 });

            this.hive.deposit('0x0000000000000000000000000000000000000000', { value: web3.utils.toWei('1'), from: wallet1 });
            // this.hive.deposit('0x0000000000000000000000000000000000000000', { value: web3.utils.toWei('2'), from: wallet2 });
            // this.hive.deposit('0x0000000000000000000000000000000000000000', { value: web3.utils.toWei('3'), from: wallet3 });

            await timeIncreaseTo(this.started.add(time.duration.weeks(1)));

            // this.hive.deposit('0x0000000000000000000000000000000000000000', { value: web3.utils.toWei('1'), from: wallet1 });
            // this.hive.deposit('0x0000000000000000000000000000000000000000', { value: web3.utils.toWei('2'), from: wallet2 });
            // this.hive.deposit('0x0000000000000000000000000000000000000000', { value: web3.utils.toWei('3'), from: wallet3 });
        });
    });
});
