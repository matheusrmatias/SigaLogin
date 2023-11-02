class Update{
  bool available;
  String version;
  String sha256;
  String link;
  Map<String,dynamic> changelog;

  Update({required this.available, required this.version, required this.sha256, required this.changelog, required this.link});

  Update.empty({this.available=false, this.version='0', this.sha256='',this.changelog=const {}, this.link = ''});
}