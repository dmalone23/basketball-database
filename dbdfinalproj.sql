CREATE DATABASE IF NOT EXISTS nbadraft;

USE nbadraft;

CREATE TABLE IF NOT EXISTS team
	(name VARCHAR(32) PRIMARY KEY,
    city VARCHAR(32) NOT NULL,
    state VARCHAR(2) NOT NULL,
    seed INT NOT NULL
    );
    
CREATE TABLE IF NOT EXISTS player
	(id INT PRIMARY KEY,
    fname VARCHAR(32) NOT NULL,
    lname VARCHAR(32) NOT NULL,
    height INT NOT NULL,
    weight INT NOT NULL,
    primary_pos ENUM ('PG', 'SG', 'SF', 'PF', 'C') NOT NULL,
    secondary_pos ENUM ('PG', 'SG', 'SF', 'PF', 'C') NOT NULL,
    handedness ENUM ('L', 'R') NOT NULL,
    dob DATE NOT NULL,
    college VARCHAR(32)
    );

    
CREATE TABLE IF NOT EXISTS draft
	(id INT PRIMARY KEY,
    player_id INT,
    team VARCHAR(32),
    round ENUM ('1', '2') NOT NULL,
    pick INT NOT NULL,
    year INT NOT NULL,
    CONSTRAINT fk_draft_player FOREIGN KEY (player_id) references player(id)
		ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_draft_team FOREIGN KEY (team) references team(name)
		ON UPDATE CASCADE ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS mascot
	(name VARCHAR(32) PRIMARY KEY,
    team VARCHAR(32),
    CONSTRAINT fk_mascot_team FOREIGN KEY (team) references team(name)
		ON UPDATE CASCADE ON DELETE CASCADE
	);
    
CREATE TABLE IF NOT EXISTS headcoach
	(name VARCHAR(32) PRIMARY KEY,
    age INT NOT NULL,
    experience INT NOT NULL,
    team VARCHAR(32),
    CONSTRAINT fk_headcoach_team FOREIGN KEY (team) references team(name)
		ON UPDATE CASCADE ON DELETE CASCADE
    );
    
CREATE TABLE IF NOT EXISTS homestadium
	(name VARCHAR(64) PRIMARY KEY,
    capacity INT NOT NULL,
    team VARCHAR(32),
    CONSTRAINT fk_stadium_team FOREIGN KEY (team) references team(name)
		ON UPDATE CASCADE ON DELETE CASCADE
    );
    
CREATE TABLE IF NOT EXISTS gleague_aff
	(name VARCHAR(32) PRIMARY KEY,
    city VARCHAR(32) NOT NULL,
    state VARCHAR(2) NOT NULL,
    seed INT NOT NULL,
    team VARCHAR(32),
    CONSTRAINT fk_gleague_team FOREIGN KEY (team) references team(name)
		ON UPDATE CASCADE ON DELETE CASCADE
    );