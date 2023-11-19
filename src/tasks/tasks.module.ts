import { Module } from '@nestjs/common';
import { TasksController } from './tasks.controller';
import { TasksService } from './tasks.service';

// Schema for tasks
@Module({
  // the routes or endpoints associated with this module
  controllers: [TasksController],
  // the services that this module will use (makes them injectable for the controller to use)
  providers: [TasksService],
})
export class TasksModule {}
