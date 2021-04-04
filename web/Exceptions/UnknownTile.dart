class Unknown_Tile extends Error {
  String id;
  Unknown_Tile(this.id);

  @override
  String toString() {
    if (id != null) {
      return 'No tile $id found!';
    }
    return 'No id found!';
  }
}
