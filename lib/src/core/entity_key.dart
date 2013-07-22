part of dorm;

class EntityKey {
  
  //---------------------------------
  //
  // Private properties
  //
  //---------------------------------
  
  Map<int, Map<dynamic, EntityKey>> _map = new Map<int, Map<dynamic, EntityKey>>();
  
  //---------------------------------
  //
  // Public properties
  //
  //---------------------------------
  
  List<EntityScan> entityScans = <EntityScan>[];
  
  //---------------------------------
  //
  // Constructor
  //
  //---------------------------------
  
  EntityKey();
  
  //---------------------------------
  //
  // Operator overloads
  //
  //---------------------------------
  
  void operator []= (int key, dynamic value) {
    _setKeyValue(key, value);
  }
  
  EntityKey operator [] (List otherKey) => _map[otherKey[0]][otherKey[1]];
  
  //---------------------------------
  //
  // Public methods
  //
  //---------------------------------
  
  Entity getFirstSibling(Entity forEntity) {
    EntityScan result = forEntity._scan._keyCollection.firstWhere(
      (EntityScan scan) => (scan.entity != forEntity),
      orElse: () => null
    );
    
    return (result != null) ? result.entity : null;
  }
  
  bool areSameKeySignature(Entity entity, Entity compareEntity) => entity._scan._keyCollection.contains(compareEntity._scan);
  
  bool remove(Entity entity) => entity._scan._keyCollection.remove(entity._scan);
  
  Iterable<EntityScan> getSiblings(Entity forEntity) => forEntity._scan._keyCollection.where(
      (EntityScan scan) => (scan.entity != forEntity)    
  );
  
  List<EntityScan> getExistingEntityScans(Entity forEntity) => forEntity._scan._keyCollection;
  
  //---------------------------------
  //
  // Private methods
  //
  //---------------------------------
  
  EntityKey _setKeyValue(int key, dynamic value) {
    EntityKey returnValue;
    Map<dynamic, EntityKey> mainKey = _map[key];
    
    if (mainKey == null) {
      mainKey = _map[key] = new Map<dynamic, EntityKey>();
      
      returnValue = new EntityKey();
      
      mainKey[value] = returnValue;
      
      return returnValue;
    } else if (!mainKey.containsKey(value)) {
      returnValue = new EntityKey();
      
      mainKey[value] = returnValue;
      
      return returnValue;
    }
    
    return mainKey[value];
  }
}