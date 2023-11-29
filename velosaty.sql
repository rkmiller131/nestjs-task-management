DROP DATABASE IF EXISTS velosaty-users;

CREATE DATABASE velosaty-users;

DROP TABLE IF EXISTS finances_statistics;
DROP TABLE IF EXISTS admissions_subject_requirements;
DROP TABLE IF EXISTS college_admissions_info;
DROP TABLE IF EXISTS college_app_info;
DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS group_members;
DROP TABLE IF EXISTS groups;
DROP TABLE IF EXISTS messages;
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS user_connections;
DROP TABLE IF EXISTS jobs_applied;
DROP TABLE IF EXISTS jobs_interviewed;
DROP TABLE IF EXISTS saved_jobs;
DROP TABLE IF EXISTS job_listings;
DROP TABLE IF EXISTS recommended_colleges;
DROP TABLE IF EXISTS saved_colleges;
DROP TABLE IF EXISTS colleges;
DROP TABLE IF EXISTS user_profile_meta;
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
  school_name VARCHAR(100), -- their high school or current university
  school_city VARCHAR(75),
  school_state VARCHAR(20),
  graduation_year SMALLINT,
  sports_interests TEXT[], -- assuming these will be tags in which user can select multiple
  academic_interests TEXT[],

  FOREIGN KEY (profile_id) REFERENCES user_profile(id)
);

-- user statistics will be an aggregate of:
-- Saved Colleges, Saved Jobs, Related/Recommended Colleges, Jobs Interviewed for, Jobs Applied to, Other User Connections

CREATE TABLE colleges (
  id SERIAL PRIMARY KEY,
  type VARCHAR(10), -- 2-year, 4-year, etc.
  name VARCHAR(100),
  add_line_1 VARCHAR(100),
  add_line_2 VARCHAR(100),
  city VARCHAR(75),
  state VARCHAR(20),
  zip VARCHAR(10),
  coordinates VARCHAR(50),
  web_url TEXT,
  about_summary TEXT,
  image_url TEXT,
  best_for TEXT[], -- from collegeai, like "best for engineering" - list top 3
  public BOOLEAN,
  accepts_act BOOLEAN,
  accepts_sat BOOLEAN,
  accepts_common_app BOOLEAN,
  athletic_division TEXT,
  athletic_conference TEXT,
  us_ranking SMALLINT,
  acceptance_rate SMALLINT,
);

CREATE TABLE saved_colleges (
  id SERIAL PRIMARY KEY,
  user_id INT,
  college_id INT,
  date_added TIMESTAMP WITHOUT TIME ZONE DEFAULT current_timestamp,

  FOREIGN KEY (user_id) REFERENCES user_account(id),
  FOREIGN KEY (college_id) REFERENCES colleges(id)
);

CREATE TABLE recommended_colleges (
  id SERIAL PRIMARY KEY,
  user_id INT,
  college_id INT,
  recommendation_score NUMERIC(3, 2), -- Total 3 digits allowed, 2 to the right of the decimal. So like 2.75 or 5.00

  FOREIGN KEY (user_id) REFERENCES user_account(id),
  FOREIGN KEY (college_id) REFERENCES colleges(id)
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
  apply_url TEXT,
  date_posted TIMESTAMP WITHOUT TIME ZONE DEFAULT current_timestamp,
)

CREATE TABLE saved_jobs (
  id SERIAL PRIMARY KEY,
  user_id INT,
  job_id INT,
  date_added TIMESTAMP WITHOUT TIME ZONE DEFAULT current_timestamp,

  FOREIGN KEY (user_id) REFERENCES user_account(id),
  FOREIGN KEY (job_id) REFERENCES job_listings(id)
);

CREATE TABLE jobs_interviewed (
  id SERIAL PRIMARY KEY,
  user_id INT,
  job_id INT,
  date_interviewed DATE,

  FOREIGN KEY (user_id) REFERENCES user_account(id),
  FOREIGN KEY (job_id) REFERENCES job_listings(id)
);

CREATE TABLE jobs_applied (
  id SERIAL PRIMARY KEY,
  user_id INT,
  job_id INT,
  date_applied DATE,
  status VARCHAR(10), -- "pending", "accepted", "rejected", etc.

  FOREIGN KEY (user_id) REFERENCES user_account(id),
  FOREIGN KEY (job_id) REFERENCES job_listings(id)
);

CREATE TABLE user_connections (
  id SERIAL PRIMARY KEY,
  follower_user_id INT, -- the user who is following or initiating the connection
  followed_user_id INT, -- the user who is being followed or receiving the connection
  connection_type VARCHAR(20) -- 1st, 2nd, 3rd
  date_connected TIMESTAMP WITHOUT TIME ZONE DEFAULT current_timestamp,

  FOREIGN KEY (user_id) REFERENCES user_account(id),
  FOREIGN KEY (connection_id) REFERENCES user_account(id)
);

-- Note: there will be an endpoint that aggregates the count of:
-- Saved Jobs, applied jobs, interviews, and connections

-- This continues the Social Media section with posts, comments, messages, etc.

