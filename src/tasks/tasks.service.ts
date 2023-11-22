import { Injectable } from '@nestjs/common';

// Makes this class a singleton that can be injected into other classes (singleton is a design pattern that restricts the instantiation of a class to one object)
// services in nest are like models in node - they receive information from the controller to talk to the db or external api
@Injectable()
export class TasksService {}
