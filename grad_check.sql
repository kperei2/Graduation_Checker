-- Active: 1730687188808@@127.0.0.1@3306@cs_student_graduation_checker

-- Creates Database
DROP DATABASE IF EXISTS CS_Student_Graduation_Checker;
CREATE DATABASE CS_Student_Graduation_Checker;
USE CS_Student_Graduation_Checker;

-- Creates table for student information
CREATE TABLE Students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255),
    enrollment_year INT,
    graduation_year INT
);

-- Creates table for course information
CREATE TABLE Courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(10) UNIQUE NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL,
    category VARCHAR(50)
);

-- Creates table for information about each student's courses with separate foreign key constraints
CREATE TABLE StudentCourses (
    student_course_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('completed', 'in-progress', 'planned')),
    grade VARCHAR(2),
    semester VARCHAR(20),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- Creates table for classes required toward completing degree
CREATE TABLE DegreeRequirements (
    requirement_id SERIAL PRIMARY KEY,
    course_id INT NOT NULL,
    requirement_type VARCHAR(50),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- Creates table to keep track of student's progress toward graduation
CREATE TABLE Progress (
    student_id INT PRIMARY KEY,
    total_credits_completed INT DEFAULT 0,
    total_percentage_completed DECIMAL(5, 2) DEFAULT 0.00,
    core_credits_remaining INT DEFAULT 0,
    science_credits_remaining INT DEFAULT 0,
    math_credits_remaining INT DEFAULT 0,
    general_ed_credits_remaining INT DEFAULT 0,
    free_elective_credits_remaining INT DEFAULT 0,
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

INSERT INTO Courses (course_code, course_name, credits, category) VALUES
-- Core Computer Science Courses
('CS 111', 'Program Design I', 3, 'Core'),
('CS 141', 'Program Design II', 3, 'Core'),
('CS 151', 'Mathematical Foundations of Computing', 3, 'Core'),
('CS 211', 'Programming Practicum', 3, 'Core'),
('CS 251', 'Data Structures', 4, 'Core'),
('CS 261', 'Machine Organization', 3, 'Core'),
('CS 301', 'Languages and Automata', 3, 'Core'),
('CS 341', 'Programming Language Design and Implementation', 3, 'Core'),
('CS 342', 'Software Design', 3, 'Core'),
('CS 361', 'Systems Programming', 3, 'Core'),
('CS 362', 'Computer Design', 3, 'Core'),
('CS 377', 'Ethical Issues in Computing', 3, 'Core'),
('CS 401', 'Computer Algorithms I', 3, 'Core'),
('CS 499', 'Professional Development Seminar', 0, 'Core'),
-- Required Mathematics Courses
('MATH 180', 'Calculus I', 4, 'Core Math'),
('MATH 181', 'Calculus II', 4, 'Core Math'),
('MATH 210', 'Calculus III', 3, 'Core Math'),
-- Technical Electives
('CS 411', 'Artificial Intelligence I', 3, 'Technical Elective'),
('CS 412', 'Introduction to Machine Learning', 3, 'Technical Elective'),
('CS 418', 'Introduction to Data Science', 3, 'Technical Elective'),
('CS 422', 'User Interface Design and Programming', 3, 'Technical Elective'),
('CS 425', 'Computer Graphics I', 3, 'Technical Elective'),
('CS 440', 'Software Engineering I', 3, 'Technical Elective'),
('CS 441', 'Engineering Distributed Objects for Cloud Computing', 3, 'Technical Elective'),
('CS 442', 'Human-Computer Interaction', 3, 'Technical Elective'),
('CS 450', 'Introduction to Networking', 3, 'Technical Elective'),
('CS 461', 'Computer Systems Design', 3, 'Technical Elective'),
('CS 463', 'Computer Security I', 3, 'Technical Elective'),
('CS 466', 'Advanced Computer Architecture', 3, 'Technical Elective'),
('CS 473', 'Compiler Design', 3, 'Technical Elective'),
('CS 474', 'Object-Oriented Languages and Environments', 3, 'Technical Elective'),
('CS 476', 'Programming Language Design', 3, 'Technical Elective'),
('CS 478', 'Software Development for Mobile Platforms', 3, 'Technical Elective'),
('CS 480', 'Database Systems', 3, 'Technical Elective'),
('CS 481', 'Introduction to Natural Language Processing', 3, 'Technical Elective'),
('CS 482', 'Information Retrieval', 3, 'Technical Elective'),
('CS 484', 'Secure Web Application Development', 3, 'Technical Elective'),
('CS 485', 'Network Security', 3, 'Technical Elective'),
('CS 486', 'Secure Operating System Design and Implementation', 3, 'Technical Elective'),
('CS 487', 'Building Secure Computer Systems', 3, 'Technical Elective'),
('CS 488', 'Introduction to Cryptography', 3, 'Technical Elective'),
('CS 489', 'Human Augmentics', 3, 'Technical Elective'),
-- General Education Courses - Analyzing the Natural World
('ANTH 102', 'Introduction to Archaeology', 4, 'Gen Ed'),
('ANTH 105', 'Human Evolution', 4, 'Gen Ed'),
('ANTH 238', 'Biology of Women', 3, 'Gen Ed'),
('BIOS 104', 'Biology for Non-majors', 4, 'Gen Ed'),
('CHE 150', 'Climate Engineering for Global Warming', 3, 'Gen Ed'),
('CHEM 100', 'Chemistry and Life', 5, 'Gen Ed'),
('CHEM 105', 'Chemistry and the Molecular Human: An Inquiry Perspective', 4, 'Gen Ed'),
('CHEM 115', 'Comprehensive General and Organic Chemistry', 5, 'Gen Ed'),
('CHEM 116', 'Honors and Majors General and Analytical Chemistry I', 5, 'Gen Ed'),
('CHEM 118', 'Honors and Majors General and Analytical Chemistry II', 5, 'Gen Ed'),
('CHEM 122', 'Matter and Energy', 3, 'Gen Ed'),
('CHEM 123', 'Foundations of Chemical Inquiry I', 2, 'Gen Ed'),
('CHEM 124', 'Chemical Dynamics', 3, 'Gen Ed'),
('CHEM 125', 'Foundations of Chemical Inquiry II', 2, 'Gen Ed'),
('CHEM 130', 'Survey of Organic and Biochemistry', 5, 'Gen Ed'),
('CS 100', 'Discovering Computer Science', 3, 'Gen Ed'),
('DHD 206', 'Disability, Inclusive Cities, and Environmental Accessibility', 3, 'Gen Ed'),
('EAES 101', 'Global Environmental Change', 4, 'Gen Ed'),
('EAES 105', 'Climate, Contamination, and Chicago', 2, 'Gen Ed'),
('EAES 111', 'Earth, Energy, and the Environment', 4, 'Gen Ed'),
('EAES 200', 'Field Work in Missouri', 2, 'Gen Ed'),
('EAES 203', 'The Science and Rhetorics of Climate Change', 3, 'Gen Ed'),
('ECON 106', 'Tobacconomics', 3, 'Gen Ed'),
('ECE 115', 'Introduction to Electrical and Computer Engineering', 4, 'Gen Ed'),
('HON 130', 'Honors Core in Analyzing the Natural World and Understanding the Individual and Society', 3, 'Gen Ed'),
('HON 131', 'Honors Core in Analyzing the Natural World and Understanding the Past', 3, 'Gen Ed'),
('HON 132', 'Honors Core in Analyzing the Natural World and Understanding the Creative Arts', 3, 'Gen Ed'),
('HON 133', 'Honors Core in Analyzing the Natural World and Exploring World Cultures', 3, 'Gen Ed'),
('HON 134', 'Honors Core in Analyzing the Natural World and Understanding U.S. Society', 3, 'Gen Ed'),
('HON 145', 'Honors Core in Analyzing the Natural World', 3, 'Gen Ed'),
('HN 196', 'Nutrition', 3, 'Gen Ed'),
('KN 152', 'Introduction to Exercise Physiology and Health', 3, 'Gen Ed'),
('MCS 160', 'Introduction to Computer Science', 4, 'Gen Ed'),
('MATH 125', 'Elementary Linear Algebra', 5, 'Gen Ed'),
('MATH 160', 'Finite Mathematics for Business', 5, 'Gen Ed'),
('MATH 165', 'Calculus for Business', 5, 'Gen Ed'),
('MATH 170', 'Calculus for the Life Sciences', 4, 'Gen Ed'),
('MUS 116', 'The Science and History of Sound in the Arts', 3, 'Gen Ed'),
('NATS 105', 'Physical Systems in Earth and Space Science', 4, 'Gen Ed'),
('NATS 106', 'Chemical and Biological Systems', 4, 'Gen Ed'),
('PHIL 102', 'Introductory Logic', 3, 'Gen Ed'),
('PHIL 105', 'Science and Philosophy', 3, 'Gen Ed'),
('PHYS 112', 'Astronomy and the Universe', 4, 'Gen Ed'),
('PHYS 116', 'Energy for Future Decision-Makers', 3, 'Gen Ed'),
('PHYS 118', 'Physics in Modern Medicine', 3, 'Gen Ed'),
('PHYS 131', 'Introductory Physics for Life Sciences I', 4, 'Gen Ed'),
('PHYS 132', 'Introductory Physics for Life Sciences II', 4, 'Gen Ed'),
('PHYS 141', 'General Physics I (Mechanics)', 4, 'Gen Ed'),
('PHYS 142', 'General Physics II (Electricity and Magnetism)', 4, 'Gen Ed'),
('PUBH 120', 'Public Health and the Study of Disease and Epidemics', 3, 'Gen Ed'),
-- General Education Courses - Understanding the Individual and Society
('ANTH 101', 'World Cultures: Introduction to Social Anthropology', 3, 'Gen Ed'),
('ANTH 215', 'Anthropology of Religion', 3, 'Gen Ed'),
('ANTH 216', 'Medicine, Culture, and Society', 3, 'Gen Ed'),
('ANTH 218', 'Anthropology of Children and Childhood', 3, 'Gen Ed'),
('ANTH 273', 'Ethnography of Southeast Asia', 3, 'Gen Ed'),
('ANTH 277', 'Ethnography of Meso-America', 3, 'Gen Ed'),
('ANTH 279', 'South Asian Cultures and Societies', 3, 'Gen Ed'),
('ARCH 200', 'Architecture and Society', 4, 'Gen Ed'),
('ART 110', 'Introduction to Art Education', 4, 'Gen Ed'),
('ART 290', 'Art and Resistance: Socially Engaged Art', 4, 'Gen Ed'),
('AH 101', 'The Naked and the Nude: Studies in Visual Literacy', 3, 'Gen Ed'),
('AH 180', 'Intro to Museum & Exhibition', 3, 'Gen Ed'),
('BLST 100', 'Introduction to Black Studies', 3, 'Gen Ed'),
('BLST 103', 'Black Politics and Culture in the United States', 3, 'Gen Ed'),
('BLST 104', 'Race, Place, and Schooling: Black Americans and Education', 3, 'Gen Ed'),
('BLST 207', 'Racism: Global Perspectives', 3, 'Gen Ed'),
('BLST 263', 'Black Intellectual History', 3, 'Gen Ed'),
('BLST 271', 'Race and the Politics of Incarceration', 3, 'Gen Ed'),
('BLST 272', 'Race, Gender, and Sexuality', 3, 'Gen Ed'),
('CL 208', 'Classical Mythology', 3, 'Gen Ed'),
('COMM 100', 'Fundamentals of Human Communication', 3, 'Gen Ed'),
('COMM 101', 'Introduction to Communication', 3, 'Gen Ed'),
('COMM 102', 'Introduction to Interpersonal Communication', 3, 'Gen Ed'),
('COMM 103', 'Introduction to Media', 3, 'Gen Ed'),
('COMM 140', 'Fundamentals of Social Media and Communication', 3, 'Gen Ed'),
('DLG 220', 'Intergroup Dialogue', 3, 'Gen Ed'),
('DHD 101', 'Disability in U.S. Society', 3, 'Gen Ed'),
('DHD 201', 'Disability, Rights, and Culture', 3, 'Gen Ed'),
('DHD 202', 'Disability, Health, and Society', 3, 'Gen Ed'),
('DHD 205', 'Disability, Race, Class and Gender', 3, 'Gen Ed'),
('ECON 111', 'Freakonomics', 3, 'Gen Ed'),
('ECON 120', 'Principles of Microeconomics', 4, 'Gen Ed'),
('ECON 121', 'Principles of Macroeconomics', 4, 'Gen Ed'),
('ED 100', 'Introduction to Urban Education', 3, 'Gen Ed'),
('ED 101', 'Critical Literacies in a Digital Democracy', 3, 'Gen Ed'),
('ED 135', 'Child and Youth Policies in Urban America', 3, 'Gen Ed'),
('ED 205', 'Introduction to Race, Ethnicity, and Education', 3, 'Gen Ed'),
('EPSY 100', 'Introduction to Human Development and Learning', 3, 'Gen Ed'),
('EPSY 160', 'Games, Learning, and Society', 3, 'Gen Ed'),
('ENGL 135', 'Understanding Popular Genres and Culture', 3, 'Gen Ed'),
('ENGL 154', 'Understanding Rhetoric', 3, 'Gen Ed'),
('ENGL 230', 'Introduction to Film and Culture', 3, 'Gen Ed'),
('ENGL 245', 'Introduction to Gender, Sexuality and Literature', 3, 'Gen Ed'),
('ENGL 247', 'Women and Literature', 3, 'Gen Ed'),
('ENGL 253', 'Environmental Rhetoric', 3, 'Gen Ed'),
('ENTR 200', 'Survey of Entrepreneurship', 3, 'Gen Ed'),
('FIN 250', 'Personal Finance', 3, 'Gen Ed'),
('GWS 101', 'Gender in Everyday Life', 3, 'Gen Ed'),
('GWS 102', 'Global Perspectives on Women and Gender', 3, 'Gen Ed'),
('GWS 204', 'Gender and Popular Culture', 3, 'Gen Ed'),
('GEOG 161', 'Introduction to Economic Geography', 3, 'Gen Ed'),
('GER 120', 'Study of Gender, Class, and Political Issues in German Texts', 3, 'Gen Ed'),
('GLAS 120', 'Introduction to Asian American Studies', 3, 'Gen Ed'),
('GLAS 210', 'Asian American Histories', 3, 'Gen Ed'),
('GLAS 230', 'Cultural Politics of Asian American Food', 3, 'Gen Ed'),
('GLAS 250', 'Critical Issues in Community Engagement', 3, 'Gen Ed'),
('PSCH 100', 'Introduction to Psychology', 4, 'Gen Ed'),
('PSCH 210', 'Theories of Personality', 3, 'Gen Ed'),
('PSCH 231', 'Community Psychology', 3, 'Gen Ed'),
('PSCH 270', 'Introduction to Psychological and Behavioral Disorders', 3, 'Gen Ed'),
('PPOL 100', 'Individual Action and Democratic Citizenship', 3, 'Gen Ed'),
('PPOL 101', 'Contemporary Issues in Public Policy', 3, 'Gen Ed'),
('PUBH 100', 'Health and the Public', 3, 'Gen Ed'),
('SOC 100', 'Introduction to Sociology', 3, 'Gen Ed'),
('SOC 105', 'Social Problems', 3, 'Gen Ed'),
('SOC 215', 'Sociology of Childhood and Youth', 3, 'Gen Ed'),
('SOC 224', 'Gender and Society', 3, 'Gen Ed'),
('SOC 225', 'Racial and Ethnic Groups', 3, 'Gen Ed'),
('SOC 228', 'Sociology of Asia and Asian Americans', 3, 'Gen Ed'),
('SOC 229', 'Sociology of Latinos', 3, 'Gen Ed'),
('SOC 241', 'Social Inequalities', 3, 'Gen Ed'),
('SOC 244', 'Sociology of Work', 3, 'Gen Ed'),
('SOC 245', 'Marriage and Family', 3, 'Gen Ed'),
('SOC 246', 'Sociology of Religion', 3, 'Gen Ed'),
('SOC 251', 'Health and Medicine', 3, 'Gen Ed'),
('SOC 276', 'Urban Sociology', 3, 'Gen Ed'),
-- General Education Courses - Understanding the Past
('ANTH 100', 'The Human Adventure', 3, 'Gen Ed'),
('ARAB 250', 'The Heritage of Muslim Iberia', 3, 'Gen Ed'),
('ARCH 210', 'Architecture as Archetype: Explorations of the City and Its Forms', 3, 'Gen Ed'),
('AH 122', 'History of Chicago Architecture', 3, 'Gen Ed'),
('AH 130', 'Photography in History', 3, 'Gen Ed'),
('AH 150', 'Art and Money', 3, 'Gen Ed'),
('AH 209', 'Near Eastern Art and Archaeology', 3, 'Gen Ed'),
('AH 210', 'Ancient Egyptian Art and Archaeology', 3, 'Gen Ed'),
('AH 259', 'Art in the Age of Enlightenment and Revolution', 3, 'Gen Ed'),
('BLST 101', 'Introduction to Black Diaspora Studies', 3, 'Gen Ed'),
('BLST 125', 'Black Religious Traditions', 3, 'Gen Ed'),
('BLST 246', 'Black Lives in Historical Context', 3, 'Gen Ed'),
('BLST 247', 'African American History to 1877', 3, 'Gen Ed'),
('BLST 248', 'African American History since 1877', 3, 'Gen Ed'),
('BLST 249', 'Black Freedom Movements in the U.S.', 3, 'Gen Ed'),
('CL 100', 'Greek Civilization', 3, 'Gen Ed'),
('CL 101', 'Roman Civilization', 3, 'Gen Ed'),
('CL 102', 'Introduction to Classical Literature', 3, 'Gen Ed'),
('CL 103', 'Introduction to Classical and Mediterranean Archaeology', 3, 'Gen Ed'),
('CL 204', 'Greek Art and Archaeology', 3, 'Gen Ed'),
('CL 205', 'Roman Art and Archaeology', 3, 'Gen Ed'),
('CL 218', 'Pompeii: Everyday Life in a Roman Town', 3, 'Gen Ed'),
('CL 250', 'Greek and Roman Epic Poetry', 3, 'Gen Ed'),
('CL 251', 'Greek Tragedy', 3, 'Gen Ed'),
('CL 252', 'Greek and Roman Comedy', 3, 'Gen Ed'),
('CL 253', 'Roman Satire and Rhetoric', 3, 'Gen Ed'),
('ENGL 208', 'English Studies I: Beginnings to the 17th Century', 3, 'Gen Ed'),
('ENGL 213', 'Introduction to Shakespeare', 3, 'Gen Ed'),
('GER 125', 'Diaspora, Exile, Genocide: Aspects of the European Jewish Experience in Literature and Film', 3, 'Gen Ed'),
('GER 219', 'Princesses and Storytellers: Fairy Tales by the Brothers Grimm and Their Cultural Afterlives', 3, 'Gen Ed'),
('HIST 100', 'Western Civilization to 1648', 3, 'Gen Ed'),
('HIST 101', 'Western Civilization Since 1648', 3, 'Gen Ed'),
('HIST 103', 'Early America: From Colonization to Civil War and Reconstruction', 3, 'Gen Ed'),
('HIST 104', 'Modern America: From Industrialization to Globalization', 3, 'Gen Ed'),
('HIST 105', 'Global Transformations and the Rise of the West Since 1000', 3, 'Gen Ed'),
('HIST 106', 'The World Since 1400: Converging Worlds, New Circulations', 3, 'Gen Ed'),
('HIST 109', 'East Asian Civilization: Ancient China', 3, 'Gen Ed'),
('HIST 117', 'Understanding the Holocaust', 3, 'Gen Ed'),
('HIST 137', 'Russia in War and Revolution, 1904-1922', 3, 'Gen Ed'),
('HIST 161', 'Introduction to Latin American History', 3, 'Gen Ed'),
('HIST 170', 'The Ottoman Empire', 3, 'Gen Ed'),
('HIST 177', 'Middle Eastern Civilization', 3, 'Gen Ed'),
('HIST 202', 'Ancient Greece', 3, 'Gen Ed'),
('HIST 203', 'Ancient Rome', 3, 'Gen Ed'),
('HIST 208', 'History of Science in a Global Context', 3, 'Gen Ed'),
('HIST 211', 'The Dawn of European Modernity, 1500-1715', 3, 'Gen Ed'),
('HIST 214', 'Twentieth-Century Europe', 3, 'Gen Ed'),
('HIST 220', 'Modern Germany, 1848 to the Present', 3, 'Gen Ed'),
('HIST 221', 'The Atlantic Slave Trade', 3, 'Gen Ed'),
('HIST 224', 'France: 1500 to 1715', 3, 'Gen Ed'),
('HIST 233', 'East Central Europe and the Balkans: From Empires to Nation-States', 3, 'Gen Ed'),
('HIST 237', 'The Russian Empire in the Modern Period: History, Culture and the Challenges of Diversity', 3, 'Gen Ed'),
('HON 120', 'Honors Core in Understanding Individual and Society and Understanding the Past', 3, 'Gen Ed'),
('HON 125', 'Honors Core in Understanding the Past and Exploring World Cultures', 3, 'Gen Ed'),
('HON 141', 'Honors Core in Understanding the Past', 3, 'Gen Ed'),
('ITAL 230', 'Italian and Italian American Culture and Civilization', 3, 'Gen Ed'),
('JST 102', 'Introduction to Jewish History', 3, 'Gen Ed'),
('LALS 101', 'Introduction to Latin American Studies', 3, 'Gen Ed'),
('HIST 293', 'The Gilded and the Gritty: Power, Culture, and the Making of 20th-century America', 3, 'Gen Ed'),
('THTR 101', 'Theatre History I: Premodern Drama', 3, 'Gen Ed'),
('THTR 103', 'History of Chicago Theatre Past and Present', 3, 'Gen Ed'),
('THTR 159', 'Fashion and Furniture: History of Cultural Influences from Gothic to Atomic', 3, 'Gen Ed');
