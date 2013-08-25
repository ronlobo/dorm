library dorm_entity_spawn_test;

import 'package:dorm/dorm.dart';
import 'dart:async';
import 'dart:html';

Serializer serializer = new SerializerJson();

DivElement out = query("#out");

main() {
  Entity.ASSEMBLER.scan(TestEntity, 'entities.testEntity', TestEntity.construct);
  
  _runBenchmark();
}

void _runBenchmark() {
  EntityFactory<TestEntity> factory = new EntityFactory(handleConflictAcceptClient);
  List<String> jsonRaw = <String>[];
  int loopCount = 10000;
  int i = loopCount;
  int t1, t2;
  Stopwatch stopwatch;
  DateTime time;
  
  while (i > 0) {
    jsonRaw.add('{"id":${--i},"name":"Speed test","type":"type_${i}","?t":"entities.testEntity"}');
  }
  
  stopwatch = new Stopwatch()..start();
  
  List<Map<String, dynamic>> parsed = serializer.incoming('[' + jsonRaw.join(',') + ']');
  
  stopwatch.stop();
  
  t1 = stopwatch.elapsedMilliseconds;
  
  stopwatch = new Stopwatch()..start();
  
  factory.spawn(parsed, serializer);
  
  stopwatch.stop();
  
  t2 = stopwatch.elapsedMilliseconds;
  
  out.innerHtml += 'json to Map $t1 ms, dorm to entity class model $t2 ms<br>';
  
  new Timer(new Duration(seconds:1), _runBenchmark);
}

ConflictManager handleConflictAcceptClient(Entity serverEntity, Entity clientEntity) {
  return ConflictManager.ACCEPT_CLIENT;
}

ConflictManager handleConflictAcceptServer(Entity serverEntity, Entity clientEntity) {
  return ConflictManager.ACCEPT_SERVER;
}

@Ref('entities.testEntitySuperClass')
class TestEntitySuperClass extends Entity {

  //---------------------------------
  //
  // Public properties
  //
  //---------------------------------
  
  //---------------------------------
  // refClassName
  //---------------------------------

  String get refClassName => 'entities.testEntitySuperClass';

  //---------------------------------
  // id
  //---------------------------------

  @Property(ID_SYMBOL, 'id', int)
  @Id()
  @NotNullable()
  @DefaultValue(0)
  @Immutable()
  final DormProxy<int> _id = new DormProxy<int>(ID);

  static const String ID = 'id';
  static const Symbol ID_SYMBOL = const Symbol('orm_domain.TestEntitySuperClass.id');

  int get id => _id.value;
  set id(int value) => _id.value = notifyPropertyChange(ID_SYMBOL, _id.value, value);

  //---------------------------------
  //
  // Constructor
  //
  //---------------------------------

  TestEntitySuperClass() : super() {
    Entity.ASSEMBLER.registerProxies(
        this,
        <DormProxy>[_id]    
    );
  }
  
  static TestEntitySuperClass construct() => new TestEntitySuperClass();

}

@Ref('entities.testEntity')
class TestEntity extends TestEntitySuperClass {

  //---------------------------------
  //
  // Public properties
  //
  //---------------------------------
  
  //---------------------------------
  // refClassName
  //---------------------------------

  String get refClassName => 'entities.testEntity';

  //---------------------------------
  // name
  //---------------------------------

  @Property(NAME_SYMBOL, 'name', String)
  @LabelField()
  final DormProxy<String> _name = new DormProxy<String>(NAME);

  static const String NAME = 'name';
  static const Symbol NAME_SYMBOL = const Symbol('orm_domain.TestEntity.name');

  String get name => _name.value;
  set name(String value) => _name.value = notifyPropertyChange(NAME_SYMBOL, _name.value, value);
  
  //---------------------------------
  // type
  //---------------------------------

  @Property(TYPE_SYMBOL, 'type', String)
  final DormProxy<String> _type = new DormProxy<String>(TYPE);

  static const String TYPE = 'type';
  static const Symbol TYPE_SYMBOL = const Symbol('orm_domain.TestEntity.type');

  String get type => _type.value;
  set type(String value) => _type.value = notifyPropertyChange(TYPE_SYMBOL, _type.value, value);
  
  //---------------------------------
  // cyclicReference
  //---------------------------------

  @Property(CYCLIC_REFERENCE_SYMBOL, 'cyclicReference', TestEntity)
  final DormProxy<TestEntity> _cyclicReference = new DormProxy<TestEntity>(CYCLIC_REFERENCE);

  static const String CYCLIC_REFERENCE = 'cyclicReference';
  static const Symbol CYCLIC_REFERENCE_SYMBOL = const Symbol('orm_domain.TestEntity.cyclicReference');

  TestEntity get cyclicReference => _cyclicReference.value;
  set cyclicReference(TestEntity value) => _cyclicReference.value = notifyPropertyChange(CYCLIC_REFERENCE_SYMBOL, _cyclicReference.value, value);

  //---------------------------------
  //
  // Constructor
  //
  //---------------------------------

  TestEntity() : super() {
    Entity.ASSEMBLER.registerProxies(
      this,
      <DormProxy>[_name, _type, _cyclicReference]    
    );
  }
  
  static TestEntity construct() => new TestEntity();

}