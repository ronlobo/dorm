// Generated by build_entities.dart,// rerun this script if you have made changes// to the corresponding server-side Hibernate filepart of orm_domain;@Ref('entities.person')class Person extends MutableEntity {	//---------------------------------	//	// Public properties	//	//---------------------------------	//---------------------------------	// id	//---------------------------------	@Property(ID_SYMBOL, 'id')	@Id()	@NotNullable()	@DefaultValue(0)	@Immutable()	DormProxy<int> _id;	static const String ID = 'id';	static const Symbol ID_SYMBOL = const Symbol('orm_domain.Person.id');	int get id => _id.value;	set id(int value) => _id.value = notifyPropertyChange(ID_SYMBOL, _id.value, value);	//---------------------------------	// name	//---------------------------------	@Property(NAME_SYMBOL, 'name')	@LabelField()	DormProxy<String> _name;	static const String NAME = 'name';	static const Symbol NAME_SYMBOL = const Symbol('orm_domain.Person.name');	String get name => _name.value;	set name(String value) => _name.value = notifyPropertyChange(NAME_SYMBOL, _name.value, value);	//---------------------------------	//	// Constructor	//	//---------------------------------	Person() : super();}