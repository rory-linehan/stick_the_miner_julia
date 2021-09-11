using Web3
using PyCall
using Random
Hash = pyimport("Crypto.Hash")
EthABI = pyimport("eth_abi.packed")

chain_id::UInt8 = 1
entropy::Float64 = 0x949f147e5fb733f43d887bd3f9455dad768029a75baa8c63ec2d749439935d59
gemAddr::String = "0xC67DED0eC78b849e17771b2E8a7e303B4dAd6dD4"
userAddr::String = "0xFe9C7c2BD25d91B4f2E9C6AE83C11e1465eC63F0"
kind::UInt8 = 0
nonce::UInt8 = 0
diff::Float64 = 1

target = ^(2, 256) / diff

function pack_mine(chain_id, entropy, gemAddr, senderAddr, kind, nonce, salt)::Bytes
    return EthABI.encode_abi_packed(
        ["uint256", "uint256", "address", "address", "uint", "uint", "uint"],
        (chain_id, entropy, gemAddr, senderAddr, kind, nonce, salt)
    )
end

function mine(packed)::(String, Int)
    k = Hash.keccak.new(digest_bits=256)
    k.update(packed)
    hx = k.hexdigest()
    return hx, parse(Int, hx)
end

function get_salt()::UInt128
    return rand(UInt128)
end

i = 0
while true
    global i += 1
    salt = get_salt()
    hx, ix = mine(pack_mine(chain_id, entropy, gemAddr, userAddr, kind, nonce, salt))
    if <(ix, target)
        println("SALT: "*string(salt))
        break
    end
end