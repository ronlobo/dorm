// Generated by build_entities.dart,// rerun this script if you have made changes// to the corresponding server-side Hibernate filepart of orm_domain;@Ref('entities.employee')class Employee extends Person {	//---------------------------------	//	// Public properties	//	//---------------------------------	//---------------------------------	// refClassName	//---------------------------------	String get refClassName => 'entities.employee';	//---------------------------------	// job	//---------------------------------	@Property(JOB_SYMBOL, 'job', Job)	DormProxy<Job> _job = new DormProxy<Job>(JOB);	static const String JOB = 'job';	static const Symbol JOB_SYMBOL = const Symbol('orm_domain.Employee.job');	Job get job => _job.value;	set job(Job value) => _job.value = notifyPropertyChange(JOB_SYMBOL, _job.value, value);	//---------------------------------	//	// Constructor	//	//---------------------------------	Employee() : super() {		new EntityAssembler().registerProxies(this, <DormProxy>[_job]);}	static Employee construct() => new Employee();}