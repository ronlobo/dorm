part of dorm_test;

@Ref('entities.TestEntitySuperClass')
class TestEntitySuperClass extends Entity {

  //---------------------------------
  //
  // Public properties
  //
  //---------------------------------
  
  //---------------------------------
  // refClassName
  //---------------------------------

  String get refClassName => 'entities.TestEntitySuperClass';

  //---------------------------------
  // id
  //---------------------------------

  @Property(ID_SYMBOL, 'id', int)
  @Id(0)
  @NotNullable()
  @DefaultValue(0)
  @Immutable()
  final DormProxy<int> _id = new DormProxy<int>(ID, ID_SYMBOL);

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
  
  static TestEntitySuperClass construct() {
    return new TestEntitySuperClass();
  }

}

@Ref('entities.TestEntity')
class TestEntity extends TestEntitySuperClass {

  //---------------------------------
  //
  // Public properties
  //
  //---------------------------------
  
  //---------------------------------
  // refClassName
  //---------------------------------

  String get refClassName => 'entities.TestEntity';

  //---------------------------------
  // name
  //---------------------------------

  @Property(NAME_SYMBOL, 'name', String)
  @LabelField()
  final DormProxy<String> _name = new DormProxy<String>(NAME, NAME_SYMBOL);

  static const String NAME = 'name';
  static const Symbol NAME_SYMBOL = const Symbol('orm_domain.TestEntity.name');

  String get name => _name.value;
  set name(String value) => _name.value = notifyPropertyChange(NAME_SYMBOL, _name.value, value);
  
  //---------------------------------
  // date
  //---------------------------------

  @Property(DATE_SYMBOL, 'date', DateTime)
  final DormProxy<DateTime> _date = new DormProxy<DateTime>(DATE, DATE_SYMBOL);

  static const String DATE = 'date';
  static const Symbol DATE_SYMBOL = const Symbol('orm_domain.TestEntity.date');

  DateTime get date => _date.value;
  set date(DateTime value) => _date.value = notifyPropertyChange(DATE_SYMBOL, _date.value, value);
  
  //---------------------------------
  // cyclicReference
  //---------------------------------

  @Property(CYCLIC_REFERENCE_SYMBOL, 'cyclicReference', TestEntity)
  final DormProxy<TestEntity> _cyclicReference = new DormProxy<TestEntity>(CYCLIC_REFERENCE, CYCLIC_REFERENCE_SYMBOL);

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
      <DormProxy>[_name, _date, _cyclicReference]
    );
  }
  
  static TestEntity construct() => new TestEntity();
}

@Ref('entities.AnotherTestEntity')
class AnotherTestEntity extends TestEntitySuperClass {

  //---------------------------------
  //
  // Public properties
  //
  //---------------------------------
  
  //---------------------------------
  // refClassName
  //---------------------------------

  String get refClassName => 'entities.AnotherTestEntity';

  //---------------------------------
  // anotherName
  //---------------------------------

  @Property(ANOTHERNAME_SYMBOL, 'anotherName', String)
  @LabelField()
  final DormProxy<String> _anotherName = new DormProxy<String>(ANOTHERNAME, ANOTHERNAME_SYMBOL);

  static const String ANOTHERNAME = 'anotherName';
  static const Symbol ANOTHERNAME_SYMBOL = const Symbol('orm_domain.AnotherTestEntity.anotherName');

  String get anotherName => _anotherName.value;
  set anotherName(String value) => _anotherName.value = notifyPropertyChange(ANOTHERNAME_SYMBOL, _anotherName.value, value);
  
  //---------------------------------
  // date
  //---------------------------------

  @Property(DATE_SYMBOL, 'date', DateTime)
  final DormProxy<DateTime> _date = new DormProxy<DateTime>(DATE, DATE_SYMBOL);

  static const String DATE = 'date';
  static const Symbol DATE_SYMBOL = const Symbol('orm_domain.AnotherTestEntity.date');

  DateTime get date => _date.value;
  set date(DateTime value) => _date.value = notifyPropertyChange(DATE_SYMBOL, _date.value, value);
  
  //---------------------------------
  // cyclicReference
  //---------------------------------

  @Property(CYCLIC_REFERENCE_SYMBOL, 'cyclicReference', TestEntity)
  final DormProxy<TestEntity> _cyclicReference = new DormProxy<TestEntity>(CYCLIC_REFERENCE, CYCLIC_REFERENCE_SYMBOL);

  static const String CYCLIC_REFERENCE = 'cyclicReference';
  static const Symbol CYCLIC_REFERENCE_SYMBOL = const Symbol('orm_domain.AnotherTestEntity.cyclicReference');

  TestEntity get cyclicReference => _cyclicReference.value;
  set cyclicReference(TestEntity value) => _cyclicReference.value = notifyPropertyChange(CYCLIC_REFERENCE_SYMBOL, _cyclicReference.value, value);

  //---------------------------------
  //
  // Constructor
  //
  //---------------------------------

  AnotherTestEntity() : super() {
    Entity.ASSEMBLER.registerProxies(
      this,
      <DormProxy>[_anotherName, _date, _cyclicReference]
    );
  }
  
  static AnotherTestEntity construct() => new AnotherTestEntity();
}