import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

// create a new Nest.js application using AppModule as our root module
async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  await app.listen(3000);
}
bootstrap();
