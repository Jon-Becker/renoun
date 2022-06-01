# renoun

  ##### June 1, 2022&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;By [Jonathan Becker](https://jbecker.dev)
  <br>
  
  ![preview](https://raw.githubusercontent.com/Jon-Becker/renoun/main/preview.png?token=GHSAT0AAAAAABPTFLJBB4HKTSG43PCZU5FCYUW32RA)

  Renoun is a project inspired by the work of @achalvs which allows for automatic minting of non-transferrable tokens on Ethereum based chains.

  I've deployed the contracts on Optimism for free use, and for demonstration purposes. Feel free to open a Pull Request to this repository to test out the minting!

  - BadgeRenderer -> [0x76dd7b6e560f08acce65dbc6113f3e2f5f91577f](https://optimistic.etherscan.io/address/0x76dd7b6e560f08acce65dbc6113f3e2f5f91577f)
  - Renoun -> [0x48933e1235529732eb8957ab64f4093d66a7e841](https://optimistic.etherscan.io/address/0x48933e1235529732eb8957ab64f4093d66a7e841)

  Check out tokenURI() for 4+, The renderer was broken before then.

# Installation
  
  - First, clone this repository using
    ```
    git clone https://github.com/Jon-Becker/renoun.git .
    ```

  - Deploy both the ``BadgeRenderer.sol`` and ``renoun.sol`` contracts onto your chain of choice The renderer contract is very large, 10kb+, so I recommend deploying on a L2.
    - When deploying renoun.sol, you'll need to specify the deployed renderer address

  - On your repository of choice, set up 3 [GitHub Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
    - ``PRIVATE_KEY`` - which stores the private key of the deploying address
    - ``RPC_URL`` - which stores the full RPC url of your web3 provider
    - ``DEPLOYMENT_ADDRESS`` - which stores the deployment address of ``renoun.sol``

  - Copy ``src/scripts`` and ``src/json`` to your repository, and create a GitHub action with the script from ``mint_token.yml``.

  - Edit the chain ID on line 60 of ``main.py``

  - Profit.

# Pull Request Standard

In order for the GitHub action to work properly, the Pull Request must be closed and merged. It must also contain a 20 byte Ethereum address, which ``main.py`` will extract from the pull request and mint the token to.

For a full demo, you can check out [Pull Request #3](https://github.com/Jon-Becker/renoun/pull/3)

### Credits

  - Achal ( SVG Design ) https://twitter.com/achalvs