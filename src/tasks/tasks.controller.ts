import { Controller, Body, Get, Post } from '@nestjs/common';
import { TasksService } from './tasks.service'; // injected dependency
import { Task } from './task.model';

// for '/tasks' route, this controller will handle all requests with its defined methods
@Controller('tasks')
export class TasksController {
  // ts: parameter for constructor is the nameOfParam: typeOfParam
  // ts adds syntactic sugar like java where we can say private or public which takes the place
  // of having to declare the variable within the constructor like this.tasksService = tasksService
  // So with 'private' you're basically saying this tasksService property is a property of the TasksController class
  constructor(private tasksService: TasksService) {}

  // all GET req to /tasks are tied to this method of getAllTasks on the controller, which calls the service
  @Get()
  getAllTasks(): Task[] {
    return this.tasksService.getAllTasks();
  }

  // You can extract the entire request body with @Body body (assigning the whole body onto the var, 'body')
  // but sometimes you only want to extract certain parameters from the body such as title and desc, which
  // guards against other random fields possibly showing up that were sent from the client.
  @Post()
  // instead extract only title and description from the body by specifying the keys upon invocation of decorator
  createTask(
    @Body('title') title: string,
    @Body('description') description: string,
  ): Task {
    return this.tasksService.createTask(title, description);
  }
}
