pragma solidity ^0.5.0;

import "./OracleConstants.sol";

contract OracleStore is OracleConstants {
  uint256 pricesRequestedAt;
  address[] public oracleValidators;
  string[] tokenSymbs;

  mapping(string => uint256) tokenSymbIdx;
  mapping(address => uint256) validatorIdx;
  mapping(address => uint256) _liquidityStore;
  mapping(string => mapping(string => uint256)) public votesForNewPrices;
  mapping(string => mapping(string => uint256)) public pricesExpireDate; // symb1 => symb2 => timestamp
  mapping(string => mapping(string => uint256)) public tokenPairs;
  mapping(address => mapping(string => mapping(string => uint256))) proposedPrices; // timestamp => oracleValidator => token1Symb => token2Symb => price

  event UpdateAllPrices(uint256 timestamp);
  event UpdatePriceForPair(string symb1, string symb2);

  constructor(address[] memory _oracleValidators) public {
    oracleValidators = _oracleValidators;
    for (uint256 i = 0; i < oracleValidators.length; i++) {
      validatorIdx[oracleValidators[i]] = i;
    }
  }

  function oracleValidatorsLength() public view returns(uint256) {
    return oracleValidators.length;
  }

  function requestPriceUpdate() public {
    emit UpdateAllPrices(block.timestamp);
  }

  function requestPairUpdate(string memory symb1, string memory symb2) public {
    emit UpdatePriceForPair(symb1, symb2);
  }

  function proposePriceForPair(string memory symb1, string memory symb2, uint256 price) public {

    uint256 idx = validatorIdx[msg.sender];
    require(oracleValidators[idx] == msg.sender, "sender is not validator");

    proposedPrices[msg.sender][symb1][symb2] = price;
    votesForNewPrices[symb1][symb2] += 1;

    if (votesForNewPrices[symb1][symb2] == oracleValidators.length) {
      for (uint256 i = 0; i < oracleValidators.length; i++) {
        address oracleValidator = oracleValidators[i];
        require(proposedPrices[oracleValidator][symb1][symb2] == price, "prices diverge. data provided by oracles is not consistant");

        // if data is provided correctly - erase it
        proposedPrices[oracleValidator][symb1][symb2] = 0;
      }

      setPriceForPair(symb1, symb2, price);
      votesForNewPrices[symb1][symb2] = 0;
    }
  }

  // return price for a provedid token symb
  function getPrice(string memory symb) public returns (uint256) {
    uint256 price = tokenPairs[symb][defaultSymb()];
    require(pricesAreRelevant(symb, defaultSymb()), "price for a token expired");

    return price;
  }

  function getPairPrice(string memory symb1, string memory symb2) public view returns (uint256) { //view
    uint256 price = tokenPairs[symb1][symb2];
    require(pricesAreRelevant(symb1, symb2), "price for a token expired");

    return price;
  }

  function setPriceForPair(string memory symb1, string memory symb2, uint256 price) internal {
    tokenPairs[symb1][symb2] = price;
    pricesExpireDate[symb1][symb2] = block.timestamp + pricesExpirePeriod();
  }

  function setLiquidity(address _token, uint256 _liquidity) public {
    _liquidityStore[_token] = _liquidity;
  }

  function getLiquidity(address _token) public view returns (uint256) {
    return _liquidityStore[_token];
  }

  // returns false if prices expired
  function pricesAreRelevant(string memory symb1, string memory symb2) public view returns (bool) {
    return block.timestamp < pricesExpireDate[symb1][symb2] && pricesExpireDate[symb1][symb2] != 0;
  }
}
