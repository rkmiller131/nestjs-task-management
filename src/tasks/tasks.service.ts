import { Injectable, NotFoundException } from '@nestjs/common';
import { Task, TaskStatus } from './task.model';
import { v4 as uuid } from 'uuid';
import { CreateTaskDto } from './dto/create-task.dto';
import { GetTasksFilterDTO } from './dto/get-tasks-filter.dto';

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

  getTasksWithFilter(filterDto: GetTasksFilterDTO): Task[] {
    const { search, status } = filterDto;
    let tasks = this.getAllTasks();
    if (status) {
      tasks = tasks.filter((task) => task.status === status);
    }
    if (search) {
      tasks = tasks.filter((task) => {
        if (task.title.includes(search) || task.description.includes(search)) {
          return true;
        }
        return false;
      });
    }
    return tasks;
  }

  getTaskById(id: string): Task {
    // try to get task
    const found = this.tasks.find((task) => task.id === id);
    // if not found, throw a error (404 not found)
    if (!found) {
      // throws a new object of the not found exeption class, which bubbles up into the internals of NestJs
      throw new NotFoundException(`Couldn't find task with id: ${id}`);
    }
    // otherwise return the found task
    return found;
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

  deleteTaskById(id: string): void {
    // since there is an error handling already in place for gettingTaskById, this can work
    // for deleting too in that it will throw an error if we try to delete a task that doenst exist
    const found = this.getTaskById(id);
    if (found) {
      for (let i = 0; i < this.tasks.length; i++) {
        if (this.tasks[i].id === id) {
          this.tasks.splice(i, 1);
        }
      }
    }
  }

  updateStatus(id: string, status: TaskStatus): Task {
    const task = this.getTaskById(id);
    task.status = status;
    return task;
  }
}
