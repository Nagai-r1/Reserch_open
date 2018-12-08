pragma solidity ^0.4.15;

contract VotingSystem{
    
    enum stages{
        registrationStage,	//���ғo�^�t�F�[�Y
        voteStage,		//���[�J�n�t�F�[�Y
        endvoteStage		//���[�I���t�F�[�Y
    }
    //���ғo�^�t�F�[�Y���ŏ��ɃZ�b�g
    stages public stage = stages.registrationStage;
    
�@�@//���ҏ����i�[����\����
    struct KouhoInfo{
        uint no;
        string name;
        uint count;
    }
    KouhoInfo[] public kouho;

�@�@//���[�҂̏����i�[����\����
    struct VoterInfo{
        string lastVote;
        uint vote_count;
    }
    mapping(string => KouhoInfo) kouhoData;
    mapping(address => VoterInfo) voterData;

    //�t�F�[�Y������s��
    modifier atStage(stages _stage){
        require(stage == _stage);
        _;
    }
    
�@�@//���҂�o�^����֐�
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