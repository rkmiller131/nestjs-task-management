import { Controller } from '@nestjs/common';
import { TasksService } from './tasks.service'; // injected dependency

// for '/tasks' route, this controller will handle all requests with its defined methods
@Controller('tasks')
export class TasksController {
  // ts: parameter for constructor is the nameOfParam: typeOfParam
  // ts adds syntactic sugar like java where we can say private or public which takes the place
  // of having to declare the variable within the constructor like this.tasksService = tasksService
  // So with 'private' you're basically saying this tasksService property is a property of the TasksController class
  constructor(private tasksService: TasksService) {}
}
