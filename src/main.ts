import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';

// create a new Nest.js application using AppModule as our root module
async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  // you can put your pipes at the global, controller, or parameter level. At the global level,
  // NestJS will look for all forms of validation and validate them as it runs into them
  app.useGlobalPipes(new ValidationPipe());
  await app.listen(3000);
}
bootstrap();
