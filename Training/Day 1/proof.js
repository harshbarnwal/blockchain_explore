const { MerkleTree } = require('merkletreejs')
const SHA256 = require('crypto-js/sha256')

/*const leaves = ['a', 'b', 'c'].map(x => SHA256(x))
const tree = new MerkleTree(leaves, SHA256)
const root = tree.getRoot().toString('hex')
const leaf = SHA256('a')


const proof = tree.getProof(leaf)
console.log(tree.verify(proof, leaf, root)) // true
console.log(proof)
console.log(root)*/



const badLeaves = ['a', 'x', 'c'].map(x => SHA256(x))
const badTree = new MerkleTree(badLeaves, SHA256)
const badLeaf = SHA256('x')
const badProof = badTree.getProof(badLeaf)
const badRoot = badTree.getRoot().toString('hex')
console.log(badTree.verify(badProof, badLeaf, badRoot)) // false
//console.log(badTree.verify(badProof, leaf, badRoot)) // false


