const MyNFTERC721 = artifacts.require("MyNFTERC721");

module.exports = function (deployer) {
  deployer.deploy(MyNFTERC721);
};
