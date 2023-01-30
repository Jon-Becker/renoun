import os
import json
import pathlib
import re

from web3 import Web3
from dotenv import load_dotenv

load_dotenv()

# import environment variables
RPC_URL = os.environ.get("RPC_URL")
ADDITIONS = os.environ.get("ADDITIONS")
DELETIONS = os.environ.get("DELETIONS")
COMMIT_HASH = os.environ.get("COMMIT_HASH")
PRIVATE_KEY = os.environ.get("PRIVATE_KEY")
PULL_REQUEST_ID = os.environ.get("PULL_REQUEST_ID")
REPOSITORY_STARS = os.environ.get("REPOSITORY_STARS")
PULL_REQUEST_BODY = os.environ.get("PULL_REQUEST_BODY")
PULL_REQUEST_TITLE = os.environ.get("PULL_REQUEST_TITLE")
REPOSITORY_CONTRIBUTORS = os.environ.get("REPOSITORY_CONTRIBUTORS")
RENOUN_DEPLOYMENT_ADDRESS = os.environ.get("RENOUN_DEPLOYMENT_ADDRESS")
PULL_REQUEST_CREATOR_USERNAME = os.environ.get("PULL_REQUEST_CREATOR_USERNAME")
PULL_REQUEST_CREATOR_PICTURE_URL = os.environ.get("PULL_REQUEST_CREATOR_PICTURE_URL")

# import the Renoun ABI
RENOUN_ABI = json.loads(open(f"{pathlib.Path(__file__).parent.parent.resolve()}/json/renoun.json").read())

# create RPC connection
try: web3 = Web3(Web3.HTTPProvider(RPC_URL))
except: 
    try: web3 = Web3(Web3.WebsocketProvider(RPC_URL))
    except: raise ConnectionError
    
# create the admin account with PRIVATE_KEY
operator = web3.eth.account.privateKeyToAccount(PRIVATE_KEY);

# regex extract ETH address from string
if re.search(r"0x[0-9a-fA-F]{40}", PULL_REQUEST_BODY):
    MINT_TO_ADDRESS = re.search(r"0x[0-9a-fA-F]{40}", PULL_REQUEST_BODY).group(0)

    # create contract instance
    renoun = web3.eth.contract(Web3.toChecksumAddress(RENOUN_DEPLOYMENT_ADDRESS), abi=RENOUN_ABI)
    raw_transaction = renoun.functions.mint(
        Web3.toChecksumAddress(MINT_TO_ADDRESS),
        int(PULL_REQUEST_ID) if PULL_REQUEST_ID.isnumeric() else 0,
        re.sub(r'[^a-zA-Z0-9 ]*' , '', PULL_REQUEST_TITLE),
        int(ADDITIONS) if ADDITIONS.isnumeric() else 0,
        int(DELETIONS) if DELETIONS.isnumeric() else 0,
        PULL_REQUEST_CREATOR_PICTURE_URL,
        PULL_REQUEST_CREATOR_USERNAME,
        COMMIT_HASH,
        int(REPOSITORY_STARS) if REPOSITORY_STARS.isnumeric() else 0,
        int(REPOSITORY_CONTRIBUTORS) if REPOSITORY_CONTRIBUTORS.isnumeric() else 0,
    ).buildTransaction(
        {
            "from": operator.address,
            "nonce": web3.eth.getTransactionCount(operator.address),
            "gasPrice": web3.eth.gas_price,
            "chainId": 10,
        }
    )

    # sign & broadcast the transaction
    signed_transaction = web3.eth.account.sign_transaction(raw_transaction, private_key=PRIVATE_KEY)
    web3.eth.sendRawTransaction(signed_transaction.rawTransaction)
else:
    raise ValueError("No valid ETH address found in PR body")