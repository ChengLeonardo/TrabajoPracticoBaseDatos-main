drop user IF EXISTS 'mira'@'10.120.1.%';
CREATE USER 'mira'@'10.120.1.%' IDENTIFIED BY 'Miramira12-';
GRANT SELECT on 5to_Trivago.* TO 'mira'@'10.120.1.%';
drop  USER 'admin'@'%' ;
CREATE USER 'admin'@'%' IDENTIFIED BY 'Miramira12-';
GRANT delete, insert, update, SELECT on 5to_Trivago.* To 'admin'@'%';
