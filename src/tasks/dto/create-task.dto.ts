// A DTO, or Data Transfer Object, is an object that defines how the data will be sent over the network.
// This is different from the model, which enforce the shape of the data upon compilation, and isn't required but makes for better scalability.
// Imagine if you had a service and controller that handled creating a task and you had to define the variables and type of each variable in multiple places:

// TaskController method
// get a post request to /tasks, extract the body and call the service to actually create the task
//   @Post()
//   createTask(
//     @Body('title') title: string, // specifically look for the title property in the body of the request
//     @Body('description') description: string, // give it a name and specify the type of string
//   ): Task {
//     return this.tasksService.createTask(title, description);
//   }

// // TaskService method
// // once the baton has passed to our service from the controller, we see again that the same title and desc are defined
// @Post()
// createTask(
//   title: string, // imagine changing our mind about these parameters and having to go back and manually change everywhere
//   description: string,
// ): Task {
//   const task: Task = {
//     id: uuid(),
//     title,
//     description,
//     status: TaskStatus.OPEN,
//   };

//   this.tasks.push(task);
//   return task;
// }

// Instead, let's create a DTO for these parameters and use it in both places:
export class CreateTaskDto {
  title: string;
  description: string;
}
// Now our controller method looks like this:
//   @Post()
//   createTask(@Body() createTaskDto: CreateTaskDto): Task {
//     return this.tasksService.createTask(createTaskDto);
//   }

// And our service method looks like this:
// @Post()
// createTask(createTaskDto: CreateTaskDto): Task {}
//... etc.

// Future improvements: add validation to the DTO to ensure that the title and description are not empty strings
