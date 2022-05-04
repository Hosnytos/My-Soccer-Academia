class fixturesDetails {
  late int fixtureID;
  String? fixtureStatus;
  // TEAMS Stats
  late int homeID;
  late int awayID;
  String? homeLogo;
  String? awayLogo;
  String? homeName;
  String? awayName;
  late int? homeScore;
  late int? awayScore;
  bool? homeStatus;
  bool? awayStatus;

  int? fixtureTime;
  String? fixtureStadium;
  String? fixtureDate;

  //Fixtures Stats
  late int? homeShots;
  late int? awayShots;
  late int? homeShotsOnGoal;
  late int? awayShotsOnGoal;
  String? homeBallPossession;
  String? awayBallPossession;
  String? homePasses;
  String? awayPasses;
  late int? homeFouls;
  late int? awayFouls;
  late int? homeYellowCards;
  late int? awayYellowCards;
  late int? homeRedCards;
  late int? awayRedCards;
  late int? homeCorners;
  late int? awayCorners;

  //Lineups
  String? homeCoachName;
  String? homeCoachPhoto;
  String? homeFormation;

  String? awayCoachName;
  String? awayCoachPhoto;
  String? awayFormation;

  String? leagueCountry;
  String? leagueFlag;

  List<String> homeStarter = [];
  List<String> awayStarter = [];
  List<String> homeSubtit = [];
  List<String> awaySubtit = [];

  bool? onFav = false;

  fixturesDetails({
    this.onFav,
    required this.fixtureID,
    this.fixtureStatus,
    required this.homeID,
    required this.awayID,
    this.homeLogo,
    this.awayLogo,
    this.homeName,
    this.awayName,
    this.homeScore,
    this.awayScore,
    this.homeStatus,
    this.awayStatus,
    this.fixtureTime,
    this.fixtureStadium,
    this.fixtureDate,
    this.homeShots,
    this.awayShots,
    this.homeShotsOnGoal,
    this.awayShotsOnGoal,
    this.homeBallPossession,
    this.awayBallPossession,
    this.homePasses,
    this.awayPasses,
    this.homeFouls,
    this.awayFouls,
    this.homeYellowCards,
    this.awayYellowCards,
    this.homeRedCards,
    this.awayRedCards,
    this.homeCorners,
    this.awayCorners,
    this.homeCoachName,
    this.homeCoachPhoto,
    this.homeFormation,
    this.awayCoachName,
    this.awayCoachPhoto,
    this.awayFormation,
    required this.homeStarter,
    required this.awayStarter,
    required this.homeSubtit,
    required this.awaySubtit,
    this.leagueCountry,
    this.leagueFlag,
  });
}
