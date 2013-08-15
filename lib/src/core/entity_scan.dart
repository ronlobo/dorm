part of dorm;

class EntityScan {
  
  //---------------------------------
  //
  // Private properties
  //
  //---------------------------------
  
  EntityScan _original;
  MetadataCache _metadataCache = new MetadataCache();
  Function _contructorMethod;
  
  List<_ProxyEntry> _proxies = <_ProxyEntry>[];
  Map<String, _ProxyEntry> _proxyMap = new Map<String, _ProxyEntry>();
  List<_ProxyEntry> _identityProxies = <_ProxyEntry>[];
  Queue<EntityScan> _keyCollection;
  
  //---------------------------------
  //
  // Public properties
  //
  //---------------------------------
  
  Entity entity;
  String refClassName;
  bool isMutableEntity = true;
  
  //---------------------------------
  // key
  //---------------------------------
  
  void buildKey() {
    EntityKey nextKey = EntityAssembler._instance._keyChain;
    
    _identityProxies.forEach(
      (_ProxyEntry entry) =>  nextKey = nextKey._setKeyValue(entry.propertySymbol, entry.proxy._value)   
    );
    
    if (_keyCollection != nextKey.entityScans) {
      if (_keyCollection != null) _keyCollection.remove(this);
      
      _keyCollection = nextKey.entityScans;
    }
  }
  
  //---------------------------------
  //
  // Constructor
  //
  //---------------------------------
  
  EntityScan(this.refClassName, this._contructorMethod);
  
  EntityScan.fromScan(EntityScan original, Entity entity) {
    List<_ProxyEntry> originalProxies = original._proxies;
    _ProxyEntry clonedEntry;
    
    this._original = original;
    this.entity = entity;

    
    this._contructorMethod = original._contructorMethod;
    this._metadataCache = original._metadataCache;
    this.refClassName = original.refClassName;
    this.isMutableEntity = original.isMutableEntity;
    
    originalProxies.forEach(
       (_ProxyEntry entry) {
         clonedEntry = entry.clone();
         
         this._proxies.add(clonedEntry);
         this._proxyMap[entry.property] = clonedEntry;
         
         if (clonedEntry.isIdentity) this._identityProxies.add(clonedEntry);
       }
    );
  }
  
  //---------------------------------
  //
  // Public methods
  //
  //---------------------------------
  
  void registerMetadataUsing(VariableMirror mirror) {
    InstanceMirror instanceMirror;
    _ProxyEntry entry;
    Property property;
    int i = mirror.metadata.length;
    int j;
    bool isIdentity;
    dynamic metatag;
    
    while (i > 0) {
      instanceMirror = mirror.metadata[--i];
      
      if (instanceMirror.reflectee is Property) {
        property = instanceMirror.reflectee as Property;
        
        entry = new _ProxyEntry(property.property, property.propertySymbol, property.type);
        
        isIdentity = false;
        
        j = mirror.metadata.length;
        
        while (j > 0) {
          metatag = mirror.metadata[--j].reflectee;
          
          _metadataCache.registerTagForProperty(entry, metatag);
          
          if (metatag is Id) isIdentity = true;
        }
        
        entry.isIdentity = isIdentity;
        
        _proxies.add(entry);
        
        _proxyMap[property.property] = entry;
        
        if (isIdentity) _identityProxies.add(entry);
      }
    }
  }
}

//---------------------------------
//
// Private classes
//
//---------------------------------

//---------------------------------
// _ProxyEntry
//---------------------------------

class _ProxyEntry {
  
  final String property;
  final Symbol propertySymbol;
  final Type type;
  
  bool isIdentity;
  DormProxy proxy;
  _PropertyMetadataCache metadataCache;
  
  _ProxyEntry(this.property, this.propertySymbol, this.type);
  
  _ProxyEntry clone() => new _ProxyEntry(property, propertySymbol, type)..metadataCache = metadataCache..isIdentity = isIdentity;
  
}