INSERT INTO `addon_account` (name, label, shared) VALUES 
	('society_mechanic','mechanic',1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
	('society_mechanic','mechanic',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
	('society_mechanic', 'mechanic', 1)
;

INSERT INTO `jobs` (`name`, `label`) VALUES
('mechanic', "Benny's")
;

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('mechanic', 0, 'novice', 'Débutant', 200, 'null', 'null'),
('mechanic', 1, 'expert', 'Mecano', 400, 'null', 'null'),
('mechanic', 2, 'chef', "Chef d'atelier", 600, 'null', 'null'),
('mechanic', 3, 'boss', 'Patron', 1000, 'null', 'null')
;
