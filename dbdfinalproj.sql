CREATE DATABASE IF NOT EXISTS nbadraft;

USE nbadraft;

CREATE TABLE IF NOT EXISTS team
	(name VARCHAR(32) PRIMARY KEY,
    city VARCHAR(32) NOT NULL,
    state VARCHAR(2) NOT NULL,
    seed INT NOT NULL
    );
    
DELIMITER ;;

CREATE PROCEDURE createTeam(
  new_name VARCHAR(32),
  new_city VARCHAR(32),
  new_state VARCHAR(2),
  new_seed INT,
  new_coach_name VARCHAR(32),
  new_coach_age INT,
  new_coach_experience INT,
  new_stadium_name VARCHAR(64),
  new_stadium_capacity INT,
  new_mascot_name VARCHAR(32),
  new_gleague_aff_name VARCHAR(32),
  new_gleague_aff_city VARCHAR(32),
  new_gleague_aff_state VARCHAR(2),
  new_gleague_aff_seed INT
  )
  MODIFIES SQL DATA
BEGIN
  DECLARE coach_id INT;

  IF NOT EXISTS(SELECT * FROM team WHERE name = new_name) THEN
    INSERT INTO team(name, city, state, seed)
      VALUES (new_name, new_city, new_state, new_seed);
  END IF;
  
  IF NOT EXISTS(SELECT id FROM headcoach WHERE name = new_coach_name) THEN
    INSERT INTO headcoach(name, age, experience, team) VALUES (new_coach_name, new_coach_age, new_coach_experience, new_name);
  END IF;
  UPDATE headcoach
    SET headcoach.team = new_name
    WHERE headcoach.name = new_coach_name;
    
  IF NOT EXISTS(SELECT name FROM mascot WHERE name = new_mascot_name) THEN
    INSERT INTO mascot(name, team) VALUES (new_mascot_name, new_name);
  END IF;
  UPDATE mascot
    SET mascot.team = new_name
    WHERE mascot.name = new_mascot_name;

  IF NOT EXISTS(SELECT id FROM homestadium WHERE name = new_stadium_name) THEN
    INSERT INTO homestadium(name, capacity, team) VALUES (new_stadium_name, new_stadium_capacity, new_name);
  END IF;
  UPDATE homestadium
    SET homestadium.team = new_name
    WHERE homestadium.name = new_stadium_name;

  IF NOT EXISTS(SELECT id FROM gleague_aff WHERE name = new_gleague_aff_name) THEN
    INSERT INTO gleague_aff(name, city, state, seed, team) VALUES (new_gleague_aff_name, new_gleague_aff_city, new_gleague_aff_state, new_gleague_aff_seed, new_name);
  END IF;
  UPDATE gleague_aff
    SET gleague_aff.team = new_name
    WHERE gleague_aff.name = new_gleague_aff_name;
    
END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE deleteTeam(
    del_team_name VARCHAR(32)
  )
  MODIFIES SQL DATA
BEGIN
	DELETE FROM team where team_name = del_team_name;
END ;;
DELIMITER ;
    
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

DELIMITER ;;
CREATE PROCEDURE createPlayer(
    new_fname VARCHAR(32),
    new_lname VARCHAR(32),
    new_height INT,
    new_weight INT,
    new_primary_pos ENUM ('PG', 'SG', 'SF', 'PF', 'C'),
    new_secondary_pos ENUM ('PG', 'SG', 'SF', 'PF', 'C'),
    new_handedness ENUM ('L', 'R'),
    new_dob DATE,
    new_college VARCHAR(32)
  )
  MODIFIES SQL DATA
BEGIN
  INSERT INTO player(fname, lname, height, weight, primary_pos, secondary_pos, handedness, dob, college)
      VALUES (new_fname, new_lname, new_height, new_weight, new_primary_pos, new_secondary_pos, new_handedness, new_dob, new_college);
END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE updatePlayer(
	new_player_id INT,
    new_fname VARCHAR(32),
    new_lname VARCHAR(32),
    new_height INT,
    new_weight INT,
    new_primary_pos ENUM ('PG', 'SG', 'SF', 'PF', 'C'),
    new_secondary_pos ENUM ('PG', 'SG', 'SF', 'PF', 'C'),
    new_handedness ENUM ('L', 'R'),
    new_dob DATE,
    new_college VARCHAR(32)
  )
  MODIFIES SQL DATA
BEGIN
	UPDATE player 
    SET fname = new_fname, lname = new_lname, height = new_height, weight = new_weight, 
    primary_pos = new_primary_pos, secondary_pos = new_secondary_pos, handedness = new_handedness, 
    dob = new_dob, college = new_college
    WHERE player_id = new_player_id;
END ;;
DELIMITER ;

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
    
DELIMITER ;;

CREATE PROCEDURE createDraft(
    new_player_id INT,
    new_team VARCHAR(32),
    new_round ENUM ('1', '2'),
    new_pick INT,
    new_year INT
  )
  MODIFIES SQL DATA
BEGIN
  INSERT INTO draft(player_id, team, round, pick, year)
      VALUES (new_player_id, new_team, new_round, new_pick, new_year);
END ;;
DELIMITER ;

CREATE TABLE IF NOT EXISTS mascot
	(name VARCHAR(32) PRIMARY KEY,
    team VARCHAR(32),
    CONSTRAINT fk_mascot_team FOREIGN KEY (team) references team(name)
		ON UPDATE CASCADE ON DELETE CASCADE
	);

DELIMITER ;;
CREATE PROCEDURE readMascot(
  )
  READS SQL DATA
BEGIN
  SELECT * FROM mascot;
END ;;
DELIMITER ;
    
CREATE TABLE IF NOT EXISTS headcoach
	(id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(32) NOT NULL,
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
    
    
DELIMITER ;;
CREATE PROCEDURE readFullTeam(
    full_team_name VARCHAR(32)
  )
  READS SQL DATA
BEGIN
	select team.name, team.city, team.state, team.seed, mascot.name as mascot_name, 
    homestadium.name as stadium_name, capacity, headcoach.name as headcoach_name, age, experience,
    gleague_aff.name as gleague_name, gleague_aff.city as gleague_city, gleague_aff.state as gleague_state,
    gleague_aff.seed as gleague_seed from team 
    inner join mascot on team.name = mascot.team
    inner join homestadium on team.name = homestadium.team
    inner join headcoach on team.name = headcoach.team
    inner join gleague_aff on team.name = gleague_aff.team
    where team.name = full_team_name;
END ;;
DELIMITER ;