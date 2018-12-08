var fs = require('fs');

var Core = artifacts.require("./PictureCore.sol");
var Generation = artifacts.require("./FrameGeneration.sol");
var FrameSell = artifacts.require("FrameSell.sol");

module.exports = function (deployer) {
    var core;
    var generation;
    var frameSell;
    deployer.deploy(Core)
        .then(() => Core.deployed())
        .then(function (instance) {
            core = instance;
            return deployer.deploy(Generation);
        })
        .then(() => Generation.deployed())
        .then(function(instance) {
            generation = instance;
            return deployer.deploy(FrameSell);
        })
        .then(() => FrameSell.deployed())
        .then(function(instance) {
            frameSell = instance;

            core.setFrameGeneratorAddress(generation.address);
            core.setFrameSellAddress(frameSell.address);

            core.setCanvasCost(500);
            core.setSaleCut(200);

            core.unpause();
        })
};