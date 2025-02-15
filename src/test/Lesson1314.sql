CREATE TABLE sports (
            sport_id SERIAL PRIMARY KEY,
            name VARCHAR(50) NOT NULL UNIQUE,
            description TEXT
);

CREATE TABLE coaches (
            coach_id SERIAL PRIMARY KEY,
            full_name VARCHAR(100) NOT NULL,
            phone_number VARCHAR(15),
            hire_date DATE NOT NULL,
            specialization VARCHAR(50) NOT NULL
);

CREATE TABLE students (
            student_id SERIAL PRIMARY KEY,
            full_name VARCHAR(100) NOT NULL,
            birth_date DATE NOT NULL,
            phone_number VARCHAR(15),
            email VARCHAR(100)
);

CREATE TABLE trainings (
            training_id SERIAL PRIMARY KEY,
            sport_id INT NOT NULL REFERENCES sports(sport_id),
            coach_id INT NOT NULL REFERENCES coaches(coach_id),
            training_day VARCHAR(10) NOT NULL CHECK (training_day IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')),
            start_time TIME NOT NULL,
            duration INTERVAL NOT NULL
);

CREATE TABLE student_sports (
            student_id INT NOT NULL REFERENCES students(student_id),
            sport_id INT NOT NULL REFERENCES sports(sport_id),
            join_date DATE NOT NULL DEFAULT CURRENT_DATE,
            PRIMARY KEY (student_id, sport_id)
);

-- Виды спорта
INSERT INTO sports (name, description) VALUES
            ('Футбол', 'Командный вид спорта с мячом.'),
            ('Баскетбол', 'Игра с мячом на корте.'),
            ('Теннис', 'Игра ракетками с мячом.');

-- Тренеры
INSERT INTO coaches (full_name, phone_number, hire_date, specialization) VALUES
            ('Иванов Иван Иванович', '+79001234567', '2022-01-01', 'Футбол'),
            ('Петров Петр Петрович', '+79007654321', '2021-05-15', 'Баскетбол'),
            ('Сидорова Мария Алексеевна', '+79001112233', '2023-03-01', 'Теннис');

-- Ученики
INSERT INTO students (full_name, birth_date, phone_number, email) VALUES
            ('Андрей Николаев', '2005-05-10', '+79001111111', 'andrey@example.com'),
            ('Елена Сергеева', '2007-08-20', '+79002222222', 'elena@example.com'),
            ('Александр Петров', '2006-11-15', '+79003333333', 'alex@example.com');

-- Тренировки
INSERT INTO trainings (sport_id, coach_id, training_day, start_time, duration) VALUES
            (1, 1, 'Monday', '18:00:00', '1 hour 30 minutes'),
            (2, 2, 'Wednesday', '19:00:00', '1 hour'),
            (3, 3, 'Saturday', '10:00:00', '2 hours');

-- Занятия учеников
INSERT INTO student_sports (student_id, sport_id, join_date) VALUES
            (1, 1, '2023-01-01'),
            (1, 2, '2023-02-01'),
            (2, 3, '2023-03-01'),
            (3, 1, '2023-04-01');

SELECT
    s.name AS sport_name,
    COUNT(ss.student_id) AS student_count
FROM
    sports s
        LEFT JOIN
    student_sports ss ON s.sport_id = ss.sport_id
GROUP BY
    s.sport_id, s.name
ORDER BY
    student_count DESC;