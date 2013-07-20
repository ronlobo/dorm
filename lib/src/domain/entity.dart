part of dorm;

abstract class Entity extends ObservableBase implements IExternalizable {
  
  //-----------------------------------
  //
  // Private properties
  //
  //-----------------------------------
  
  List<DormProxy> _proxies = <DormProxy>[];
  Map _source;
  EntityScan _scan;
  bool _isPointer;
  int _uid;
  
  //-----------------------------------
  //
  // Public properties
  //
  //-----------------------------------
  
  //-----------------------------------
  // refClassName
  //-----------------------------------
  
  String get refClassName => null;
  
  //-----------------------------------
  //
  // Operator overloads
  //
  //-----------------------------------
  
  dynamic operator [](String propertyName) {
    _ProxyEntry entry;
    List<_ProxyEntry> proxies = _scan._proxies;
    int i = proxies.length;
    
    while (i > 0) {
      entry = proxies[--i];
      
      if (entry.property == propertyName) {
        return entry.proxy.value;
      }
    }
    
    return null;
  }
  
  void operator []=(String propertyName, dynamic propertyValue) {
    _ProxyEntry entry;
    List<_ProxyEntry> proxies = _scan._proxies;
    int i = proxies.length;
    
    while (i > 0) {
      entry = proxies[--i];
      
      if (entry.property == propertyName) {
        entry.proxy.value = notifyPropertyChange(
            entry.proxy.propertySymbol, 
            entry.proxy.value,
            propertyValue
        );
      }
    }
    
    return null;
  }
  
  //-----------------------------------
  //
  // Public methods
  //
  //-----------------------------------
  
  void validate() {
    List<_ProxyEntry> proxies = _scan._proxies;
    int i = proxies.length;
    
    while (i > 0) {
      proxies[--i].proxy.validate();
    }
  }
  
  bool isDirty() {
    _ProxyEntry entry;
    List<_ProxyEntry> proxies = _scan._proxies;
    int i = proxies.length;
    
    while (i > 0) {
      entry = proxies[--i];
      
      if (entry.proxy._value != entry.proxy._defaultValue) {
        return true;
      }
    }
    
    return false;
  }
  
  void readExternal(Map<String, dynamic> data, OnConflictFunction onConflict) {
    EntityFactory<Entity> factory = new EntityFactory(onConflict);
    _ProxyEntry entry;
    List<_ProxyEntry> proxies;
    Iterable<Map<String, dynamic>> spawnList = new List<Map<String, dynamic>>(1);
    DormProxy proxy;
    dynamic entryValue;
    
    _isPointer = data.containsKey(SerializationType.POINTER);
    
    proxies = _isPointer ? _scan._identityProxies : _scan._proxies;
    
    int i = proxies.length;
    
    while (i > 0) {
      entry = proxies[--i];
      
      entryValue = data[entry.property];
      
      proxy = entry.proxy;
      
      if (entryValue is Map) {
        spawnList[0] = entryValue;
        
        proxy._initialValue = factory.spawn(spawnList, proxy:proxy).first;
      } else if (entryValue is Iterable) {
        proxy._initialValue = proxy.owner = new ObservableList.from(factory.spawn(entryValue));
      } else {
        proxy._initialValue = entryValue;
      }
    }
  }
  
  void writeExternal(Map<String, dynamic> data) {
    _writeExternalImpl(data, null);
  }
  
  String toJson({Map<String, Map<String, dynamic>> convertedEntities}) {
    Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    
    writeExternal(jsonMap);
    
    return stringify(jsonMap);
  }
  
  String toString() {
    List<String> result = <String>[];
    
    _scan._proxies.forEach(
      (_ProxyEntry entry) {
        if (entry.proxy.isLabelField) {
          result.add(entry.proxy.value.toString());
        }
      }
    );
    
    return result.join(', ');
  }
  
  //---------------------------------
  //
  // Private methods
  //
  //---------------------------------
  
  void _identityKeyListener(List<ChangeRecord> changes) {
    changes.forEach(
        (ChangeRecord change) {
          if (change is PropertyChangeRecord) {
            _ProxyEntry result = _scan._identityProxies.firstWhere(
                (_ProxyEntry entry) => (entry.proxy.propertySymbol == change.field),
                orElse: () => null
            );
            
            if (
                (result != null) &&
                result.proxy.isId
            ) {
              _scan.buildKey();
            }
          }
        }
    );
  }
  
  void _writeExternalImpl(Map<String, dynamic> data, Map<int, Map<String, dynamic>> convertedEntities) {
    data[SerializationType.ENTITY_TYPE] = _scan.refClassName;
    data[SerializationType.UID] = _uid;
    
    if (convertedEntities == null) {
      convertedEntities = new Map<int, Map<String, dynamic>>();
    }
    
    convertedEntities[_uid] = data;
    
    _scan._proxies.forEach(
      (_ProxyEntry entry) {
        if (
            entry.proxy.isId ||
            (entry.proxy._value != entry.proxy._defaultValue)
        ) {
          if (entry.proxy.value is Entity) {
            Entity subEntity = entry.proxy.value;
            
            if (convertedEntities.containsKey(subEntity._uid)) {
              Map<String, dynamic> pointerMap = new Map<String, dynamic>();
              
              pointerMap[SerializationType.POINTER] = subEntity._uid;
              pointerMap[SerializationType.ENTITY_TYPE] = subEntity._scan.refClassName;
              
              subEntity._scan._proxies.forEach(
                  (_ProxyEntry subEntry) {
                    if (subEntry.proxy.isId) {
                      pointerMap[subEntry.property] = subEntry.proxy.value;
                    }
                  }
              );
              
              data[entry.property] = pointerMap;
            } else {
              data[entry.property] = new Map<String, dynamic>();
              
              subEntity._writeExternalImpl(data[entry.property], convertedEntities);
            }
          } else {
            data[entry.property] = entry.proxy.value;
          }
        }
      }
    );
  }
  
}