pragma solidity ^0.4.25;

contract Lottery{
    address public manager;
    address[] public players;
    
    
    function Lottery() public{
        manager=msg.sender;
    }

    function getManager() public view returns(address){
        return manager;
    }

    //投注彩票
    function enter() public payable{
        require(msg.value == 1 ether);
        players.push(msg.sender);
    }

    //返回所有的投注彩票的人
    function getAllPlayers() public view returns(address[]){
        return players;
    }

    function getBalance() public view returns(uint){
        return this.balance;
    }

    function getPlayersCount() public view returns(uint){
        return players.length;
    }

    function random() private view returns(uint){
        return uint(keccak256(block.difficulty,now,players));
    }

    function pickWinner() public onlyManagerCanCall returns (address){
        require(msg.sender == manager);
        uint index = random()%players.length;
        address winner = players[index];
        players = new address[](0);
        winner.transfer((this.balance) * 9/10);
        manager.transfer((this.balance));
        return winner;
    }

    function refund() public onlyManagerCanCall{
        require(msg.sender == manager);
        for(uint i=0;i<players.length;i++){
            players[i].transfer(1 ether);
        }
        players=new address[](0);
    }

    modifier onlyManagerCanCall(){
        require(msg.sender == manager);
        _;
    }
}