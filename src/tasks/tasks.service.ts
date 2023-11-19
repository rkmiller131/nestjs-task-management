import { Injectable } from '@nestjs/common';

// Makes this class a singleton that can be injected into other classes (singleton is a design pattern that restricts the instantiation of a class to one object)
@Injectable()
export class TasksService {}
