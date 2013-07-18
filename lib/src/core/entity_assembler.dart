part of dorm;

class EntityAssembler {
  
  //---------------------------------
  //
  // Private properties
  //
  //---------------------------------
  
  static const Symbol ENTITY_SYMBOL = const Symbol('dorm.Entity');
  
  final List<EntityScan> _entityScans = <EntityScan>[];
  final List<DormProxy> _proxyRegistry = <DormProxy>[];
  final EntityKey _keyChain = new EntityKey();
  
  int _proxyCount = 0;
  
  //---------------------------------
  //
  // Singleton Constructor
  //
  //---------------------------------
  
  EntityAssembler._construct();
  
  //---------------------------------
  //
  // Factories
  //
  //---------------------------------
  
  static EntityAssembler _instance;

  factory EntityAssembler() {
    if (_instance == null) {
      _instance = new EntityAssembler._construct();
    }

    return _instance;
  }
  
  //---------------------------------
  //
  // Public methods
  //
  //---------------------------------
  
  EntityScan scan(Type forType, String refClassName, Function constructorMethod) {
    EntityScan scan = _getExistingScan(refClassName);
    
    if(scan != null) {
      return scan;
    }
    
    scan = new EntityScan(refClassName, constructorMethod);
    
    ClassMirror classMirror = reflectClass(forType);
    Map<Symbol, Mirror> members = new Map<Symbol, Mirror>.from(classMirror.members);
    
    classMirror = classMirror.superclass;
    
    while (classMirror.qualifiedName != ENTITY_SYMBOL) {
      members.addAll(classMirror.members);
      
      classMirror = classMirror.superclass;
    }
    
    members.values.forEach(
      (Mirror mirror) {
        if (mirror is VariableMirror) scan.registerMetadataUsing(mirror);
      }
    );
    
    _entityScans.add(scan);
    
    return scan;
  }
  
  void registerProxies(Entity entity, List<DormProxy> proxies) {
    _ProxyEntry entry;
    DormProxy proxy;
    
    if (entity._uid == null) {
      entity._uid = entity.hashCode;
      entity._scan = _getScanForInstance(entity);
    }
    
    EntityScan scan = entity._scan;
    List<_ProxyEntry> proxyEntryList = scan._proxies;
    int i = proxyEntryList.length;
    int j;
    
    while (i > 0) {
      entry = proxyEntryList[--i];
      
      j = proxies.length;
      
      while (j > 0) {
        proxy = proxies[--j];
        
        if (entry.property == proxy.property) {
          scan.updateProxyWithMetadata(proxy);
          
          entry.proxy = proxy;
          
          entity._proxies.add(proxy);
          
          _proxyRegistry.add(proxy);
          
          proxies.remove(proxy);
          
          break;
        }
      }
    }
  }
  
  //---------------------------------
  //
  // Library protected methods
  //
  //---------------------------------
  
  EntityScan _getScanForInstance(Entity entity) {
    EntityScan scan = _getExistingScan(entity.refClassName);
    
    if(scan != null) {
      return new EntityScan.fromScan(scan, entity);
    }
    
    throw new DormError('Scan for entity not found');
  }
  
  Entity _assemble(Map<String, dynamic> rawData, OnConflictFunction onConflict) {
    final String refClassName = rawData[SerializationType.ENTITY_TYPE];
    EntityScan scan;
    Entity entity, returningEntity;
    List<_ProxyEntry> entityProxies;
    int i, j;
    
    if (onConflict == null) {
      onConflict = _handleConflictAcceptClient;
    }
    
    i = _entityScans.length;
    
    while (i > 0) {
      scan = _entityScans[--i];
      
      if (scan.refClassName == refClassName) {
        entity = scan._contructorMethod();
        
        entity.readExternal(rawData, onConflict);
        
        entity._scan.buildKey();
        
        returningEntity = _existingFromSpawnRegistry(refClassName, entity);
        
        if (!entity._isPointer) {
          entity = _registerSpawnedEntity(
              entity,
              returningEntity, 
              refClassName, onConflict
          );
          
          returningEntity = entity;
        } else if (returningEntity._isPointer) {
          _removeEntityProxies(entity);
          
          _proxyCount++;
        }
        
        return returningEntity;
      }
    }
    
    throw new DormError('Scan for entity not found');
    
    return null;
  }
  
