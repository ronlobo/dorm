part of dorm;

class ConflictManager {
  
  //-----------------------------------
  //
  // Static properties
  //
  //-----------------------------------
  
  static const ConflictManager ACCEPT_SERVER = const ConflictManager(1);
  static const ConflictManager ACCEPT_CLIENT = const ConflictManager(2);
  static const ConflictManager ACCEPT_SERVER_DIRTY = const ConflictManager(3);
  
  //-----------------------------------
  //
  // Public properties
  //
  //-----------------------------------
  
  final int type;
  
  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------

  const ConflictManager(this.type);
  
}