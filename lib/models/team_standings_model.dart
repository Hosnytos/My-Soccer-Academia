class teamStandingsModel {
  late int? leagueID;
  String? leagueName;
  String? leagueLogo;
  late int? leagueSeason;
  String? leagueCountry;
  String? leagueCountryFlag;

  String teamLogo;
  String teamName;
  late int? teamRank;
  late int? teamPlayed;
  late int? teamWin;
  late int? teamDraw;
  late int? teamLose;

  late int? teamGoalDiff;
  late int? teamPoints;

  int teamId = 0;

  teamStandingsModel(
      {this.leagueID,
      this.leagueName,
      this.leagueLogo,
      this.leagueSeason,
      this.leagueCountry,
      this.leagueCountryFlag,
      this.teamRank,
      required this.teamLogo,
      required this.teamName,
      this.teamPlayed,
      this.teamWin,
      this.teamDraw,
      this.teamLose,
      this.teamGoalDiff,
      this.teamPoints,
      required this.teamId});
}
