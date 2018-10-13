/**
****
****      ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄ 
****     ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
****     ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌▀▀▀▀█░█▀▀▀▀  ▀▀▀▀█░█▀▀▀▀ 
****     ▐░▌          ▐░▌          ▐░▌          ▐░▌       ▐░▌    ▐░▌          ▐░▌     
****     ▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌          ▐░█▄▄▄▄▄▄▄█░▌    ▐░▌          ▐░▌     
****     ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌          ▐░░░░░░░░░░▌     ▐░▌          ▐░▌     
****      ▀▀▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░▌          ▐░█▀▀▀▀▀▀▀█░▌    ▐░▌          ▐░▌     
****               ▐░▌▐░▌          ▐░▌          ▐░▌       ▐░▌    ▐░▌          ▐░▌     
****      ▄▄▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌▄▄▄▄█░█▄▄▄▄      ▐░▌     
****     ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░▌▐░░░░░░░░░░░▌     ▐░▌     
****      ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀       ▀      
****                                                                                  
**** Created by SECBIT.  https://secbit.io
****
**** Github:  https://github.com/sec-bit      
**** Twitter: @SECBIT_IO
****
*/
pragma solidity ^0.4.18;
import "./game_interface.sol";


contract Gate is GameContract{

	uint private password;
	uint private username;
	address public entrant;

	struct User {
	    uint  happyCoding;
		uint  username;
		uint  password;
	}

    function bytesToUint(bytes20 b) private returns (uint256){
        uint256 number;
        for(uint i=0;i<7;i++){
            number = number + uint(b[i])*(2**(8*(b.length-(i+1))));
        }
        return number;
    } 


	function Gate(address _password) public{
		password = bytesToUint(bytes20(_password)) ;
	}

	modifier gateKeeperOne() {
		require(bytes20(tx.origin)[0] == bytes1(0x0));
		require(bytes20(tx.origin)[1] == bytes1(0x0));
		User  user;
		user.password =  bytesToUint(bytes20(address(this))) << 2;
		user.username = bytesToUint(bytes20(address(this))) << 5;
		_;
	}

	modifier gateKeeperTwo() {
			require(msg.gas % 8191 < 1200);  
			require(msg.gas % 8191 > 800); 
		_;
	}

	modifier gateKeeperThree(uint _gateKey) {
			require(_gateKey == password);
		_;
	}

	function enter(uint _gateKey) public  gateKeeperOne gateKeeperTwo gateKeeperThree(_gateKey) returns (bool) {
		entrant = tx.origin;
		return true;
	}

	function isPass() view returns (bool){
		return(tx.origin == entrant);
	}

}
