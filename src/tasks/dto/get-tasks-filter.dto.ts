import { IsEnum, IsString, IsOptional } from 'class-validator';
import { TaskStatus } from '../task.model';

export class GetTasksFilterDTO {
  @IsOptional()
  @IsEnum(TaskStatus)
  status?: TaskStatus;

  // Even though we're using the ? operator for typescript, this doesn't do anything at run time in terms of validation
  // So we use the 'Is Optional' decorator to mimic that (Ts doesn't exist at runtime)
  @IsOptional()
  @IsString()
  search?: string;
}
