//pragma solidity ^0.8.7 create version but its okay to use better version
//pragma solidity >=0.8.7 < 0.9.0 use version between some range of version

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract SimpleStorage {
    uint256 public favoriteNumber;
    People public person = People({favoriteNumber: 2, name: "test"});
    mapping(string => uint256) public nameToFavoriteNumber;

    function store(uint256 _favoriteNumber) public virtual {
        favoriteNumber = _favoriteNumber;
    }

    struct People {
        uint256 favoriteNumber;
        string name;
    }

    //fixed array
    // People[3] public peoples;

    //dynamic array
    People[] public peoples;

    //view and pure is key to make function doesn't spend gas
    //view and pure disallow modification of state
    //but if we call pure or view method inside function that spend gas, it will also spend gas.
    function retrieve() public view returns (uint256) {
        return favoriteNumber;
    }

    //pure function doesnt allow us to read state from blockchain
    function add() public pure returns (uint256) {
        return (1 + 1);
    }

    //calldata is temporary variable that can't be modified, so u can't modified parameter name here
    //memory is temporary variabl that can be modified
    //storage is eternal variable
    //we need to specify memory to variable array, struct, and mapping. In uint256 we dont need specify that
    //String is an array of byte
    function addPerson(string memory name, uint256 _favoriteNumber) public {
        People memory newPeople = People({
            name: name,
            favoriteNumber: _favoriteNumber
        });
        // People memory newPeople = People(_favoriteNumber, name);
        peoples.push(newPeople);
        nameToFavoriteNumber[name] = _favoriteNumber;
        // peoples.push(People({name: name, favoriteNumber: _favoriteNumber}));
    }
}

//0xd9145CCE52D386f254917e481eB44e9943F39138
