pragma solidity >=0.4.21 <0.6.0;

contract CopyTradingProxy {

  address public master;
  //memory address
  address public dex;
  // max followers
  uint public maxNrOfFollowers;
  // number of followers
  uint public nrOfFollowers;
  // follower addresses
  address[] public followers;

  // CONSTRUCTORS
  constructor(address _dex) public {
    master = msg.sender;
    maxNrOfFollowers = 5;
    dex = _dex;
  }

  // only master can execute
  modifier onlyMaster () {
    require(msg.sender == master);
    _;
  }

  // only follower can execute
  modifier notMaster () {
    require(msg.sender != master);
    _;
  }


  // add follower to the contract
  function addFollower(address _followerAddress) notMaster() public payable {
      require(nrOfFollowers < maxNrOfFollowers);
      followers.push(_followerAddress);
      nrOfFollowers += 1;
      emit FollowerAddedEvent(_followerAddress);
  }

  // remove follower to the contract
  function removeFollower(address _followerAddress) notMaster() public payable  {
      require(this.isInFollowers(_followerAddress));

      // deleting without a gap with minimal gas ?

      emit FollowerRemovedEvent(_followerAddress);
  }

  // ask contract for the transaction master did
  function order(address _token, uint _amount) onlyMaster() public payable {

      emit OrderCreatedEvent(msg.sender, _token, _amount);
  }
  
  // is address in the follower list
  function isInFollowers(address _followerAddress) public payable  returns (bool) {
        for (uint i=0; i<maxNrOfFollowers; i++) {
            if (followers[i] == _followerAddress){
                return true;    
            }
        }
    return false;
  }

  // event raised at follower added
  event FollowerAddedEvent(address follower);

  // event raised at follower removed
  event FollowerRemovedEvent(address follower);

  // event raised at creating the order
  event OrderCreatedEvent(address follower, address token, uint amount);

}