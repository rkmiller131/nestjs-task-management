import {
  Controller,
  Body,
  Get,
  Post,
  Param,
  Delete,
  Patch,
  Query,
} from '@nestjs/common';
import { TasksService } from './tasks.service'; // injected dependency
import { Task } from './task.model';
import { CreateTaskDto } from './dto/create-task.dto';
import { GetTasksFilterDTO } from './dto/get-tasks-filter.dto';
import { UpdateTaskStatusDto } from './dto/update-task-status.dto';

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
  getTasks(@Query() filterDto: GetTasksFilterDTO): Task[] {
    // if we have any search filters defined, call tasksService.getTasksWithfilters
    if (Object.keys(filterDto).length) {
      return this.tasksService.getTasksWithFilter(filterDto);
    } else {
      // otherwise, just get all tasks
      return this.tasksService.getAllTasks();
    }
  }

  @Get('/:id')
  getTaskById(@Param('id') id: string): Task {
    return this.tasksService.getTaskById(id);
  }

  @Post()
  createTask(@Body() createTaskDto: CreateTaskDto): Task {
    return this.tasksService.createTask(createTaskDto);
  }

  @Delete('/:id')
  deleteTaskById(@Param('id') id: string): void {
    this.tasksService.deleteTaskById(id);
  }

  // the :id is a path param, specified with status that is coming in the request body as { status: 'IN_PROGRESS' }
  // common for patch requests to need the id, and then a descriptive url path to indicate what body/field is being updated
  @Patch('/:id/status')
  // rather than using a dto, keep as normal because we would need 2 dtos (one for param, one for req body)
  updateStatus(
    @Param('id') id: string,
    @Body() updateTaskStatusDto: UpdateTaskStatusDto, // to validate the TaskStatus type, we can create a dto with validation decorators
  ): Task {
    const { status } = updateTaskStatusDto;
    return this.tasksService.updateStatus(id, status);
  }
}
