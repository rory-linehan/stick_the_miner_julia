using Pkg
#Pkg.add("Web3")
Pkg.add("PyCall")
Pkg.build("PyCall")
Pkg.add("BitIntegers")
Pkg.precompile()