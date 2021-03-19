class Element_Not_Found_Exception extends Error {
  String id;
  Element_Not_Found_Exception(this.id);

  @override
  String toString() {
    if (id != null) {
      return 'Element $id not found!';
    }
    return 'No id found!';
  }
}

class Wrong_Element_Exception extends Error {
  String id;
  String expected;
  String actual;
  Wrong_Element_Exception(this.id, this.expected, this.actual);

  @override
  String toString() {
    return 'Element $id not of type $expected, found $actual instead!';
  }
}
