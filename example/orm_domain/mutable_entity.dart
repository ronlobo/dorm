// Generated by build_entities.dart,// rerun this script if you have made changes// to the corresponding server-side Hibernate filepart of orm_domain;@Ref('entities.mutable_entity')class MutableEntity extends Entity {	//---------------------------------	//	// Public properties	//	//---------------------------------	//---------------------------------	// insertedBy	//---------------------------------	@Property(INSERTEDBY_SYMBOL, 'insertedBy')	DormProxy<User> _insertedBy;	static const String INSERTEDBY = 'insertedBy';	static const Symbol INSERTEDBY_SYMBOL = const Symbol('orm_domain.MutableEntity.insertedBy');	User get insertedBy => _insertedBy.value;	set insertedBy(User value) => _insertedBy.value = notifyPropertyChange(INSERTEDBY_SYMBOL, _insertedBy.value, value);	//---------------------------------	// insertedOn	//---------------------------------	@Property(INSERTEDON_SYMBOL, 'insertedOn')	DormProxy<DateTime> _insertedOn;	static const String INSERTEDON = 'insertedOn';	static const Symbol INSERTEDON_SYMBOL = const Symbol('orm_domain.MutableEntity.insertedOn');	DateTime get insertedOn => _insertedOn.value;	set insertedOn(DateTime value) => _insertedOn.value = notifyPropertyChange(INSERTEDON_SYMBOL, _insertedOn.value, value);	//---------------------------------	// updatedBy	//---------------------------------	@Property(UPDATEDBY_SYMBOL, 'updatedBy')	DormProxy<User> _updatedBy;	static const String UPDATEDBY = 'updatedBy';	static const Symbol UPDATEDBY_SYMBOL = const Symbol('orm_domain.MutableEntity.updatedBy');	User get updatedBy => _updatedBy.value;	set updatedBy(User value) => _updatedBy.value = notifyPropertyChange(UPDATEDBY_SYMBOL, _updatedBy.value, value);	//---------------------------------	// updatedOn	//---------------------------------	@Property(UPDATEDON_SYMBOL, 'updatedOn')	DormProxy<DateTime> _updatedOn;	static const String UPDATEDON = 'updatedOn';	static const Symbol UPDATEDON_SYMBOL = const Symbol('orm_domain.MutableEntity.updatedOn');	DateTime get updatedOn => _updatedOn.value;	set updatedOn(DateTime value) => _updatedOn.value = notifyPropertyChange(UPDATEDON_SYMBOL, _updatedOn.value, value);	//---------------------------------	//	// Constructor	//	//---------------------------------	MutableEntity() : super();}