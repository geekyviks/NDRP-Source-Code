CREATE TABLE `fivem_fishing` (
	`fish` varchar(30) NOT NULL,
	`data` longtext,
	PRIMARY KEY (`fish`)
);

INSERT INTO `fivem_fishing` (`fish`) VALUES
    ('salmon'),
    ('trout'),
    ('char'),
    ('pike'),
    ('goldfish'),
    ('whitefish'),
    ('roach'),
    ('mackerel'),
    ('lobster'), 
    ('crawfish')
;

INSERT INTO `items` (name, label, `limit`) VALUES
	('fishingrod','Fishing Rod', 5),
	('bait', 'Bait', 25),
    ('fishingpermit','Fishing Permit', 5),
    ('salmon', 'Salmon', 20),
    ('trout', 'Trout', 20),
    ('char', 'Char', 20),
    ('pike', 'Pike', 20),
    ('goldfish', 'Gold Fish', 20),
    ('whitefish', 'Sik', 20),
    ('roach', 'Mort', 20),
    ('mackerel', 'Mackerel', 20),
    ('lobster', 'Lobster', 20), 
    ('crawfish','Crawfish', 20)
;