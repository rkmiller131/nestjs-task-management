import { Injectable } from '@nestjs/common';
import { Task, TaskStatus } from './task.model';
import { v4 as uuid } from 'uuid';
import { CreateTaskDto } from './dto/create-task.dto';

// Makes this class a singleton that can be injected into other classes (singleton is a design pattern that restricts the instantiation of a class to one object)
// services in nest are like models in node - they receive information from the controller to talk to the db or external api
@Injectable()
export class TasksService {
  // temporarily using local memory to store tasks; will update to postgres later
  private tasks: Task[] = [];

  // with ts: the result of getAllTasks is an array of Tasks that are in the shape of our Task Model
  getAllTasks(): Task[] {
    return this.tasks;
  }

  createTask(createTaskDto: CreateTaskDto): Task {
    const { title, description } = createTaskDto;
    const task: Task = {
      // using the npm package uuid for generating random id strings
      id: uuid(),
      title,
      description,
      status: TaskStatus.OPEN,
    };
    this.tasks.push(task);
    return task;
  }
}
