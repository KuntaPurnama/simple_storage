const { ethers, run, network } = require("hardhat")
require("dotenv").config()

async function main() {
    const SimpleStorageFactory = await ethers.getContractFactory(
        "SimpleStorage"
    )
    console.log("deploy contract..")

    const simpleStorage = await SimpleStorageFactory.deploy()
    ;(await simpleStorage).deployed()
    console.log(`address : ${(await simpleStorage).address}`)
    // console.log(network.config)
    if (network.config.chainId === 11155111 && process.env.ETHERSCAN_API_KEY) {
        console.log("waiting block confirmation")
        await simpleStorage.deployTransaction.wait(6)
        await verify(simpleStorage.address, [])
    }

    const currentValue = await simpleStorage.retrieve()
    console.log(`current value : ${currentValue}`)

    const transactionResponse = await simpleStorage.store("10")
    await transactionResponse.wait(1)

    const updatedValue = await simpleStorage.retrieve()
    console.log(`updated value ${updatedValue}`)
}

async function verify(contractAddress, args) {
    console.log("Verify contract....")
    try {
        await run("verify:verify", {
            address: contractAddress,
            constructorArguments: args,
        })
    } catch (e) {
        if (e.message.toLowerCase().includes("already verified")) {
            console.log("Already Verified!")
        } else {
            console.log(e)
        }
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })
