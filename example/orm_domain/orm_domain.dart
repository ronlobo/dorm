library orm_domain;@MirrorsUsed(symbols: 'Employee,ImmutableEntity,Job,MutableEntity,Person,User', override: '*')import 'dart:mirrors';import 'package:dorm/dorm.dart';part 'employee.dart';part 'immutable_entity.dart';part 'job.dart';part 'mutable_entity.dart';part 'person.dart';part 'user.dart';void ormInitialize() {	EntityManager entityManager = new EntityManager();	entityManager.scan(Employee);	entityManager.scan(ImmutableEntity);	entityManager.scan(Job);	entityManager.scan(MutableEntity);	entityManager.scan(Person);	entityManager.scan(User);}