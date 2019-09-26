
// File: @openzeppelin/contracts/math/Math.sol

pragma solidity ^0.5.0;

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
}

// File: @openzeppelin/contracts/ownership/Ownable.sol

pragma solidity ^0.5.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be aplied to your functions to restrict their use to
 * the owner.
 */
contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * > Note: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: @openzeppelin/contracts/math/SafeMath.sol

pragma solidity ^0.5.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}

// File: contracts/UserBonus.sol

pragma solidity ^0.5.0;




contract UserBonus {

    using SafeMath for uint256;

    uint256 public constant BONUS_PERCENTS_PER_DAY = 1;

    struct UserBonusData {
        uint256 totalPaid;
        uint256 lastPaidTime;
        uint256 numberOfUsers;
        mapping(address => uint256) userPaid;
    }

    UserBonusData public bonus;

    event BonusPaid(uint256 users, uint256 amount);
    event UserAddedToBonus(address indexed user);

    function payRepresentativeBonus() public {
        require(bonus.numberOfUsers > 0);

        uint256 reward = address(this).balance.mul(BONUS_PERCENTS_PER_DAY).div(100)
            .mul(now.sub(bonus.lastPaidTime)).div(1 days);
        bonus.totalPaid = bonus.totalPaid.add(reward);
        bonus.lastPaidTime = now;
        emit BonusPaid(bonus.numberOfUsers, reward);
    }

    function userAddedToBonus(address user) public view returns(bool) {
        return bonus.userPaid[user] > 0;
    }

    function userBonus(address user) public view returns(uint256) {
        if (!userAddedToBonus(user)) {
            return 0;
        }
        return bonus.totalPaid.sub(bonus.userPaid[user]).div(bonus.numberOfUsers);
    }

    function retrieveBonus() public {
        msg.sender.transfer(userBonus(msg.sender));
        bonus.userPaid[msg.sender] = bonus.totalPaid;
    }

    function _addUserToBonus(address user) internal {
        require(bonus.userPaid[user] == 0);
        bonus.userPaid[user] = bonus.totalPaid;
        bonus.numberOfUsers = bonus.numberOfUsers.add(1);
        emit UserAddedToBonus(user);
    }
}

// File: contracts/BeeBee.sol

pragma solidity ^0.5.0;





