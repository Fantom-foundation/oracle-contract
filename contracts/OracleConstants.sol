pragma solidity ^0.5.0;

contract OracleConstants {
  // prices of a symb against default tokens
  string constant _defaultSymb = "BTC";
  uint256 constant _pricesExpirePeriod = 1 hours; // transaction time + real expire period + lags

  function defaultSymb() public view returns (string memory) {
      return _defaultSymb;
  }

  function pricesExpirePeriod() public view returns (uint256) {
      return _pricesExpirePeriod;
  }
}