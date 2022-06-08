from brownie import FundMe, MockV3Aggregator, network, config
from scripts.helpful_scripts import get_account, deploy_mock, LOCAL_BLOCkCHAIN_ENVIRONMENTS


def deploy_fund_me():
 account = get_account()
 #if we are on persistant network like rinkeby, use the associated address
 if network.show_active() not in LOCAL_BLOCkCHAIN_ENVIRONMENTS:
  price_feed_address = config["networks"][network.show_active()][
   "eth_usd_price_feed"
   ]
 
 #otherwise, deploy mocks
 else:
  deploy_mock()
  price_feed_address = MockV3Aggregator[-1].address
  print("Mocks Deployed...")

 fund_me = FundMe.deploy(price_feed_address, {"from": account}, publish_source=config["networks"][network.show_active()].get("verify"))
 print(f"Contract deployed to {fund_me.address}")
 return fund_me

def main():
 deploy_fund_me()