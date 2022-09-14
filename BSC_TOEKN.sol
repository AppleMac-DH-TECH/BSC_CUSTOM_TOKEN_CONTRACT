// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;

contract Token {
    string public name; //hole the name of token
    string public symbol;   //hold the symbol of the token
    uint8 public decimals; //hold the decial place of the token
    uint256 public  totalSupply; //hold the total supply of the token
    address payable public owner;

    // This create the mapping with all balance
    mapping( address => uint256 ) public balanceOf;
    // This create the mapping of all accounts with all allowancers
    mapping( address => mapping(address => uint256 )) public allowance; 
    // Event to transfer funds from one to another.
    event Transfer(address indexed from , address indexed to , uint256 value);
    // Event for Approve funds from one's wallet to another.
    event Approve(address indexed owner ,  address indexed spender ,  uint256 value);

    //constructor
    constructor(){
        name = "RandomToken"; //set the name of toekn i.e. Ether
        symbol = "RDT"; // set the symbol of token i.e. Eth
        decimals = 18; // set the initial decimal places
        uint256 _initialSupply = 1000000000; // Hold the initial  supply for the token
        //Set the owner of the token whoever deploy it. 
        owner = payable(msg.sender);

        balanceOf[owner] = _initialSupply; // Transfer all the tokens to the first deployer
 
        totalSupply = _initialSupply; // set the total supply number as initail supply

        emit Transfer(address(0) , msg.sender , _initialSupply);
    }

    function getOwner() public view returns (address){
        return owner;
    }
    //msg.sender is who is call this function. This something like children take 10$ our of pocket inorder to buy something want.
    function transfer(address _to , uint256 _value) public returns (bool success) {
        uint256 senderBalance = balanceOf[msg.sender];
        uint256 receiverBalance = balanceOf[_to];

        require(_to != address(0) , "Receiver address invalid");
        require(_value >= 0 , "Value must be greate or equal with 0");
        require(senderBalance > _value , "Not enough balance");

        balanceOf[msg.sender] = senderBalance - _value;
        balanceOf[_to] = receiverBalance + _value;

        emit Transfer(msg.sender ,  _to , _value);
        return true;
    }

       function transferFrom(address _from, address _to, uint256 _value)
        public returns (bool success) {
            uint256 senderBalance = balanceOf[msg.sender];
            uint256 fromAllowance = allowance[_from][msg.sender];
            uint256 receiverBalance = balanceOf[_to];

            require(_to != address(0), "Receiver address invalid");
            require(_value >= 0, "Value must be greater or equal to 0");
            require(senderBalance > _value, "Not enough balance");
            require(fromAllowance >= _value, "Not enough allowance");

            balanceOf[_from] = senderBalance - _value;
            balanceOf[_to] = receiverBalance + _value;
            allowance[_from][msg.sender] = fromAllowance - _value;

            emit Transfer(_from, _to, _value);
            return true;
        }


    function approve(address _spender , uint256 _value )  public returns (bool success){  
        
        require( _value > 0  , "Value must be greate than 0");
        allowance[msg.sender][_spender] = _value;
        emit Approve(msg.sender , _spender , _value);
        return true;
    }

    function mint(uint256 _amount) public returns (bool success){
        require(msg.sender == owner , "Operation unauthorized");

        totalSupply += _amount;
        balanceOf[msg.sender] += _amount;

        emit Transfer(address(0) , msg.sender , _amount);
        return true; 
    }

    function burn(uint256 _amount) public returns (bool success){
        require(msg.sender != address(0) , "Invalid burn receipient" );

        uint256 accountBalance = balanceOf[msg.sender];
        require(accountBalance > _amount  , "Burn amount exceeds balance");

        balanceOf[msg.sender] -= _amount;
        totalSupply -= _amount;

        emit Transfer(msg.sender , address(0) , _amount); 
        return true;         
    }

}

