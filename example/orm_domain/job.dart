// Generated by build_entities.dart,// rerun this script if you have made changes// to the corresponding server-side Hibernate filepart of orm_domain;@Ref('entities.job')class Job extends MutableEntity {	//---------------------------------	//	// Public properties	//	//---------------------------------	//---------------------------------	// refClassName	//---------------------------------	String get refClassName => 'entities.job';	//---------------------------------	// id	//---------------------------------	@Property(ID_SYMBOL, 'id', int)	@Id()	@NotNullable()	@DefaultValue(0)	@Immutable()	DormProxy<int> _id;	static const String ID = 'id';	static const Symbol ID_SYMBOL = const Symbol('orm_domain.Job.id');	int get id => _id.value;	set id(int value) => _id.value = notifyPropertyChange(ID_SYMBOL, _id.value, value);	//---------------------------------	// name	//---------------------------------	@Property(NAME_SYMBOL, 'name', String)	@LabelField()	DormProxy<String> _name;	static const String NAME = 'name';	static const Symbol NAME_SYMBOL = const Symbol('orm_domain.Job.name');	String get name => _name.value;	set name(String value) => _name.value = notifyPropertyChange(NAME_SYMBOL, _name.value, value);	//---------------------------------	// employees	//---------------------------------	@Property(EMPLOYEES_SYMBOL, 'employees', ObservableList)	@Lazy()	DormProxy<ObservableList<Employee>> _employees;	static const String EMPLOYEES = 'employees';	static const Symbol EMPLOYEES_SYMBOL = const Symbol('orm_domain.Job.employees');	ObservableList<Employee> get employees => _employees.value;	set employees(ObservableList<Employee> value) => _employees.value = notifyPropertyChange(EMPLOYEES_SYMBOL, _employees.value, value);	//---------------------------------	//	// Constructor	//	//---------------------------------	Job() : super() {		EntityAssembler assembler = new EntityAssembler();		_id = new DormProxy()		..property = 'id'		..propertySymbol = ID_SYMBOL;		_name = new DormProxy()		..property = 'name'		..propertySymbol = NAME_SYMBOL;		_employees = new DormProxy()		..property = 'employees'		..propertySymbol = EMPLOYEES_SYMBOL;		assembler.registerProxies(this, <DormProxy>[_id, _name, _employees]);}	static Job construct() {		return new Job();	}}