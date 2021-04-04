class InvalidMove extends Error {
  String id;
  String nextTile;
  InvalidMove(this.id, this.nextTile);

  @override
  String toString() {
    if (id != null) {
      return 'The player cannot move to $id!';
    }
    return 'No id found!';
  }
}