contract BeeBee is Ownable, UserBonus {

    struct Player {
        bool registered;
        bool airdropCollected;
        address referrer;
        uint256 balanceHoney;
        uint256 balanceWax;
        uint256 points;
        uint256 medals;
        uint256 qualityLevel;
        uint256 lastTimeCollected;
        uint256[BEES_COUNT] bees;

        uint256 totalDeposited;
        uint256 totalWithdrawed;
        uint256 referralsTotalDeposited;
        uint256 subreferralsCount;
        address[] referrals;
    }

    uint256 public constant BEES_COUNT = 8;
    uint256 public constant MEDALS_COUNT = 10;
    uint256 public constant QUALITIES_COUNT = 6;
    uint256[BEES_COUNT] public BEES_PRICES = [0, 4000, 20000, 100000, 300000, 1000000, 2000000, 625000];
    uint256[BEES_COUNT] public BEES_LEVELS_PRICES = [0, 0, 30000, 150000, 450000, 1500000, 3000000, 0];
    uint256[BEES_COUNT] public BEES_MONTHLY_PERCENTS = [0, 100, 102, 104, 106, 108, 111, 125];
    uint256[MEDALS_COUNT] public MEDALS_POINTS = [0, 100000, 200000, 520000, 1040000, 2080000, 5200000, 10400000, 15600000, 26100000];
    uint256[MEDALS_COUNT] public MEDALS_REWARDS = [0, 6250, 12500, 31250, 62500, 125000, 312500, 625000, 937500, 1562500];
    uint256[QUALITIES_COUNT] public QUALITY_HONEY_PERCENT = [40, 42, 44, 46, 48, 50];
    uint256[QUALITIES_COUNT] public QUALITY_PRICE = [0, 50000, 150000, 375000, 750000, 1250000];

    uint256 public constant COINS_PER_ETH = 500000;
    uint256 public constant MAX_BEES_PER_TARIFF = 32;
    uint256 public constant FIRST_BEE_AIRDROP_AMOUNT = 1000;
    uint256 public constant ADMIN_PERCENT = 10;
    uint256 public constant HONEY_DISCOUNT_PERCENT = 10;
    uint256[] public REFERRAL_PERCENT_PER_LEVEL = [5, 3, 2];
    uint256[] public REFERRAL_POINT_PERCENT = [50, 25, 0];

    uint256 public totalPlayers;
    mapping(address => Player) public players;

    event Registered(address indexed user, address indexed referrer);
    event Deposited(address indexed user, uint256 amount);
    event Withdrawed(address indexed user, uint256 amount);
    event ReferrerPaid(address indexed user, address indexed referrer, uint256 indexed level, uint256 amount);
    event MedalAwarded(address indexed user, uint256 indexed medal);
    event QualityUpdated(address indexed user, uint256 indexed quality);

    function referrals(address user) public view returns(address[] memory) {
        return players[user].referrals;
    }

    function referrerOf(address user, address ref) public view returns(address) {
        if (players[user].referrer != address(0)) {
            return players[user].referrer;
        }
        if (players[user].totalDeposited == 0) {
            return ref;
        }
        return address(0);
    }

    function deposit(address ref) public payable {
        Player storage player = players[msg.sender];
        address refAddress = referrerOf(msg.sender, ref);

        // Register player
        if (!player.registered) {
            player.registered = true;
            player.bees[0] = MAX_BEES_PER_TARIFF;
            totalPlayers++;

            if (refAddress != address(0)) {
                player.referrer = refAddress;
                players[refAddress].referrals.push(msg.sender);

                if (players[refAddress].referrer != address(0)) {
                    players[players[refAddress].referrer].subreferralsCount++;
                }
            }
            emit Registered(msg.sender, refAddress);
        }

        // Update player record
        uint256 wax = msg.value.mul(COINS_PER_ETH);
        player.balanceWax = player.balanceWax.add(wax);
        player.totalDeposited = player.totalDeposited.add(msg.value);
        player.points = player.points.add(wax);
        emit Deposited(msg.sender, msg.value);

        collectMedals(msg.sender);

        // Pay admin fee fees
        players[owner()].balanceHoney = players[owner()].balanceHoney.add(
            msg.value.mul(ADMIN_PERCENT).div(100)
        );

        // Update referrer record if exist
        if (refAddress != address(0)) {
            Player storage referrer = players[refAddress];

            // Pay ref rewards
            address to = refAddress;
            for (uint i = 0; to != address(0) && i < REFERRAL_PERCENT_PER_LEVEL.length; i++) {
                uint256 reward = msg.value.mul(REFERRAL_PERCENT_PER_LEVEL[i]).div(100);
                players[to].balanceHoney = players[to].balanceHoney.add(reward);
                players[to].points = players[to].points.add(wax.mul(REFERRAL_POINT_PERCENT[i]).div(100));
                emit ReferrerPaid(msg.sender, to, i + 1, reward);
                collectMedals(to);

                to = players[to].referrer;
            }

            referrer.referralsTotalDeposited = referrer.referralsTotalDeposited.add(msg.value);
            _addToBonusIfNeeded(refAddress);
        }

        _addToBonusIfNeeded(msg.sender);
    }

    function withdraw(uint256 amount) public {
        Player storage player = players[msg.sender];

        uint256 value = amount.div(COINS_PER_ETH);
        player.balanceHoney = player.balanceHoney.sub(amount);
        player.totalWithdrawed = player.totalWithdrawed.add(value);
        msg.sender.transfer(value);
        emit Withdrawed(msg.sender, value);
    }

    function collect() public {
        Player storage player = players[msg.sender];

        uint256 collected = earned(msg.sender);
        player.balanceHoney = collected.mul(QUALITY_HONEY_PERCENT[player.qualityLevel]).div(100);
        player.balanceWax = collected.mul(100 - QUALITY_HONEY_PERCENT[player.qualityLevel]).div(100);
        player.lastTimeCollected = now;
        if (!player.airdropCollected) {
            player.airdropCollected = true;
        }
    }

    function buyBees(uint256 bee, uint256 count) public payable {
        Player storage player = players[msg.sender];

        if (msg.value > 0) {
            deposit(address(0));
        }

        collect();

        require(bee < 2 || player.bees[bee - 1] == MAX_BEES_PER_TARIFF);
        if (player.bees[bee] == 0) {
            _payWithWaxOnly(msg.sender, BEES_LEVELS_PRICES[bee]);
        }

        require(player.bees[bee].add(count) <= MAX_BEES_PER_TARIFF);
        player.bees[bee] = player.bees[bee].add(count);
        _payWithWaxAndHoney(msg.sender, BEES_PRICES[bee].mul(count));
    }

    function updateQualityLevel() public payable {
        Player storage player = players[msg.sender];

        require(player.qualityLevel < QUALITIES_COUNT);
        _payWithHoneyOnly(msg.sender, QUALITY_PRICE[player.qualityLevel + 1]);
        player.qualityLevel++;
        emit QualityUpdated(msg.sender, player.qualityLevel);
    }

    function earned(address user) public view returns(uint256) {
        Player storage player = players[user];

        uint256 total = 0;
        if (!player.airdropCollected) {
            total = total.add(FIRST_BEE_AIRDROP_AMOUNT);
        }

        for (uint i = 0; i < BEES_COUNT; i++) {
            total = total.add(
                player.bees[i].mul(BEES_PRICES[i]).mul(BEES_MONTHLY_PERCENTS[i]).div(100)
            );
        }

        return total
            .mul(now.sub(player.lastTimeCollected))
            .div(30 days);
    }

    function collectMedals(address user) public {
        Player storage player = players[user];

        for (uint i = player.medals; i < MEDALS_COUNT; i++) {
            if (player.points > MEDALS_POINTS[i]) {
                player.balanceWax = player.balanceWax.add(MEDALS_REWARDS[i]);
                player.medals = i + 1;
                emit MedalAwarded(user, i + 1);
            }
        }
    }

    function _payWithHoneyOnly(address user, uint256 amount) internal {
        Player storage player = players[user];
        player.balanceHoney = player.balanceHoney.sub(amount);
    }

    function _payWithWaxOnly(address user, uint256 amount) internal {
        Player storage player = players[user];
        player.balanceWax = player.balanceWax.sub(amount);
    }

    function _payWithWaxAndHoney(address user, uint256 amount) internal {
        Player storage player = players[user];

        uint256 wax = Math.min(amount, player.balanceWax);
        player.balanceWax = player.balanceWax.sub(wax);
        _payWithHoneyOnly(user, amount.sub(wax).mul(100 - HONEY_DISCOUNT_PERCENT).div(100));
    }

    function _addToBonusIfNeeded(address user) internal {
        if (user != address(0) && !userAddedToBonus(user)) {
            Player storage player = players[user];

            if (player.totalDeposited >= 5 ether &&
                player.referrals.length >= 10 &&
                player.referralsTotalDeposited >= 50 ether)
            {
                _addUserToBonus(user);
            }
        }
    }
}