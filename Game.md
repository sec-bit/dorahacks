## 0. 游戏基本说明

### 0.0 玩法流程 

![image-20180927121019557](/Users/siplexy/Workplace/secbit/git/treasure_hunt_game/pics/image-20180927121019557.png)

游戏过程描述如下：

1. 玩家通过`游戏 Builder 合约`创建`游戏合约`。每个玩家的账户地址下，有且仅有一个独立的`游戏合约`。
2. `游戏合约`都会有一个通关条件，玩家通过达成通关条件才能通关合约。
3. 通关之后，玩家需要通过`游戏合约`的提交按钮上传结果。`游戏 Builder 合约` 会验证通关条件并记录通关结果。
4. 玩家可以根据自己的账户地址，在`游戏 Builder 合约`中查看自己是否通关。

其中，

- `游戏 Builder 合约`： 用来为不同玩家创建游戏，并且记录玩家游戏通关结果的合约。
- `游戏合约`： 玩家需要破解通关的合约。一种游戏的每一个玩家账户地址下，最多有一个游戏合约。

### 0.1 游戏合约

我们提供了三种游戏：

#### GateKeeper

​	这是一个击败守护者的游戏。玩家需要破解三个 Gatekeeper 修改合约变量。

#### Airdrop

​	一个 token 的空投游戏。玩家需要把空投的 token 全部薅光。

#### HoneyPot

​	一个看似简单的合约。玩家需要把合约中的 ether 全部提走。

### 0.2 游戏 Builder 合约结构

> 玩家通过`游戏 Builder 合约`创建属于自己的游戏合约。
>

```js
contract GameBuilder{
	mapping(address => address) public playContract ;
	mapping(address => bool) public isWinned;
	address[] public winnerList;

	function submit() public returns (bool){
		 require(playContract[tx.origin] != address(0));
		require(playContract[tx.origin] == msg.sender);
		return isPass(tx.origin);
	}

	function isPass(address _submiter) private returns (bool){
		if (isWinned[_submiter]) {
			return true;
		}
		require(GameContract(playContract[_submiter]).isPass());
		winnerList.push(tx.origin);
		isWinned[tx.origin] = true;
		return true;
	}

	function play() public returns (address){
		if (playContract[tx.origin] == address(0)){
			address a = gameCreate();
			playContract[tx.origin] = a;
		}
		return playContract[tx.origin];
	
	}

	function gameCreate() public returns (address);
}
```

对于 `游戏 Builder 合约`,

- 开始游戏时，玩家需要通过`play()`创建属于自己的游戏合约。
- 玩家通过 `playContract(address)` 可以查看属于自己的游戏合约地址。
- 玩家通过 `isWinned(address)` 可以看到自己当前游戏的通关情况。

### 0.3 游戏合约

```js
contract GameContract{
    
	GameBuilder private mainContract;
    
	constructor() public{
		mainContract=GameBuilder(msg.sender); 
	}

	function submit() public returns (bool){
		require(isPass());
		return mainContract.submit();
	}

	function isPass() returns (bool);
}	
```

对于游戏合约,

- `isPass()` 的内容描述了合约通关的条件。
- `submit()`用来上传游戏通关的结果。

### 0.4 游戏合约 Example 

```javascript
contract ExampleGame is GameContract {
    
    constructor () public payable {
    }
    
    function withdraw() public {
        require(tx.origin != msg.sender);
         msg.sender.transfer(address(this).balance);
    }

	function isPass() returns (bool) {
		return address(this).balance == 0;
	}

}
```

游戏说明如下：

- `isPass()` 中表明的通关条件是**使得游戏合约的余额为0**。
- 通过分析可以看到，要想把余额提取出来，编写另外一个合约调用`withdraw()`方法即可。
- 最后通过 `submit()`提交游戏合约结果。