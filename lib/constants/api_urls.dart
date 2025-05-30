class ApiUrls {
  ApiUrls._();

  // Base Url
  static const baseUrl = "http://footmoney.sodalite-consulting.com/api";

  // Authentification
  static const String postLoginUrl = "$baseUrl/loginUser";
  static const String postRegisterUrl = "$baseUrl/createUser";
  static const String postNewPasswordUrl = "$baseUrl/passwordUser";
  static const String postAddPhotoUrl = "$baseUrl/photoUser";
  static const String postAddEmailUrl = "$baseUrl/addEmailUser";

  // News
  static const String getListNewsUrl = "$baseUrl/news";
  static const String postAddViewNewsUrl = "$baseUrl/news";

  // Votes
  static const String getStateVoteUrl = "$baseUrl/cumulVote/"; // mettre ID match devant
  static const String postAddVoteUrl = "$baseUrl/vote";
  static const String postAddDonUrl = "$baseUrl/dons";

  // Matchs
  static const String getMatchUrl = "$baseUrl/matchs/";
  static const String getHistoryUrl = "$baseUrl/history/";
  static const String getPlayerUrl = "$baseUrl/players/";
}