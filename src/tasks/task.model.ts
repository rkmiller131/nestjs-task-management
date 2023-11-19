// The model is like a schema that determines the shape of Task objects
// We use an interface in TS vs a class because we don't need to instantiate a Task object,
// we just need to enforce the shape of the object upon compilation only

export interface Task {
  id: string;
  title: string;
  description: string;
  status: TaskStatus;
}

// We want status to have a limited pool of values, so we use an enum to hold options as constants
export enum TaskStatus {
  OPEN = 'OPEN',
  IN_PROGRESS = 'IN PROGRESS',
  DONE = 'DONE',
}
