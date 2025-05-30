class ListPlayers {
  String? idJoue;
  String? nomJoue;
  String? prenomJoue;
  String? naissanceJoue;
  String? posteJoue;
  String? photoJoue;
  String? dossardJoue;
  int? hommeDuMatch;

  ListPlayers({
    this.idJoue,
    this.nomJoue,
    this.prenomJoue,
    this.naissanceJoue,
    this.posteJoue,
    this.photoJoue,
    this.dossardJoue,
    this.hommeDuMatch,
  });

  ListPlayers.fromJson(Map<String, dynamic> json) {
    idJoue = json['id_joue'];
    nomJoue = json['nom_joue'];
    prenomJoue = json['prenom_joue'];
    naissanceJoue = json['naissance_joue'];
    posteJoue = json['poste_joue'];
    photoJoue = json['photo_joue'];
    dossardJoue = json['dossard_joue'];
    hommeDuMatch = json['homme_du_match'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_joue'] = idJoue;
    data['nom_joue'] = nomJoue;
    data['prenom_joue'] = prenomJoue;
    data['naissance_joue'] = naissanceJoue;
    data['poste_joue'] = posteJoue;
    data['photo_joue'] = photoJoue;
    data['dossard_joue'] = dossardJoue;
    data['homme_du_match'] = hommeDuMatch;
    return data;
  }
}
