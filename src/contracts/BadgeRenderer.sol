// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// @title  GitHub Renoun Non-Transferrable Tokens
/// @author Jonathan Becker <jonathan@jbecker.dev>
/// @author Badge design by Achal <@achalvs>
/// @notice This contract is an implementation of a rendering client for
///           non-transferrable GitHub contribution badges on the EVM.
/// 
///         https://github.com/Jon-Becker/renoun

contract BadgeRenderer {
  constructor() {}

  /// @param _pullRequestID The ID of the pull request
  /// @param _pullRequestTitle The title of the pull request
  /// @param _additions The number of additions in the pull request
  /// @param _deletions The number of deletions in the pull request
  /// @param _pullRequestCreatorPictureURL The URL of the pull request creator's profile picture
  /// @param _pullRequestCreatorUsername The username of the pull request creator
  /// @param _commitHash The hash of the commit
  /// @param _repositoryOwner The owner of the repository
  /// @param _repositoryName The name of the repository
  /// @param _repositoryStars The number of stars the repository has
  /// @param _repositoryContributors The number of contributors to the repository
  struct Contribution {
    uint256 _pullRequestID;
    string _pullRequestTitle;
    uint256 _additions;
    uint256 _deletions;
    string _pullRequestCreatorPictureURL;
    string _pullRequestCreatorUsername;
    string _commitHash;
    string _repositoryOwner;
    string _repositoryName;
    uint256 _repositoryStars;
    uint256 _repositoryContributors;
  }

  /// @notice Formats an SVG with the provided parameters to build a 
  ///           GitHub contribution badge from the current template.
  /// @param _pullRequestID The ID of the pull request
  /// @param _pullRequestTitle The title of the pull request
  /// @param _additions The number of additions in the pull request
  /// @param _deletions The number of deletions in the pull request
  /// @param _pullRequestCreatorPictureURL The URL of the pull request creator's profile picture
  /// @param _pullRequestCreatorUsername The username of the pull request creator
  /// @param _commitHash The hash of the commit
  /// @param _repositoryOwner The owner of the repository
  /// @param _repositoryName The name of the repository
  /// @param _repositoryStars The number of stars the repository has
  /// @param _repositoryContributors The number of contributors to the repository
  /// @return The SVG with the parameters inserted into it
  function renderPullRequest(
    uint256 _pullRequestID,
    string memory _pullRequestTitle,
    uint256 _additions,
    uint256 _deletions,
    string memory _pullRequestCreatorPictureURL,
    string memory _pullRequestCreatorUsername,
    string memory _commitHash,
    string memory _repositoryOwner,
    string memory _repositoryName,
    uint256 _repositoryStars,
    uint256 _repositoryContributors
  ) public pure returns (string memory) {
    Contribution memory _contribution = Contribution(
      _pullRequestID,
      _pullRequestTitle,
      _additions,
      _deletions,
      _pullRequestCreatorPictureURL,
      _pullRequestCreatorUsername,
      _commitHash,
      _repositoryOwner,
      _repositoryName,
      _repositoryStars,
      _repositoryContributors
    );
    return string(abi.encodePacked(_buildPartOne(_contribution),_buildPartTwo(_contribution),_buildPartThree(_contribution)));
  }

  /// @notice Converts an integer to a string
  /// @param  _i The integer to convert
  /// @return The string representation of the integer
  function _integerToString(uint _i) internal pure returns (string memory) {
    
    if (_i == 0) {
      return "0";
    }
   
    uint j = _i;
    uint len;
    while (j != 0) {
      len++;
      j /= 10;
    }
    bytes memory bstr = new bytes(len);
    uint k = len;
    while (_i != 0) {
      k = k-1;
      uint8 temp = (48 + uint8(_i - _i / 10 * 10));
      bytes1 b1 = bytes1(temp);
      bstr[k] = b1;
      _i /= 10;
    }
    return string(bstr);
  }

  /// @notice Formats an integer to a shortened, less precise string.
  ///           For example, 1200 becomes 1.2k, 98372 becomes 98.3k, etc...
  /// @param _integerAsUint The integer to format
  /// @param _precision The number of decimal places to include in the string
  /// @return The formatted string
  function _formatInteger(uint256 _integerAsUint, uint256 _precision) internal pure returns (string memory) {

    // calculate the length of _integerAsUint
    uint256 len;
    uint256 j = _integerAsUint;
    while (j != 0) {
      len++;
      j /= 10;
    }
    
    // calculates the denominator based off of the length
    uint256 _denominator = 1000 ** ((len - 1) / 3);
    string[6] memory suffices = ["", "k", "m", "b", "t", "q"];
    
    // calculate the quotient and remainder with the given precision
    uint256 _precisionFactor = 10**_precision;
    uint256 _quotient = _integerAsUint / _denominator;
    uint256 _remainder = (_integerAsUint * _precisionFactor / _denominator) % _precisionFactor;
    if(_remainder == 0){
      return string(abi.encodePacked(_integerToString(_quotient), suffices[(len-1)/3] )); 
    }
    return string(abi.encodePacked(_integerToString(_quotient), ".", _integerToString(_remainder), suffices[(len-1)/3] ));
  }

  /// @notice Build the badge SVG in parts because otherwise it causes stack too deep errors
  function _buildPartOne(Contribution memory _contribution) internal pure returns (string memory) {
    return string(abi.encodePacked("<svg width='549' height='507' viewBox='0 0 549 507' fill='none' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink'> <rect width='549' height='507' fill='#2C2C2C'/> <g> <rect width='549' height='507' fill='black'/> <g> <rect x='100' y='48' width='350' height='393' rx='30' fill='#161616'/> <rect x='100' y='48' width='350' height='393' rx='30' fill='url(#paint1504_radial_0_1)' fill-opacity='0.2'/> <rect x='100' y='48' width='350' height='393' rx='30' fill='url(#paint1505_radial_0_1)' fill-opacity='0.2'/> <g> <rect width='325' height='247' rx='21' transform='matrix(1 0 0 -1 113 307)' fill='white' fill-opacity='0.06'/> <rect x='-0.75' y='0.75' width='326.5' height='248.5' rx='21.75' transform='matrix(1 0 0 -1 113 308.5)' stroke='white' stroke-opacity='0.1' stroke-width='1.5'/> </g> <rect x='318' y='294' width='125' height='150' fill='url(#pattern0)'/> <path d='M136.768 399.534C136.526 398.822 135.474 398.822 135.233 399.534L134.369 402.076C134.317 402.231 134.214 402.366 134.076 402.462C133.939 402.558 133.773 402.609 133.603 402.609H130.809C130.026 402.609 129.702 403.567 130.334 404.008L132.594 405.579C132.732 405.675 132.835 405.81 132.887 405.965C132.94 406.12 132.94 406.287 132.888 406.442L132.024 408.985C131.782 409.697 132.633 410.289 133.267 409.849L135.527 408.278C135.665 408.182 135.831 408.13 136.001 408.13C136.171 408.13 136.337 408.182 136.475 408.278L138.735 409.849C139.368 410.289 140.218 409.697 139.977 408.985L139.113 406.442C139.061 406.287 139.061 406.12 139.114 405.965C139.166 405.81 139.269 405.675 139.407 405.579L141.666 404.008C142.298 403.568 141.973 402.61 141.192 402.61H138.398C138.228 402.61 138.062 402.559 137.924 402.463C137.786 402.367 137.684 402.232 137.631 402.077L136.767 399.534L136.768 399.534Z' fill='#F1952A'/> <path d='M 216.333 401.4 C 216.333 402.037 216.088 402.647 215.65 403.097 C 215.212 403.547 214.619 403.8 214 403.8 C 213.381 403.8 212.788 403.547 212.35 403.097 C 211.912 402.647 211.667 402.037 211.667 401.4 C 211.667 400.763 211.912 400.153 212.35 399.703 C 212.788 399.253 213.381 399 214 399 C 214.619 399 215.212 399.253 215.65 399.703 C 216.088 400.153 216.333 400.763 216.333 401.4 Z M 220.222 403 C 220.222 403.424 220.058 403.831 219.767 404.131 C 219.475 404.431 219.079 404.6 218.667 404.6 C 218.254 404.6 217.858 404.431 217.567 404.131 C 217.275 403.831 217.111 403.424 217.111 403 C 217.111 402.576 217.275 402.169 217.567 401.869 C 217.858 401.569 218.254 401.4 218.667 401.4 C 219.079 401.4 219.475 401.569 219.767 401.869 C 220.058 402.169 220.222 402.576 220.222 403 Z M 217.111 408.6 C 217.111 407.751 216.783 406.937 216.2 406.337 C 215.616 405.737 214.825 405.4 214 405.4 C 213.175 405.4 212.384 405.737 211.8 406.337 C 211.217 406.937 210.889 407.751 210.889 408.6 V 411 H 217.111 V 408.6 Z M 210.889 403 C 210.889 403.424 210.725 403.831 210.433 404.131 C 210.142 404.431 209.746 404.6 209.333 404.6 C 208.921 404.6 208.525 404.431 208.233 404.131 C 207.942 403.831 207.778 403.424 207.778 403 C 207.778 402.576 207.942 402.169 208.233 401.869 C 208.525 401.569 208.921 401.4 209.333 401.4 C 209.746 401.4 210.142 401.569 210.433 401.869 C 210.725 402.169 210.889 402.576 210.889 403 Z M 218.667 411 V 408.6 C 218.668 407.787 218.467 406.986 218.083 406.275 C 218.428 406.184 218.789 406.176 219.137 406.25 C 219.486 406.324 219.813 406.48 220.094 406.704 C 220.376 406.928 220.604 407.216 220.761 407.544 C 220.917 407.873 220.999 408.234 221 408.6 V 411 H 218.667 Z M 209.917 406.275 C 209.533 406.986 209.332 407.787 209.333 408.6 V 411 H 207 V 408.6 C 207 408.234 207.081 407.872 207.238 407.543 C 207.395 407.214 207.623 406.926 207.904 406.702 C 208.186 406.478 208.513 406.322 208.862 406.248 C 209.211 406.174 209.572 406.184 209.917 406.275 Z' fill='#C6C6C6'/> <path d='M143 240C143.265 240 143.52 240.105 143.707 240.293C143.895 240.48 144 240.735 144 241V244H147C147.265 244 147.52 244.105 147.707 244.293C147.895 244.48 148 244.735 148 245C148 245.265 147.895 245.52 147.707 245.707C147.52 245.895 147.265 246 147 246H144V249C144 249.265 143.895 249.52 143.707 249.707C143.52 249.895 143.265 250 143 250C142.735 250 142.48 249.895 142.293 249.707C142.105 249.52 142 249.265 142 249V246H139C138.735 246 138.48 245.895 138.293 245.707C138.105 245.52 138 245.265 138 245C138 244.735 138.105 244.48 138.293 244.293C138.48 244.105 138.735 244 139 244H142V241C142 240.735 142.105 240.48 142.293 240.293C142.48 240.105 142.735 240 143 240Z' fill='#62E96F'/> <path d='M 211 245 C 211 244.735 211.105 244.48 211.293 244.293 C 211.48 244.105 211.735 244 212 244 H 220 C 220.265 244 220.52 244.105 220.707 244.293 C 220.895 244.48 221 244.735 221 245 C 221 245.265 220.895 245.52 220.707 245.707 C 220.52 245.895 220.265 246 220 246 H 212 C 211.735 246 211.48 245.895 211.293 245.707 C 211.105 245.52 211 245.265 211 245 Z' fill='#F84364'/> <path opacity='0.1' d='M113 272H438' stroke='white'/> <path opacity='0.3' d='M133.612 294.173C135.486 294.173 136.774 293.08 137.211 291.55L136.211 291.182C135.877 292.298 135.003 293.137 133.612 293.137C132.128 293.137 130.714 292.045 130.714 289.917C130.714 287.79 132.128 286.709 133.612 286.709C134.946 286.709 135.843 287.399 136.153 288.629L137.2 288.261C136.786 286.686 135.475 285.674 133.612 285.674C131.588 285.674 129.564 287.192 129.564 289.917C129.564 292.643 131.507 294.173 133.612 294.173ZM140.938 293.206C140.018 293.206 139.213 292.516 139.213 291.228C139.213 289.952 140.018 289.262 140.938 289.262C141.858 289.262 142.663 289.952 142.663 291.228C142.663 292.516 141.858 293.206 140.938 293.206ZM140.938 288.296C139.282 288.296 138.109 289.549 138.109 291.228C138.109 292.919 139.282 294.173 140.938 294.173C142.594 294.173 143.767 292.919 143.767 291.228C143.767 289.549 142.594 288.296 140.938 288.296ZM146.217 294V290.665C146.217 289.837 146.734 289.262 147.505 289.262C148.333 289.262 148.678 289.814 148.678 290.527V294H149.759V290.653C149.759 289.86 150.276 289.262 151.035 289.262C151.852 289.262 152.208 289.802 152.208 290.527V294H153.278V290.412C153.278 288.963 152.335 288.307 151.369 288.307C150.667 288.307 149.954 288.56 149.517 289.354C149.218 288.641 148.551 288.307 147.861 288.307C147.217 288.307 146.527 288.595 146.182 289.204V288.468H145.147V294H146.217ZM156.032 294V290.665C156.032 289.837 156.55 289.262 157.32 289.262C158.148 289.262 158.493 289.814 158.493 290.527V294H159.574V290.653C159.574 289.86 160.092 289.262 160.851 289.262C161.667 289.262 162.024 289.802 162.024 290.527V294H163.093V290.412C163.093 288.963 162.15 288.307 161.184 288.307C160.483 288.307 159.77 288.56 159.333 289.354C159.034 288.641 158.367 288.307 157.677 288.307C157.033 288.307 156.343 288.595 155.998 289.204V288.468H154.963V294H156.032ZM165.848 294V288.468H164.778V294H165.848ZM164.537 286.375C164.537 286.801 164.882 287.146 165.307 287.146C165.744 287.146 166.089 286.801 166.089 286.375C166.089 285.938 165.744 285.593 165.307 285.593C164.882 285.593 164.537 285.938 164.537 286.375ZM169.104 286.72H168.115V287.617C168.115 288.1 167.862 288.468 167.264 288.468H166.965V289.446H168.023V292.482C168.023 293.482 168.621 294.058 169.564 294.058C169.932 294.058 170.208 293.988 170.3 293.954V293.034C170.208 293.057 170.012 293.08 169.874 293.08C169.311 293.08 169.104 292.827 169.104 292.321V289.446H170.3V288.468H169.104V286.72Z' fill='white'/> <g> <text x='138' y='99' font-size='16px' weight='400' fill='#bfbfbf' font-family='arial'>Pull Request <tspan fill='#CCFF00'>#",_integerToString(_contribution._pullRequestID),"</tspan></text> <foreignObject x='138' y='115' width='263' height='105'> <span xmlns='http://www.w3.org/1999/xhtml' style='font-size: 30px; font-weight: 500; color: #ffffff; font-family: arial;'>",_contribution._pullRequestTitle,"</span> </foreignObject> <text x='154' y='250' fill='#808080' font-size='14px' font-weight='300' font-family='arial'>",_formatInteger(_contribution._additions, 1),"</text> <text x='227' y='250' fill='#808080' font-size='14px' font-weight='300' font-family='arial'>",_formatInteger(_contribution._deletions, 1),"</text> <foreignObject x='261' y='231' width='159' height='25' style='text-overflow: ellipses;'> <img xmlns='http://www.w3.org/1999/xhtml' src='"));
  }
  function _buildPartTwo(Contribution memory _contribution) internal pure returns (string memory) {
    return string(abi.encodePacked(_contribution._pullRequestCreatorPictureURL,"' style='margin-left: auto; border-radius: 50%; width: 25px; height: 25px; margin-right:7px;'></img> <span xmlns='http://www.w3.org/1999/xhtml' style='position: absolute; right: 0; max-width: 120px; overflow: hidden; transform: translateY(5px); font-size: 15px; font-weight: 450; font-family: arial; color: #ffffff;'>",_contribution._pullRequestCreatorUsername,"</span></foreignObject> <text x='177' y='293.5' fill='#bfbfbf' font-size='11.5px' font-weight='400' font-family='arial'>",_contribution._commitHash,"</text> <text x='130' y='342' fill='#808080' font-size='14px' font-weight='300' font-family='arial'>",_contribution._repositoryOwner,"/</text> <text x='130' y='378' fill='#ffffff' font-size='30px' font-weight='500' font-family='arial'>"));
  }
  function _buildPartThree(Contribution memory _contribution) internal pure returns (string memory) {
    return string(abi.encodePacked(_contribution._repositoryName,"</text> <text x='147' y='410' fill='#808080' font-size='14px' font-weight='300' font-family='arial'>",_formatInteger(_contribution._repositoryStars, 1),"</text> <text x='227' y='410' fill='#808080' font-size='14px' font-weight='300' font-family='arial'>",_formatInteger(_contribution._repositoryContributors, 1),"</text> </g> </g> </g> <defs> <filter id='filter0_b_0_1' x='17.5' y='-35.5' width='516' height='438' filterUnits='userSpaceOnUse' color-interpolation-filters='sRGB'> <feFlood flood-opacity='0' result='BackgroundImageFix'/> <feGaussianBlur in='BackgroundImage' stdDeviation='47'/> <feComposite in2='SourceAlpha' operator='in' result='effect1_backgroundBlur_0_1'/> <feBlend mode='normal' in='SourceGraphic' in2='effect1_backgroundBlur_0_1' result='shape'/> </filter> <pattern id='pattern0' patternContentUnits='objectBoundingBox' width='1' height='1'> <use xlink:href='#image0_0_1' transform='scale(0.000454545)'/> </pattern> <pattern id='pattern1' patternContentUnits='objectBoundingBox' width='1' height='1'> <use xlink:href='#image1_0_1' transform='scale(0.0025)'/> </pattern> <radialGradient id='paint1504_radial_0_1' cx='0' cy='0' r='1' gradientUnits='userSpaceOnUse' gradientTransform='translate(388.5 376) rotate(-107.149) scale(225.527 188.328)'> <stop stop-color='#CEFF00' stop-opacity='0.35'/> <stop offset='1' stop-color='#CEFF00' stop-opacity='0'/> </radialGradient> <radialGradient id='paint1505_radial_0_1' cx='0' cy='0' r='1' gradientUnits='userSpaceOnUse' gradientTransform='translate(264 173.5) rotate(106.601) scale(306.265 272.755)'> <stop stop-color='white' stop-opacity='0.49'/> <stop offset='1' stop-color='white' stop-opacity='0'/> </radialGradient> <image id='image0_0_1' href='https://jbecker.dev/assets/images/Shield.png' width='2200' height='2200'></image> </defs> </svg>"));
  }

}