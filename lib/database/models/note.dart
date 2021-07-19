class NoteFields {
  static final List<String> values = [
    id,
    title,
    content,
    uriImage,
    webLink,
    typeColor
  ];
  static final String id = 'id';
  static final String title = 'title';
  static final String content = 'content';
  static final String uriImage = 'uriImage';
  static final String webLink = 'webLink';
  static final String typeColor = 'typeColor';
}

class Note {
  final int id;
  final String title;
  final String content;
  final String? uriImage;
  final String? webLink;
  final int typeColor;
  const Note(
      {required this.id,
      required this.title,
      required this.content,
      this.uriImage,
      this.webLink,
      required this.typeColor});
}
