pragma solidity ^0.4.15;

contract VotingSystem{
    
    enum stages{
        registrationStage,	//候補者登録フェーズ
        voteStage,		//投票開始フェーズ
        endvoteStage		//投票終了フェーズ
    }
    //候補者登録フェーズを最初にセット
    stages public stage = stages.registrationStage;
    
　　//候補者情報を格納する構造体
    struct KouhoInfo{
        uint no;
        string name;
        uint count;
    }
    KouhoInfo[] public kouho;

　　//投票者の情報を格納する構造体
    struct VoterInfo{
        string lastVote;
        uint vote_count;
    }
    mapping(string => KouhoInfo) kouhoData;
    mapping(address => VoterInfo) voterData;

    //フェーズ判定を行う
    modifier atStage(stages _stage){
        require(stage == _stage);
        _;
    }
    
　　//候補者を登録する関数
    function eRegister(uint _no, string _name) public atStage(stages.registrationStage) {
        kouho.push(KouhoInfo(_no, _name, 0));
    }

    function eVote(string _vote)public atStage(stages.voteStage) {
        if(voterData[msg.sender].vote_count >= 1){
            kouhoData[voterData[msg.sender].lastVote].count--;
        }
        kouhoData[_vote].count++;
        voterData[msg.sender].lastVote = _vote;
        voterData[msg.sender].vote_count++;
    }
    function showVote(string _vote)public atStage(stages.endvoteStage) returns(uint){
        return kouhoData[_vote].count;
    }
    function showLast()public returns(string){
        return voterData[msg.sender].lastVote;
    }
    function voteStart()public atStage(stages.registrationStage){
        stage = stages.voteStage;
    }
    function voteEnd()public atStage(stages.voteStage) {
        stage = stages.endvoteStage;
    }
    
}