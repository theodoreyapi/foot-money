class MatchModel {
  String? libelleStade;
  String? equipeOne;
  String? equipeOneLogo;
  String? equipeTwo;
  String? equipeTwoLogo;
  String? idMatch;
  String? debut;
  String? heure;
  int? journee;
  String? clubOneId;
  String? clubTwoId;
  String? stadeId;
  String? statut;
  String? totalVote;

  MatchModel({
    this.libelleStade,
    this.equipeOne,
    this.equipeOneLogo,
    this.equipeTwo,
    this.equipeTwoLogo,
    this.idMatch,
    this.debut,
    this.heure,
    this.journee,
    this.clubOneId,
    this.clubTwoId,
    this.stadeId,
    this.statut,
    this.totalVote,
  });

  MatchModel.fromJson(Map<String, dynamic> json) {
    libelleStade = json['libelle_stade'];
    equipeOne = json['equipe_one'];
    equipeOneLogo = json['equipe_one_logo'];
    equipeTwo = json['equipe_two'];
    equipeTwoLogo = json['equipe_two_logo'];
    idMatch = json['id_match'];
    debut = json['debut'];
    heure = json['heure'];
    journee = json['journee'];
    clubOneId = json['club_one_id'];
    clubTwoId = json['club_two_id'];
    stadeId = json['stade_id'];
    statut = json['statut'];
    totalVote = json['total_votes_display'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['libelle_stade'] = libelleStade;
    data['equipe_one'] = equipeOne;
    data['equipe_one_logo'] = equipeOneLogo;
    data['equipe_two'] = equipeTwo;
    data['equipe_two_logo'] = equipeTwoLogo;
    data['id_match'] = idMatch;
    data['debut'] = debut;
    data['heure'] = heure;
    data['journee'] = journee;
    data['club_one_id'] = clubOneId;
    data['club_two_id'] = clubTwoId;
    data['stade_id'] = stadeId;
    data['statut'] = statut;
    data['total_votes_display'] = totalVote;
    return data;
  }
}
