pragma solidity 0.5.0;

contract OracleConstants {
  // prices of a symb against default tokens
  string constant defaultSymb = "BTC";
  uint256 constant pricesExpirePeriod = 100000; // transaction time + real expire period + lags
}