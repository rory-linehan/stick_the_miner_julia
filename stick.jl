__precompile__(true)
module stick

# hacky stuff for getting local Python virtualenv to work correctly with PyCall in Julia
ENV["PYTHON"] = abspath(".venv/bin/python")
ENV["PYTHONPATH"] = abspath(".venv/lib/site-packages")
using PyCall  # this needs to be pre-built in build.sh to work correctly
Hash = pyimport("Crypto.Hash")

EthABI = pyimport("eth_abi.packed")
#using Web3  # alternative to the EthABI method

using Random
using Dates
using BitIntegers

function packMine(chainId, entropy, gemAddr, senderAddr, kind, nonce, salt)
    return EthABI.encode_abi_packed(
        ["uint8", "uint256", "address", "address", "uint8", "uint256", "uint256"],
        (chainId, entropy, gemAddr, senderAddr, kind, nonce, salt)
    )
end

function mine(packed)::(String, Int)
    k = Hash.keccak.new(digest_bits=256)
    k.update(packed)
    hx = k.hexdigest()
    return parse(BigInt, hx)
end

function getSalt()::BigInt
    return rand(UInt256)
end

function main()
    chainId::UInt8 = 250
    entropy::BigInt = 0x949f147e5fb733f43d887bd3f9455dad768029a75baa8c63ec2d749439935d59
    gemAddr::String = "0xC67DED0eC78b849e17771b2E8a7e303B4dAd6dD4"
    userAddr::String = "0xFe9C7c2BD25d91B4f2E9C6AE83C11e1465eC63F0"
    kind::UInt8 = 0
    nonce::UInt256 = 0
    diff::UInt256 = 1

    target = ^(2, 256) / diff

    i = 0
    startTime = Dates.now()
    while true
        i += 1
        salt = getSalt()
        ix = mine(packMine(chainId, entropy, gemAddr, userAddr, kind, nonce, salt))
        if <(ix, target)
            println("SALT: "*string(salt))
            break
        end
        if %(i, 5000) == 0
            println("iter "*string(i)*", "*string(i / (Dates.now() - startTime))*" average iter per sec")
        end
    end
end

end # module

using .stick

stick.main()
exit(0)