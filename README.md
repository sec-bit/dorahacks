## 

# DoraHacks × SECBIT安比实验室——智能合约挑战赛比赛说明

## 参赛须知

- 在浏览器上安装 MetaMask 插件。
- 合约都部署在 Kovan 测试网络中。
- 可以从 https://faucet.kovan.network 上领取或者 https://gitter.im/kovan-testnet/faucet 中索要。 每个人一天最多 4 ether，请节约使用。
- 挑战赛涉及的源代码放在 https://github.com/sec-bit/dorahacks

## 参加比赛流程

- 访问游戏题目对应的网站，点击**开始**按钮后，创建属于参赛者的游戏合约。
- 根据游戏合约的源代码和通关条件，在测试网络上破解通关游戏合约。
- 破解成功后，点击**提交**按钮，将结果上传并进行验证。

## 题目说明

#### Game 1.  GateKeeper

- 题目网站：
	- Kovan: https://secbit.io/dorahacks/game1.html
- 通关条件： 将 entrant 地址改成参赛者的地址。
- 合约地址： *https://kovan.etherscan.io/address/0xfacd708f70f9798ac181e650e7ff30f9e2bad2ea*

#### Game 2. AirDrop

- 题目网站：
	- Kovan: https://secbit.io/dorahacks/game2.html
- 通关条件：将 totalSupply 的 token 全部薅光。
- 合约地址： https://kovan.etherscan.io/address/0x75ac31240f3b6d13c412c3fee869fd700b444d75
- 提示：


#### Game 3. HoneyPot

- 题目网站： 
	- Kovan: https://secbit.io/dorahacks/game3.html
- 通关条件：将合约中的全部 ether 转走。
- 合约地址：https://kovan.etherscan.io/address/0x470ed8a141a2255af7cd059d40d1cec81fcd3f4c
- 提示：

待破解的合约在创建后，bytecode 被替换了，你看到的合约并不是真正的合约。真正的合约是创建合约时，传入的 bytecode.
真正的待破解合约的代码结构如下:
```
contract GameConact is GameContract{
  	constructor () public payable {

	}
	function get(bytes4 a) public payable {

	}
	function isPass() view returns (bool)  {
		return address(this).balance == 0;
	}
}
```