CREATE TABLE posts (
  id SERIAL PRIMARY KEY,
  author_id INT,
  content TEXT,
  date_posted TIMESTAMP WITHOUT TIME ZONE DEFAULT current_timestamp,

  FOREIGN KEY (author_id) REFERENCES user_account(id)
);

CREATE TABLE comments (
  id SERIAL PRIMARY KEY,
  commenter_id INT,
  post_id INT,
  content TEXT,
  date_posted TIMESTAMP WITHOUT TIME ZONE DEFAULT current_timestamp,

  FOREIGN KEY (commenter_id) REFERENCES user_account(id),
  FOREIGN KEY (post_id) REFERENCES posts(id)
);

CREATE TABLE messages (
  id SERIAL PRIMARY KEY,
  sender_id INT,
  recipient_id INT,
  message_text TEXT,
  date_sent TIMESTAMP WITHOUT TIME ZONE DEFAULT current_timestamp,
  is_read BOOLEAN DEFAULT FALSE,

  FOREIGN KEY (sender_id) REFERENCES user_account(id),
  FOREIGN KEY (recipient_id) REFERENCES user_account(id)
);

CREATE TABLE groups (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50),
  description TEXT,
);

CREATE TABLE group_members (
  id SERIAL PRIMARY KEY,
  group_id INT,
  member_id INT,

  FOREIGN KEY (group_id) REFERENCES groups(id),
  FOREIGN KEY (member_id) REFERENCES user_account(id)
);

CREATE TABLE notifications (
  id SERIAL PRIMARY KEY,
  receiver_user_id INT,
  sender_user_id INT,
  notification_type VARCHAR(20), -- "connection", "message", "comment", etc.
  message_text TEXT,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT current_timestamp,

  FOREIGN KEY (receiver_user_id) REFERENCES user_account(id),
  FOREIGN KEY (sender_user_id) REFERENCES user_account(id)
);

-- This section is more about the Colleges and College Database

CREATE TABLE college_app_info (
  id SERIAL PRIMARY KEY,
  college_id INT,
  app_url TEXT,
  rec_letters_required SMALLINT,
  early_decision DATE,
  early_action DATE,
  regular_decision DATE,
  interview_required BOOLEAN,
  transcript_required BOOLEAN,
  ap_credits_accepted BOOLEAN,
  ib_credits_accepted BOOLEAN,
  transfer_credits_accepted BOOLEAN,

  FOREIGN KEY (college_id) REFERENCES colleges(id),
);

CREATE TABLE college_admissions_info (
  id SERIAL PRIMARY KEY,
  college_id INT,
  app_fee SMALLINT,
  sat_act_required BOOLEAN,
  sat_range VARCHAR(10),
  act_range VARCHAR(5),
  recommended_hs_gpa NUMERIC(3, 2),

  FOREIGN KEY (college_id) REFERENCES colleges(id),
);

CREATE TABLE admissions_subject_requirements (
  id SERIAL PRIMARY KEY,
  college_id INT,
  subject_name VARCHAR(50), -- like math, science, 2nd language, etc.
  units_required SMALLINT, -- high school credits
  duration VARCHAR(10), -- 2 years, etc.

  FOREIGN KEY (college_id) REFERENCES colleges(id),
);

CREATE TABLE finances_statistics (
  id SERIAL PRIMARY KEY,
  college_id INT,
  annaul_out_state NUMERIC(10), -- note, no decimals, just rounded num
  annual_in_state NUMERIC(10),
  avg_aid_awarded NUMERIC(10), -- note - separate one for in/out of state?
  net_estimate NUMERIC(10),
  avg_grad_earnings NUMERIC(10),
  num_undergrads INT,
  grad_rate NUMERIC(3, 1),

  FOREIGN KEY (college_id) REFERENCES colleges(id),
);

CREATE TABLE academics_summary (
  id SERIAL PRIMARY KEY,
  college_id INT,
  credits_to_graduate SMALLINT,
  avg_class_size SMALLINT,
  student_faculty_ratio NUMERIC(3, 1),
  study_amount VARCHAR(50), -- from collegeai survey answer types
  professor_quality VARCHAR(255), -- from collegeai reason Ids

  FOREIGN KEY (college_id) REFERENCES colleges(id),
);

-- have chatGPT generate a summary based on the above table and most pop majors (query filter)

CREATE TABLE majors (
  id SERIAL PRIMARY KEY,
  college_id INT,
  major_name VARCHAR(50),
  num_grads INT, -- per current year maybe?

  FOREIGN KEY (college_id) REFERENCES colleges(id),
);

CREATE TABLE ratings_reviews (
  id SERIAL PRIMARY KEY,
  college_id INT,
  rating NUMERIC(1, 0), -- 1-5 whole nums only
  reviewer_name VARCHAR(50),
  review_body TEXT,
  reported BOOLEAN DEFAULT FALSE,
  date_posted TIMESTAMP WITHOUT TIME ZONE DEFAULT current_timestamp,

  FOREIGN KEY (college_id) REFERENCES colleges(id),
);

CREATE TABLE waitlist (
  id SERIAL PRIMARY KEY,
  name TEXT,
  email TEXT,
);