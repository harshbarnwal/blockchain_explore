$(document).ready(function () {	
	
	let contract;
	let provider;
	async function initConnect() {


		provider = new ethers.providers.Web3Provider(window.ethereum)	
		signer = provider.getSigner();
		let contractAddress = "0x088Cb7E83F28889F47100D32916665F9cF1E6914";
		let abi = [
			{
				"inputs": [
					{
						"internalType": "string",
						"name": "candidateName",
						"type": "string"
					}
				],
				"name": "addCandidate",
				"outputs": [],
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "address",
						"name": "_voter",
						"type": "address"
					}
				],
				"name": "addVoter",
				"outputs": [],
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "uint256",
						"name": "",
						"type": "uint256"
					}
				],
				"name": "candidates",
				"outputs": [
					{
						"internalType": "string",
						"name": "",
						"type": "string"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [],
				"name": "currentLeadingCandidate",
				"outputs": [
					{
						"internalType": "string",
						"name": "",
						"type": "string"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [],
				"name": "electionStarted",
				"outputs": [
					{
						"internalType": "bool",
						"name": "",
						"type": "bool"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [],
				"name": "endElection",
				"outputs": [],
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"inputs": [],
				"name": "getCandidateCount",
				"outputs": [
					{
						"internalType": "uint256",
						"name": "",
						"type": "uint256"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [],
				"name": "getWinner",
				"outputs": [
					{
						"internalType": "string",
						"name": "",
						"type": "string"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [],
				"name": "maxVoteCount",
				"outputs": [
					{
						"internalType": "uint256",
						"name": "",
						"type": "uint256"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [],
				"name": "restartElection",
				"outputs": [],
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"inputs": [],
				"name": "startElection",
				"outputs": [],
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "string",
						"name": "candidateName",
						"type": "string"
					}
				],
				"name": "vote",
				"outputs": [],
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "address",
						"name": "",
						"type": "address"
					}
				],
				"name": "voted",
				"outputs": [
					{
						"internalType": "uint8",
						"name": "",
						"type": "uint8"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "string",
						"name": "",
						"type": "string"
					}
				],
				"name": "votes",
				"outputs": [
					{
						"internalType": "uint256",
						"name": "",
						"type": "uint256"
					}
				],
				"stateMutability": "view",
				"type": "function"
			}
		];

		contract = new ethers.Contract( contractAddress , abi , signer );
		
		//------------------------------------- METAMASK BOILERPPLATE------------------//
	
		window.ethereum.on('chainChanged', handleChainChanged);
		window.ethereum.on('accountsChanged', handleAccountsChanged);

		}

	
	function handleChainChanged(_chainId) {
	  // We recommend reloading the page, unless you must do otherwise
	  console.log("changed chain "+_chainId)
	}
	
	function handleAccountsChanged(accounts) {
	  // We recommend reloading the page, unless you must do otherwise
	  console.log("acccount changed "+ accounts)
	}
	
	$("#connect").click(async function async() {
		initConnect();
		await provider.send("eth_requestAccounts", []);
		signer = provider.getSigner()
		console.log(signer);
		$("#connect").text(await signer.getAddress());
		

	});


	$("#get_status").click(async function async() {
		console.log("transferring")
		await provider.send("eth_requestAccounts", []);
		signer = provider.getSigner();
		let status = await contract
			.electionStarted()
			
		$("#status").text(JSON.stringify(status));

	});
	$("#add_candidate").click(async function async() {
		
		let name = $('#candidate_name').val();
		let tx = await contract.addCandidate(name);
		console.log(tx)	

	});

	$("#add_voter").click(async function async() {
	console.log("add voter")
		let name = $('#voter_wallet').val();
		let tx = await contract.addVoter(name);
		console.log(tx)	
	
	});


	$("#get_list").click(async function async() {
		

		let count = await contract.getCandidateCount();
			
		var candidates = "";
		$("#candidate_buttons").empty();
		for (var i = 0; i < count; i++) {

			let canidateNm = await contract.candidates(i);
				
			candidates = canidateNm + ", " + candidates;
			var r = $('<button value="' + canidateNm + '">' + canidateNm + '</button>');
			r.click(function () { vote(this); });
			console.log(r);
			$("#candidate_buttons").append(r);
		}
		$("#candidates").text("click on button below to vote");
	});
	async function vote(nm) {
		console.log(nm.value);
		const tx = await contract.vote(nm.value); 
		console.log(tx)
	}
	$("#start").click(async function async() {
		const tx = await contract.startElection(); 
		console.log(tx)
		
	});
	
	
	$("#vote").click(async function async() {

		
	});
	$("#get_leader").click(async function async() {
		

	});
	$("#end").click(async function async() {

		const tx = await contract.endElection(); 
		console.log(tx)
		
	});

	$("#get_winner").click(async function async() {
		let winner = await contract.getWinner();
		$("#get_winner").text(winner);
		
	});

	$("#restart").click(async function async() {
		let tx = await contract.restartElection();
		console.log(tx)	
	
	});
	
	
	$("#sign").click(async function async() {
		await provider.send("eth_requestAccounts", []);
		signer = provider.getSigner();
		const sign = await ethereum.request({ method: 'personal_sign', params: [await signer.getAddress(), "please sign me"] });
		console.log(sign);
	
	});
	//client -> Sign(Address, "message") ------> sigedPayload, message ----> verify(payload, message) -> address
	


});

