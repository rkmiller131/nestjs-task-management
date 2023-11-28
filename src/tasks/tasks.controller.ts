import { Controller, Body, Get, Post } from '@nestjs/common';
import { TasksService } from './tasks.service'; // injected dependency
import { Task } from './task.model';
import { CreateTaskDto } from './dto/create-task.dto';

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

  @Post()
  createTask(@Body() createTaskDto: CreateTaskDto): Task {
    return this.tasksService.createTask(createTaskDto);
  }
}
