class BooruImage {
  String source;
  String directory;
  String hash;
  int height;
  int id;
  String image;
  int change;
  String owner;
  var parentId;
  String rating;
  bool sample;
  int sampleHeight;
  int sampleWidth;
  int score;
  String tags;
  int width;
  String fileUrl;
  String createdAt;

  BooruImage(
      {this.source,
      this.directory,
      this.hash,
      this.height,
      this.id,
      this.image,
      this.change,
      this.owner,
      this.parentId,
      this.rating,
      this.sample,
      this.sampleHeight,
      this.sampleWidth,
      this.score,
      this.tags,
      this.width,
      this.fileUrl,
      this.createdAt});

  BooruImage.fromJson(Map<String, dynamic> json) {
    source = json['source'];
    directory = json['directory'];
    hash = json['hash'];
    height = json['height'];
    id = json['id'];
    image = json['image'];
    change = json['change'];
    owner = json['owner'];
    parentId = json['parent_id'];
    rating = json['rating'];
    sample = json['sample'];
    sampleHeight = json['sample_height'];
    sampleWidth = json['sample_width'];
    score = json['score'];
    tags = json['tags'];
    width = json['width'];
    fileUrl = json['file_url'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['source'] = this.source;
    data['directory'] = this.directory;
    data['hash'] = this.hash;
    data['height'] = this.height;
    data['id'] = this.id;
    data['image'] = this.image;
    data['change'] = this.change;
    data['owner'] = this.owner;
    data['parent_id'] = this.parentId;
    data['rating'] = this.rating;
    data['sample'] = this.sample;
    data['sample_height'] = this.sampleHeight;
    data['sample_width'] = this.sampleWidth;
    data['score'] = this.score;
    data['tags'] = this.tags;
    data['width'] = this.width;
    data['file_url'] = this.fileUrl;
    data['created_at'] = this.createdAt;
    return data;
  }

  static List<BooruImage> getImages(List list) {
    List<BooruImage> images = new List();
    list.forEach((image){
      BooruImage parsed = BooruImage.fromJson(image);
      images.add(parsed);
    });
    return images;
  }
}