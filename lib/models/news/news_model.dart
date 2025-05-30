class NewsModel {
  String? idNews;
  String? titreNews;
  String? contenuNews;
  String? photoNews;
  int? viewNews;
  String? createdAt;

  NewsModel({
    this.idNews,
    this.titreNews,
    this.contenuNews,
    this.photoNews,
    this.viewNews,
    this.createdAt,
  });

  NewsModel.fromJson(Map<String, dynamic> json) {
    idNews = json['id_news'];
    titreNews = json['titre_news'];
    contenuNews = json['contenu_news'];
    photoNews = json['photo_news'];
    viewNews = json['view_news'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_news'] = idNews;
    data['titre_news'] = titreNews;
    data['contenu_news'] = contenuNews;
    data['photo_news'] = photoNews;
    data['view_news'] = viewNews;
    data['created_at'] = createdAt;
    return data;
  }
}
