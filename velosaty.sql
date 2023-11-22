DROP DATABASE IF EXISTS velosaty-users;

CREATE DATABASE velosaty-users;

DROP TABLE IF EXISTS user_profile;
DROP TABLE IF EXISTS user_account;

CREATE TABLE user_account (
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(20) NOT NULL,
  last_name VARCHAR(20) NOT NULL,
  email VARCHAR(50) UNIQUE NOT NULL,
  password_hash VARCHAR(60) NOT NULL, -- assuming a bcrypt hash length of 60 characters
  access_token TEXT, -- if an oAuth provider is used
  access_provider VARCHAR(20), -- such as "facebook" or "google"
  verified BOOLEAN NOT NULL DEFAULT FALSE, -- if no oAuth provider, then email verification is sent
);

CREATE TABLE user_profile (
  id SERIAL PRIMARY KEY,
  user_id INT,
  phone VARCHAR(20),
  about TEXT,
  experience TEXT[],
  education_history TEXT[],
  links TEXT[],
  skills TEXT[],
  awards TEXT[],
  show_recruiters BOOLEAN NOT NULL DEFAULT TRUE,
  job_hunting BOOLEAN NOT NULL DEFAULT TRUE,
  documents TEXT[], -- store file paths to documents like resume hosted on S3

  FOREIGN KEY (user_id) REFERENCES user_account(id)
);

CREATE TABLE user_profile_meta (
  id SERIAL PRIMARY KEY,
  profile_id INT,
  school_name VARCHAR(100),
  school_city VARCHAR(75),
  school_state VARCHAR(20),
  graduation_year SMALLINT,
  sports_interests TEXT[], -- assuming these will be tags in which user can select multiple
  academic_interests TEXT[],

  FOREIGN KEY (profile_id) REFERENCES user_profile(id)
);

CREATE TABLE job_listings (
  id SERIAL PRIMARY KEY,
  company_name VARCHAR(100),
  company_city VARCHAR(75),
  company_state VARCHAR(20),
  job_title VARCHAR(100),
  job_description TEXT,
  required_skills TEXT[],
  app_deadline DATE,
  salary_range VARCHAR(50),
)