class Missing_Maps extends Error {
  String id;
  Missing_Maps(this.id);

  @override
  String toString() {
    if (id != null) {
      return 'No Map Called $id found!';
    }
    return 'No id found!';
  }
}
