class Note {
  final int id;
  final String title;
  final String content;
  final String? uriImage;
  final String? webLink;
  final int typeColor;
  Note(
      {required this.id,
      required this.title,
      required this.content,
      this.uriImage,
      this.webLink,
      required this.typeColor});
}
