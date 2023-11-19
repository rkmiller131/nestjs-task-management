import { Module } from '@nestjs/common';
import { TasksModule } from './tasks/tasks.module';

// a Nest.js decorator that turns our class into a module (a module is a schematic for how the app should be built)
// Each app has at least one module, a root module (like this one)
// Modules are used to organize the codebase into discrete units of functionality (e.g. by feature)
// General structure: Have one folder per module, each folder containing the module's components
@Module({
  imports: [TasksModule],
})
export class AppModule {}

// Module decorators take a single object as an argument and have a few properties:
// imports: an array of other modules that this module depends on
// controllers: an array of controllers to be instantiated within the module
// providers: an array of providers that are part of this module via dependency injection (services, repositories)
// exports: an array of providers that should be available to other modules. So other modules that import this module will have access to these providers
