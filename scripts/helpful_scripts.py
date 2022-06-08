from brownie import network, config, accounts, MockV3Aggregator
from web3 import Web3

DECIMALS=8
STARTING_PRICE=200000000000

FORKED_LOCAL_ENVIRONMENT = ["mainnet-fork", "mainnet-fork-dev"]
LOCAL_BLOCkCHAIN_ENVIRONMENTS = ["development", "ganache-local"]

def get_account():
 if network.show_active() in LOCAL_BLOCkCHAIN_ENVIRONMENTS or network.show_active() in FORKED_LOCAL_ENVIRONMENT:
  return accounts[0]
 else:
  return accounts.add(config["wallets"]["from_key"])

def deploy_mock():
 print(f"The active network is {network.show_active()}")
 print("Deploying Mock...")
 if len(MockV3Aggregator) <=0:
  MockV3Aggregator.deploy(DECIMALS, STARTING_PRICE, {"from": get_account()})
 