  Entity _registerSpawnedEntity(Entity spawnee, Entity existingEntity, String refClassName, OnConflictFunction onConflict) {
    ConflictManager conflictManager;
    List<_ProxyEntry> entryProxies;
    List<_ProxyEntry> spawneeProxies;
    _ProxyEntry entryA, entryB;
    int i, j;
    
    if (spawnee != existingEntity) {
      if (onConflict == null) {
        throw new DormError('Conflict was detected, but no onConflict method is available');
      }
      
      conflictManager = onConflict(
          spawnee, 
          existingEntity
      );
      
      if (conflictManager == ConflictManager.ACCEPT_SERVER) {
        entryProxies = existingEntity._scan._proxies;
        
        i = entryProxies.length;
        
        while (i > 0) {
          entryA = entryProxies[--i];
          
          spawneeProxies = spawnee._scan._proxies;
          
          j = spawneeProxies.length;
          
          while (j > 0) {
            entryB = spawneeProxies[--j];
            
            if (entryA.property == entryB.property) {
              entryA.proxy._initialValue = existingEntity.notifyPropertyChange(entryA.proxy.propertySymbol, entryA.proxy._value, entryB.proxy._value);
              
              _proxyRegistry.remove(entryB.proxy);
              
              break;
            }
          }
        }
        
        _keyChain.remove(spawnee);
      } else if (conflictManager == ConflictManager.ACCEPT_CLIENT) {
        _removeEntityProxies(spawnee);
      }
      
      _swap(existingEntity, false);
    }
    
    if (!existingEntity._isRegistered) {
      existingEntity._isRegistered = true;
      
      existingEntity.changes.listen(existingEntity._identityKeyListener);
    }
    
    _swap(existingEntity, true);
    
    return existingEntity;
  }
  
  void _removeEntityProxies(Entity entity) {
    List<_ProxyEntry> proxies = entity._scan._proxies;
    int i = proxies.length;
    
    while (i > 0) {
      _proxyRegistry.remove(proxies[--i].proxy);
    }
    
    _keyChain.remove(entity);
  }
  
  void _swap(Entity actualEntity, bool swapPointers) {
    if (
        swapPointers &&
        (_proxyCount == 0)
    ) {
      return;
    }
    
    DormProxy proxy;
    int i = _proxyRegistry.length;
    
    while (i > 0) {
      proxy = _proxyRegistry[--i];
      
      if (proxy.owner != null) {
        proxy.owner.forEach(
            (dynamic entry) {
              if (
                  (entry is Entity) &&
                  _keyChain.areSameKeySignature(entry, actualEntity)
              ) {
                if (swapPointers) _proxyCount--;
                
                //_removeEntityProxies(entry);
                
                proxy.owner[proxy.owner.indexOf(entry)] = actualEntity;
              }
            }
        );
      } else if (
          (proxy._value is Entity) &&
          _keyChain.areSameKeySignature(proxy._value, actualEntity)
      ) {
        if (swapPointers) _proxyCount--;
        
        //_removeEntityProxies(proxy._value);
        
        proxy._initialValue = actualEntity;
      }
    }
  }
  
  Entity _existingFromSpawnRegistry(String refClassName, Entity entity) {
    Entity registeredEntity = _keyChain.getExistingEntity(entity);
    
    if (
        (registeredEntity != null) &&
        !registeredEntity._isPointer
    ) {
      return registeredEntity;
    }
    
    return entity;
  }
  
  EntityScan _getExistingScan(String refClassName) {
    EntityScan scan;
    int i = _entityScans.length;
    
    while (i > 0) {
      scan = _entityScans[--i];
      
      if (scan.refClassName == refClassName) {
        return scan;
      }
    }
    
    return null;
  }
  
  ConflictManager _handleConflictAcceptClient(Entity serverEntity, Entity clientEntity) {
    return ConflictManager.ACCEPT_CLIENT;
  }
}