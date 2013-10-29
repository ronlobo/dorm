part of dorm;

class DormManager extends ObservableBase {
  
  //-----------------------------------
  //
  // Private properties
  //
  //-----------------------------------
  
  List<Entity> _observeList = <Entity>[];
  List<Entity> _queue = <Entity>[];
  List<Entity> _deleteQueue = <Entity>[];
  bool _forcedDirtyStatus = false;
  
  //-----------------------------------
  //
  // Public properties
  //
  //-----------------------------------
  
  //-----------------------------------
  // id
  //-----------------------------------
  
  String id;
  
  //-----------------------------------
  // queueLength
  //-----------------------------------
  
  static const Symbol IS_COMMIT_REQUIRED = const Symbol('dorm.core.DormManager.isCommitRequired');
  static const Symbol IS_COMMIT_NOT_REQUIRED = const Symbol('dorm.core.DormManager.isCommitNotRequired');
  
  bool _isCommitRequired = false;
  
  bool get isCommitRequired => _isCommitRequired;
  
  void _updateIsCommitRequired() {
    bool status = (_forcedDirtyStatus || (_queue.length + _deleteQueue.length) > 0);
    
    if (status != _isCommitRequired) {
      _isCommitRequired = status;
      
      notifyChange(
          new PropertyChangeRecord(status ? IS_COMMIT_REQUIRED : IS_COMMIT_NOT_REQUIRED)    
      );
    }
  }
  
  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------
  
  DormManager({String id}) {
    this.id = id;
  }
  
  //-----------------------------------
  //
  // Public methods
  //
  //-----------------------------------
  
  void forceDirtyStatus(bool value) {
    _forcedDirtyStatus = value;
    
    _updateIsCommitRequired();
  }
  
  bool isQueued(Entity entity, {bool forDelete: false}) {
    if (forDelete) return _deleteQueue.contains(entity);
    
    return _queue.contains(entity);
  }
  
  void queueAsDeleted(Entity entity) {
    if (
        entity._scan.isMutableEntity &&
        !_deleteQueue.contains(entity)
    ) {
      _queue.remove(entity);
      _deleteQueue.add(entity);
      
      _updateIsCommitRequired();
    }
  }
  
  void queue(Entity entity) {
    if (
        entity._scan.isMutableEntity &&
        !_queue.contains(entity) &&
        entity.isDirty()
    ) {
      _deleteQueue.remove(entity);
      _queue.add(entity);
      
      _updateIsCommitRequired();
    }
  }
  
  void unqueue(Entity entity) {
    if (entity._scan.isMutableEntity) {
      if (_queue.contains(entity)) _queue.remove(entity);
      if (_deleteQueue.contains(entity)) _deleteQueue.remove(entity);
      
      _updateIsCommitRequired();
    }
  }
  
  void queueAll(Iterable<Entity> entities) {
    entities.forEach(
      (Entity entity) => queue(entity)    
    );
  }
  
  void clear() {
    _forcedDirtyStatus = false;
    _isCommitRequired = false;
    
    _flushInternal();
    
    _updateIsCommitRequired();
  }
  
  DormManagerCommitStructure getCommitStructure() {
    List<Entity> queueRecursive = <Entity>[];
    List<Entity> deleteQueueRecursive = <Entity>[];
    
    queueRecursive.addAll(_queue);
    deleteQueueRecursive.addAll(_deleteQueue);
    
    _queue.forEach(
      (Entity entity) => _scanRecursively(entity, queueRecursive)
    );
    
    _deleteQueue.forEach(
        (Entity entity) => _scanRecursively(entity, deleteQueueRecursive)
    );
    
    _queue = queueRecursive;
    _deleteQueue = deleteQueueRecursive;
    
    _flushInternal();
    
    _queue.forEach(
        (Entity entity) => entity.validate()
    );
    
    _deleteQueue.forEach(
        (Entity entity) => entity.validate()
    );
    
    return new DormManagerCommitStructure(queueRecursive, deleteQueueRecursive);
  }
  
  //-----------------------------------
  //
  // Private methods
  //
  //-----------------------------------
  
  void _scanRecursively(Entity entity, List<Entity> list) {
    entity._scan._proxies.forEach(
      (_ProxyEntry entry) {
        if (entry.proxy.value is Entity) {
          if (
              entry.proxy.value._scan.isMutableEntity &&
              !list.contains(entry.proxy.value) &&
              entry.proxy.value.isDirty()
          ) {
            list.add(entry.proxy.value);
          }
        } else if (entry.proxy.value is List) {
          List<Entity> entityList = entry.proxy.value;
          
          entityList.forEach(
            (Entity listEntity) => _scanRecursively(listEntity, list)  
          );
        }
      }
    );
  }
  
  void _flushInternal() {
    _queue = <Entity>[];
    _deleteQueue = <Entity>[];
  }
  
}

//-----------------------------------
//
// Internal objects
//
//-----------------------------------

class DormManagerCommitStructure {
  
  final List<Entity> dataToCommit;
  final List<Entity> dataToDelete;
  
  const DormManagerCommitStructure(this.dataToCommit, this.dataToDelete);
  
}