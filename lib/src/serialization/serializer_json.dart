part of dorm;

class SerializerJson extends SerializerBase {
  
  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------
  
  SerializerJson._contruct();
  
  //-----------------------------------
  //
  // Factories
  //
  //-----------------------------------
  
  factory SerializerJson() => new SerializerJson._contruct();
  
  //-----------------------------------
  //
  // Public methods
  //
  //-----------------------------------
  
  List<Map<String, dynamic>> incoming(String data) => JSON.decode(data);
  
  String outgoing(dynamic data) {
    Entity._serializerWorkaround = this;
    
    convertedEntities = <Entity, Map<String, dynamic>>{};
    
    //if (data is Map) _convertMap(data);
    //else if (data is Iterable) _convertList(data);
    
    if (
        (data is List) ||
        (data is Map)
    ) return JSON.encode(data);
    
    return data.toString();
  }
  
  dynamic convertIn(Type forType, dynamic inValue) {
    final _InternalConvertor convertor = _convertors.firstWhere(
      (_InternalConvertor tmpConvertor) => (tmpConvertor.forType == forType),
      orElse: () => null
    );
    
    return (convertor == null) ? inValue : convertor.incoming(inValue);
  }
  
  dynamic convertOut(Type forType, dynamic outValue) {
    final _InternalConvertor convertor = _convertors.firstWhere(
        (_InternalConvertor tmpConvertor) => (tmpConvertor.forType == forType),
        orElse: () => null
    );
    
    return (convertor == null) ? outValue : convertor.outgoing(outValue);
  }
  
  void _convertMap(Map data, {Map<String, Map<String, dynamic>> convertedEntities: null}) {
    if (convertedEntities == null) convertedEntities = <String, Map<String, dynamic>>{};
    
    data.forEach(
      (K, V) {
        if (V is Map) _convertMap(V, convertedEntities: convertedEntities);
        else if (V is Entity) data[K] = V.toJson(convertedEntities: convertedEntities);
      }
    );
  }
  
  void _convertList(List data, {Map<String, Map<String, dynamic>> convertedEntities: null}) {
    if (convertedEntities == null) convertedEntities = <String, Map<String, dynamic>>{};
    
    final int len = data.length;
    dynamic entry;
    int i;
    
    for (i=0; i<len; i++) {
      entry = data[i];
      
      if (entry is Entity) data[i] = entry.toJson(convertedEntities: convertedEntities);
    }
  }
}