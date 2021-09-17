-- prefix: rrze_hub_

-- CREATE TABLE rrze_hub_microdata (
--     ID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
--     itemscope
--     sTable VARCHAR(2) NOT NULL,
--     sField VARCHAR(2) NOT NULL,
--     sItemprop VARCHAR(2) NOT NULL,
--     sValue 
--     tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
--     tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
-- );



CREATE TABLE rrze_hub_univis (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    sUnivisID VARCHAR(255) NOT NULL UNIQUE, 
    tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE rrze_hub_organization (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    -- univisID INT NOT NULL, 
    sUnivisID VARCHAR(255), 
    sName VARCHAR(50) NOT NULL UNIQUE,
    -- FOREIGN KEY (univisID) REFERENCES rrze_hub_univis (ID) 
    --     ON DELETE CASCADE,
    tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE rrze_hub_department (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    -- univisID INT NOT NULL, 
    sUnivisID VARCHAR(255), 
    organizationID INT NOT NULL, 
    sName VARCHAR(50) NOT NULL UNIQUE,
    -- FOREIGN KEY (univisID) REFERENCES rrze_hub_univis (ID) 
    --     ON DELETE CASCADE,
    FOREIGN KEY (organizationID) REFERENCES rrze_hub_organization (ID) 
        ON DELETE CASCADE,
    tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE rrze_hub_language (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    sShort VARCHAR(2) NOT NULL UNIQUE,
    sLong VARCHAR(255) NOT NULL,
    tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE rrze_hub_lecturetype (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    sShort VARCHAR(2) NOT NULL UNIQUE,
    sLong VARCHAR(255) NOT NULL, 
    tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE rrze_hub_lecture (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    univisID INT NOT NULL, 
    sKey VARCHAR(255) NOT NULL UNIQUE, 
    sLectureID VARCHAR(255), 
    sName VARCHAR(255), 
    sEctsname VARCHAR(255), 
    languageID INT NOT NULL, 
    lecturetypeID INT NOT NULL,  
    sUrl VARCHAR(255) NOT NULL,
    sSummary TEXT NOT NULL,
    iSws INT(2) NOT NULL,
    bEcts BOOLEAN NOT NULL DEFAULT 0,
    sEctscredits VARCHAR(255),
    bBeginners BOOLEAN NOT NULL DEFAULT 0,
    bEarlystudy BOOLEAN NOT NULL DEFAULT 0,
    bGuest BOOLEAN NOT NULL DEFAULT 0,
    bEvaluation BOOLEAN NOT NULL DEFAULT 0,
    FOREIGN KEY (univisID) REFERENCES rrze_hub_univis (ID) 
        ON DELETE CASCADE,
    FOREIGN KEY (lecturetypeID) REFERENCES rrze_hub_lecturetype (ID) 
        ON DELETE CASCADE,
    tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE rrze_hub_person (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    sKey VARCHAR(255) NOT NULL UNIQUE, 
    sPersonID VARCHAR(255), 
    sTitle VARCHAR(255), 
    sTitleLong VARCHAR(255),
    sAtitle VARCHAR(255), 
    sFirstname VARCHAR(255) NOT NULL,
    sLastname VARCHAR(255) NOT NULL,
    tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE rrze_hub_personDepartment (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    personID INT NOT NULL,
    departmentID INT NOT NULL,
    sWork TEXT NOT NULL,
    UNIQUE(personID, departmentID),
    FOREIGN KEY (personID) REFERENCES rrze_hub_person (ID) 
        ON DELETE CASCADE,
    FOREIGN KEY (departmentID) REFERENCES rrze_hub_department (ID) 
        ON DELETE CASCADE,
    tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);



CREATE TABLE rrze_hub_position (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    sName VARCHAR(255) NOT NULL UNIQUE, 
    tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE rrze_hub_personPosition (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    personID INT NOT NULL,
    positionID INT NOT NULL,
    iOrder INT, 
    UNIQUE(personID, positionID, iOrder),
    FOREIGN KEY (personID) REFERENCES rrze_hub_person (ID) 
        ON DELETE CASCADE,
    FOREIGN KEY (positionID) REFERENCES rrze_hub_position (ID) 
        ON DELETE CASCADE,
    tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);



CREATE TABLE rrze_hub_personLecture (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    personID INT NOT NULL,
    lectureID INT NOT NULL,
    UNIQUE(personID, lectureID),
    FOREIGN KEY (personID) REFERENCES rrze_hub_person (ID) 
        ON DELETE CASCADE,
    FOREIGN KEY (lectureID) REFERENCES rrze_hub_lecture (ID) 
        ON DELETE CASCADE,
    tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE rrze_hub_room (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    sKey VARCHAR(255) NOT NULL UNIQUE, 
    sName VARCHAR(255), 
    sShort VARCHAR(255), 
    sRoomNo VARCHAR(255), 
    sBuildNo VARCHAR(255), 
    sAddress VARCHAR(255), 
    sDescription VARCHAR(255), 
    sNorth VARCHAR(255), 
    sEast VARCHAR(255), 
    tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE rrze_hub_course (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    lectureID INT NOT NULL,
    roomID INT NOT NULL,
    sRepeat VARCHAR(255),
    sExclude VARCHAR(255),
    tStart TIME NOT NULL,
    tEnd TIME NOT NULL,
    UNIQUE(lectureID, roomID, tStart, tEnd, sRepeat, sExclude),
    FOREIGN KEY (lectureID) REFERENCES rrze_hub_lecture (ID) 
        ON DELETE CASCADE,
    FOREIGN KEY (roomID) REFERENCES rrze_hub_room (ID) 
        ON DELETE CASCADE,
    tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE rrze_hub_job (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE rrze_hub_officehours (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    tStart TIME NOT NULL,
    tEnd TIME NOT NULL,
    sOffice VARCHAR(255),
    sRepeat VARCHAR(255),
    sComment VARCHAR(255),
    UNIQUE(tStart, tEnd, sOffice, sRepeat, sComment),
    tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE rrze_hub_personOfficehours (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    personID INT NOT NULL,
    officehoursID INT NOT NULL,
    UNIQUE(personID, officehoursID),
    FOREIGN KEY (personID) REFERENCES rrze_hub_person (ID) 
        ON DELETE CASCADE,
    FOREIGN KEY (officehoursID) REFERENCES rrze_hub_officehours (ID) 
        ON DELETE CASCADE,
    tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);



-- CREATE TABLE rrze_hub_timeinfo (
--     ID INT AUTO_INCREMENT PRIMARY KEY,
--     sWeekday VARCHAR(2) NOT NULL,
--     tStart TIME NOT NULL, 
--     tEnd TIME NOT NULL, 
--     bRecurring BOOLEAN DEFAULT TRUE,
--     dEnd DATE, 
--     tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
--     tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
-- );


CREATE TABLE rrze_hub_location (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    sOffice VARCHAR(50),
    sEmail VARCHAR(50),
    sTel VARCHAR(50),
    sTelCall VARCHAR(50),
    sFax VARCHAR(50),
    sMobile VARCHAR(50),
    sMobileCall VARCHAR(50),
    sUrl VARCHAR(50),
    sStreet VARCHAR(50),
    sCity VARCHAR(50),
    UNIQUE(sOffice, sEmail),
    tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);




CREATE TABLE rrze_hub_personLocation (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    personID INT NOT NULL,
    locationID INT NOT NULL,
    UNIQUE(personID, locationID),
    FOREIGN KEY (personID) REFERENCES rrze_hub_person (ID) 
        ON DELETE CASCADE,
    FOREIGN KEY (locationID) REFERENCES rrze_hub_location (ID) 
        ON DELETE CASCADE,
    tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);








-- stored procedures to insert/update data blocks


DELIMITER @@

CREATE OR REPLACE PROCEDURE setUnivis (
    sUnivisIDIN VARCHAR(255),
    OUT retID INT
)
COMMENT 'return: rrze_hub_univis.ID - Add/Update univis'
BEGIN
    START TRANSACTION;
    -- all fields refer to unique key, but INSERT IGNORE is not recommended as it ignores ALL errors
    INSERT INTO rrze_hub_univis (sUnivisID) VALUES (sUnivisIDIN)
    ON DUPLICATE KEY UPDATE sUnivisID = sUnivisIDIN; 
    COMMIT;
    SELECT ID INTO retID FROM rrze_hub_univis WHERE sUnivisID = sUnivisIDIN;
    IF retID <= 0 THEN
        ROLLBACK;
    END IF; 
END@@


CREATE OR REPLACE PROCEDURE setOfficehours (
    tStartIN TIME,
    tEndIN TIME,
    sOfficeIN VARCHAR(255),
    sRepeatIN VARCHAR(255),
    sCommentIN VARCHAR(255),
    OUT retID INT
)
COMMENT 'return: rrze_hub_officehours.ID - Add/Update officehours'
BEGIN
    START TRANSACTION;
    -- all fields refere to unique key, but INSERT IGNORE is not recommended as it ignores ALL errors
    INSERT INTO rrze_hub_officehours (tStart, tEnd, sOffice, sRepeat, sComment) VALUES (tStartIN, tEndIN, sOfficeIN, sRepeatIN, sCommentIN)
    ON DUPLICATE KEY UPDATE tStart = tStartIN; 
    COMMIT;
    SELECT ID INTO retID FROM rrze_hub_officehours WHERE tStart = tStartIN AND tEnd = tEndIN AND sOffice = sOfficeIN AND sRepeat = sRepeatIN AND sComment = sCommentIN;
    IF retID <= 0 THEN
        ROLLBACK;
    END IF; 
END@@


CREATE OR REPLACE PROCEDURE setPersonOfficehours (
    IN personIDIN INT,
    IN officehoursIDIN INT
)
BEGIN
    START TRANSACTION;
    INSERT INTO rrze_hub_personOfficehours (personID, officehoursID) VALUES (personIDIN, officehoursIDIN)
    ON DUPLICATE KEY UPDATE personID = personIDIN, officehoursID = officehoursIDIN;
    COMMIT;
    -- 2DO: bulk insert
END@@


CREATE OR REPLACE PROCEDURE setLocation (
    IN sOfficeIN VARCHAR(50),
    IN sEmailIN VARCHAR(50),
    IN sTelIN VARCHAR(50),
    IN sTelCallIN VARCHAR(50),
    IN sFaxIN VARCHAR(50),
    IN sMobileIN VARCHAR(50),
    IN sMobileCallIN VARCHAR(50),
    IN sUrlIN VARCHAR(50),
    IN sStreetIN VARCHAR(50),
    IN sCityIN VARCHAR(50),
    OUT retID INT
)
COMMENT 'return: rrze_hub_location.ID - Add/Update location'
BEGIN
    START TRANSACTION;
    INSERT INTO rrze_hub_location (sOffice, sEmail, sTel, sTelCall, sFax, sMobile, sMobileCall, sUrl, sStreet, sCity) VALUES (sOfficeIN, sEmailIN, sTelIN, sTelCallIN, sFaxIN, sMobileIN, sMobileCallIN, sUrlIN, sStreetIN, sCityIN)
    ON DUPLICATE KEY UPDATE sTel = sTelIN, sTelCall = sTelCallIN, sFax = sFaxIN, sMobile = sMobileIN, sMobileCall = sMobileCallIN, sUrl = sUrlIN, sStreet = sStreetIN, sCity = sCityIN;
    COMMIT;
    SELECT ID INTO retID FROM rrze_hub_location WHERE sOffice = sOfficeIN AND sEmail = sEmailIN AND sTel = sTelIN AND sTelCall = sTelCallIN AND sFax = sFaxIN AND sMobile = sMobileIN AND sMobileCall = sMobileCallIN AND sUrl = sUrlIN AND sStreet = sStreetIN AND sCity = sCityIN;
    IF retID <= 0 THEN
        ROLLBACK;
    END IF; 
END@@


CREATE OR REPLACE PROCEDURE setOrganization (
    -- IN univisIDIN INT,
    IN sUnivisIDIN VARCHAR(255), 
    IN sNameIN VARCHAR(255), 
    OUT retID INT
)
COMMENT 'return: rrze_hub_organization.ID - Add/Update organization'
BEGIN
    START TRANSACTION;
    -- all fields refere to unique key, but INSERT IGNORE is not recommended as it ignores ALL errors
    INSERT INTO rrze_hub_organization (sUnivisID, sName) VALUES (sUnivisIDIN, sNameIN)
    ON DUPLICATE KEY UPDATE sName = sNameIN; 
    COMMIT;
    SELECT ID INTO retID FROM rrze_hub_organization WHERE sName = sNameIN;
    IF retID <= 0 THEN
        ROLLBACK;
    END IF; 
END@@


CREATE OR REPLACE PROCEDURE setDepartment (
    -- IN univisIDIN INT,
    IN sUnivisIDIN VARCHAR(255), 
    IN organizationIDIN INT,
    IN sNameIN VARCHAR(255), 
    OUT retID INT
)
COMMENT 'return: rrze_hub_department.ID - Add/Update department'
BEGIN
    START TRANSACTION;
    -- all fields refere to unique key, but INSERT IGNORE is not recommended as it ignores ALL errors
    INSERT INTO rrze_hub_department (sUnivisID, organizationID, sName) VALUES (sUnivisIDIN, organizationIDIN, sNameIN)
    ON DUPLICATE KEY UPDATE sName = sNameIN; 
    COMMIT;
    SELECT ID INTO retID FROM rrze_hub_department WHERE sName = sNameIN;
    IF retID <= 0 THEN
        ROLLBACK;
    END IF; 
END@@


CREATE OR REPLACE PROCEDURE setPersonDepartment (
    IN personIDIN INT,
    IN departmentIDIN INT,
    IN sWorkIN VARCHAR(255)
)
BEGIN
    START TRANSACTION;
    INSERT INTO rrze_hub_personDepartment (personID, departmentID, sWork) VALUES (personIDIN, departmentIDIN, sWorkIN)
    ON DUPLICATE KEY UPDATE sWork = sWorkIN;
    COMMIT;
END@@


CREATE OR REPLACE PROCEDURE setPosition (
    IN sNameIN VARCHAR(255), 
    OUT retID INT
)
COMMENT 'return: rrze_hub_position.ID - Add/Update positions'
BEGIN
    START TRANSACTION;
    -- all fields refere to unique key, but INSERT IGNORE is not recommended as it ignores ALL errors
    INSERT INTO rrze_hub_position (sName) VALUES (sNameIN)
    ON DUPLICATE KEY UPDATE sName = sNameIN; 
    COMMIT;
    SELECT ID INTO retID FROM rrze_hub_position WHERE sName = sNameIN;
    IF retID <= 0 THEN
        ROLLBACK;
    END IF; 
END@@


CREATE OR REPLACE PROCEDURE setPersonPosition (
    IN personIDIN INT,
    IN positionIDIN INT,
    IN iOrderIN INT
)
BEGIN
    START TRANSACTION;
    INSERT INTO rrze_hub_personPosition (personID, positionID, iOrder) VALUES (personIDIN, positionIDIN, iOrderIN)
    ON DUPLICATE KEY UPDATE iOrder = iOrderIN;
    COMMIT;
END@@


CREATE OR REPLACE PROCEDURE setLectureType (
    IN sShortIN VARCHAR(2), 
    IN sLongIN VARCHAR(255),
    OUT retID INT
)
COMMENT 'return: rrze_hub_lecturetype.ID - Add/Update lectureType'
BEGIN
    START TRANSACTION;
    INSERT INTO rrze_hub_lecturetype (sShort, sLong) VALUES (sShortIN, sLongIN)
    ON DUPLICATE KEY UPDATE sLong = sLongIN;
    COMMIT;
    SELECT ID INTO retID FROM rrze_hub_lecturetype WHERE sShort = sShortIN;
    IF retID <= 0 THEN
        ROLLBACK;
    END IF; 
END@@


CREATE OR REPLACE PROCEDURE setLanguage (
    IN aLangIN BLOB
)
BEGIN
    SET @sql = CONCAT("INSERT INTO rrze_hub_language (sShort, sLong) VALUES ", aLangIN, " ON DUPLICATE KEY UPDATE sLong = VALUES(sLong)");
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
END@@


CREATE OR REPLACE PROCEDURE setPerson (
    IN sKeyIN VARCHAR(255), 
    IN sPersonIDIN VARCHAR(255), 
    IN sTitleIN VARCHAR(255), 
    IN sTitleLongIN VARCHAR(255),
    IN sAtitleIN VARCHAR(255), 
    IN sFirstnameIN VARCHAR(255), 
    IN sLastnameIN VARCHAR(255), 
    OUT retID INT
)
COMMENT 'return: rrze_hub_person.ID - Add/Update person'
BEGIN
    START TRANSACTION;
    INSERT INTO rrze_hub_person (sKey, sPersonID, sTitle, sTitleLong, sAtitle, sFirstname, sLastname) VALUES (sKeyIN, sPersonIDIN, sTitleIN, sTitleLongIN, sAtitleIN, sFirstnameIN, sLastnameIN)
    ON DUPLICATE KEY UPDATE sPersonID = sPersonIDIN, sTitle = sTitleIN, sTitleLong = sTitleLongIN, sAtitle = sAtitleIN, sFirstname = sFirstnameIN, sLastname = sLastnameIN;
    COMMIT;
    SELECT ID INTO retID FROM rrze_hub_person WHERE sKey = sKeyIN;
    IF retID <= 0 THEN
        ROLLBACK;
    END IF; 
END@@


CREATE OR REPLACE PROCEDURE setPersonLocation (
    IN personIDIN INT,
    IN locationIDIN INT
)
BEGIN
    START TRANSACTION;
    INSERT INTO rrze_hub_personLocation (personID, locationID) VALUES (personIDIN, locationIDIN)
    ON DUPLICATE KEY UPDATE personID = personIDIN, locationID = locationIDIN;
    COMMIT;
    -- 2DO: bulk insert
END@@


CREATE OR REPLACE PROCEDURE setCourse (
    IN lectureIDIN INT, 
    IN roomIDIN INT, 
    IN sRepeatIN VARCHAR(255),
    IN sExcludeIN VARCHAR(255),
    IN tStartIN TIME,
    IN tEndIN TIME
)
COMMENT 'Add/Update course'
BEGIN
    START TRANSACTION;
    INSERT INTO rrze_hub_course (lectureID, roomID, sRepeat, sExclude, tStart, tEnd) VALUES (lectureIDIN, roomIDIN, sRepeatIN, sExcludeIN, tStartIN, tEndIN)
    ON DUPLICATE KEY UPDATE roomID = roomIDIN, sRepeat = sRepeatIN, sExclude = sExcludeIN, tStart = tStartIN, tEnd = tEndIN;
    COMMIT;
END@@


CREATE OR REPLACE PROCEDURE setRoom (
    IN sKeyIN VARCHAR(255), 
    IN sNameIN VARCHAR(255), 
    IN sShortIN VARCHAR(255), 
    IN sRoomNoIN VARCHAR(255), 
    IN sBuildNoIN VARCHAR(255), 
    IN sAddressIN VARCHAR(255), 
    IN sDescriptionIN VARCHAR(255),
    IN sNorthIN VARCHAR(255),
    IN sEastIN VARCHAR(255),
    OUT retID INT
)
COMMENT 'return: rrze_hub_room.ID - Add/Update room'
BEGIN
    START TRANSACTION;
    INSERT INTO rrze_hub_room (sKey, sName, sShort, sRoomNo, sBuildNo, sAddress, sDescription, sNorth, sEast) VALUES (sKeyIN, sNameIN, sShortIN, sRoomNoIN, sBuildNoIN, sAddressIN, sDescriptionIN, sNorthIN, sEastIN)
    ON DUPLICATE KEY UPDATE sKey = sKeyIN, sName = sNameIN, sShort = sShortIN, sRoomNo = sRoomNoIN, sBuildNo = sBuildNoIN, sAddress = sAddressIN, sDescription = sDescriptionIN, sNorth = sNorthIN, sEast = sEastIN;
    COMMIT;
    SELECT ID INTO retID FROM rrze_hub_room WHERE sKey = sKeyIN AND sName = sNameIN AND sShort = sShortIN AND sRoomNo = sRoomNoIN AND sBuildNo = sBuildNoIN AND sAddress = sAddressIN AND sDescription = sDescriptionIN AND sNorth = sNorthIN AND sEast = sEastIN;
    IF retID <= 0 THEN
        ROLLBACK;
    END IF; 
END@@


CREATE OR REPLACE PROCEDURE setLecture (
    IN univisIDIN INT, 
    IN sNameIN VARCHAR(255),
    IN sEctsnameIN VARCHAR(255),
    IN lecturetypeIDIN INT, 
    IN languageIDIN INT, 
    IN sUrlIN VARCHAR(255),
    IN iSwsIN INT(2),
    IN bBeginnersIN BOOLEAN,
    IN bEarlystudyIN BOOLEAN,
    IN bGuestIN BOOLEAN,
    IN bEvaluationIN BOOLEAN,
    IN bEctsIN BOOLEAN,
    IN sEctscreditsIN VARCHAR(255),
    IN sSummaryIN TEXT,
    IN sKeyIN VARCHAR(255),
    IN sLectureIDIN VARCHAR(255), 
    OUT retID INT
)
COMMENT 'return: rrze_hub_lecture.ID - Add/Update lecture'
BEGIN 
    START TRANSACTION;
    INSERT INTO rrze_hub_lecture (univisID, sName, sEctsname, sUrl, iSws, bBeginners, bEarlystudy, bGuest, bEvaluation, bEcts, sEctscredits, sSummary, sKey, sLectureID, lecturetypeID, languageID) VALUES (univisIDIN, sNameIN, sEctsnameIN, sUrlIN, iSwsIN, bBeginnersIN, bEarlystudyIN, bGuestIN, bEvaluationIN, bEctsIN, sEctscreditsIN, sSummaryIN, sKeyIN, sLectureIDIN, lecturetypeIDIN, languageIDIN)
    ON DUPLICATE KEY 
    UPDATE univisID = univisIDIN, sName = sNameIN, sEctsname = sEctsnameIN, sUrl = sUrlIN, iSws = iSwsIN, bBeginners = bBeginnersIN, bEarlystudy = bEarlystudyIN, bGuest = bGuestIN, bEvaluation = bEvaluationIN, bEcts = bEctsIN, sEctscredits = sEctscreditsIN, sSummary = sSummaryIN, sKey = sKeyIN, sLectureID = sLectureIDIN, lecturetypeID = lecturetypeIDIN, languageID = languageIDIN;
    COMMIT;
    SELECT ID INTO retID FROM rrze_hub_lecture WHERE univisID = univisIDIN AND sName = sNameIN AND sEctsname = sEctsnameIN AND sUrl = sUrlIN AND iSws = iSwsIN AND bBeginners = bBeginnersIN AND bEarlystudy = bEarlystudyIN AND bGuest = bGuestIN AND bEvaluation = bEvaluationIN AND bEcts = bEctsIN AND sEctscredits = sEctscreditsIN AND sSummary = sSummaryIN AND sKey = sKeyIN AND sLectureID = sLectureIDIN AND lecturetypeID = lecturetypeIDIN AND languageID = languageIDIN;
    IF retID <= 0 THEN
        ROLLBACK;
    END IF; 
END@@


CREATE OR REPLACE PROCEDURE setPersonLecture (
    IN lectureIDIN INT,
    IN personIDIN INT
)
BEGIN
    START TRANSACTION;
    INSERT INTO rrze_hub_personLecture (lectureID, personID) VALUES (lectureIDIN, personIDIN)
    ON DUPLICATE KEY UPDATE lectureID = lectureIDIN, personID = personIDIN;
    COMMIT;

    -- 2DO: bulk insert
    -- SET @sql = CONCAT("INSERT INTO rrze_hub_personLecture (personID, lectureID) VALUES (", aPersonIDIN, "),(", lectureIDIN,") ON DUPLICATE KEY UPDATE personID = VALUES(", aPersonIDIN, ")");
    -- PREPARE stmt FROM @sql;
    -- EXECUTE stmt;
    -- INSERT INTO rrze_hub_personLecture (personID, lectureID) VALUES (213,213),(321,456);
END@@


CREATE OR REPLACE PROCEDURE storeLecture (
    IN univisIDIN INT,
    IN sNameIN VARCHAR(255),
    IN sEctsnameIN VARCHAR(255),
    IN lectureTypeIN VARCHAR(255), 
    IN lectureTypeShortIN VARCHAR(2), 
    IN sUrlIN VARCHAR(255),
    IN iSwsIN INT(2),
    IN bBeginnersIN BOOLEAN,
    IN bEarlystudyIN BOOLEAN,
    IN bGuestIN BOOLEAN,
    IN bEvaluationIN BOOLEAN,
    IN bEctsIN BOOLEAN,
    IN sEctscreditsIN VARCHAR(255),
    IN sLanguageIN VARCHAR(2),
    IN sSummaryIN TEXT,
    IN sKeyIN VARCHAR(255),
    IN sLectureIDIN VARCHAR(255),
    OUT retID INT
)
COMMENT 'return: rrze_hub_lecture.ID - Add/Update lecture'
BEGIN 
    DECLARE ltID INT DEFAULT 0;
    DECLARE lID INT DEFAULT 0;

    START TRANSACTION;
    -- store reference data
    CALL setLectureType(lectureTypeShortIN, lectureTypeIN, @retID);
    SELECT @retID INTO ltID;
    SELECT ID INTO lID FROM rrze_hub_language WHERE sShort = sLanguageIN;

    -- store lecture
    CALL setLecture(univisIDIN, sNameIN, sEctsnameIN, ltID, lID, sUrlIN, iSwsIN, bBeginnersIN, bEarlystudyIN, bGuestIN, bEvaluationIN, bEctsIN, sEctscreditsIN, sSummaryIN, sKeyIN, sLectureIDIN, @retID);
    SET retID = @retID;
END@@


DELIMITER @@

CREATE OR REPLACE PROCEDURE deleteUnivis (
    IN sUnivisIDIN VARCHAR(255)
)
COMMENT 'deletes entries in rrze_hub_univis and cascading all persons and all lectures related to'
BEGIN 
    START TRANSACTION;
    DELETE FROM rrze_hub_univis WHERE sUnivisID = sUnivisIDIN;
    COMMIT;
END@@



DELIMITER @@

CREATE OR REPLACE PROCEDURE deleteLecture (
    IN univisIDIN INT,
    IN sIDIN TEXT,
    OUT iDel INT
)
COMMENT 'deletes lectures'
BEGIN 
    IF sIDIN = '' THEN SET sIDIN = '0'; END IF;
    SET @sql = CONCAT("DELETE FROM rrze_hub_lecture WHERE univisID = ", univisIDIN, " AND ID NOT IN (", sIDIN, ")");
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    SELECT ROW_COUNT() INTO iDel;
END@@


DELIMITER @@

CREATE OR REPLACE PROCEDURE deletePerson (
    IN sIDIN TEXT,
    OUT iDel INT
)
COMMENT 'deletes persons'
BEGIN 
    IF sIDIN = '' THEN SET sIDIN = '0'; END IF;
    SET @sql = CONCAT("DELETE FROM rrze_hub_person WHERE ID NOT IN (", sIDIN, ")");
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    SELECT ROW_COUNT() INTO iDel;
END@@


DELIMITER ;






-- views


CREATE OR REPLACE VIEW getPersons AS 
    SELECT 
        orga.org_univisID,
        orga.dep_univisID,
        p.ID, 
        p.sKey AS 'key',
        p.sPersonID AS person_id,
        p.sTitle AS title,
        p.sTitleLong AS title_long,
        p.sAtitle AS atitle,
        CONCAT(p.sLastname, ',', p.sFirstname) AS 'name',
        p.sFirstname AS firstname,
        p.sLastname AS lastname,
        orga.organization,
        orga.department,
        orga.sWork AS work,
        pos.sName AS position,
        pos.iOrder AS position_order,
        UCASE(LEFT(p.sLastname, 1)) AS letter,
        loc.ID AS locationID,
        loc.sOffice AS office,
        loc.sEmail AS email,
        loc.sCity AS city,
        loc.sStreet AS street,
        loc.sTel AS tel,
        loc.sTelCall AS tel_call,
        loc.sMobile AS mobile,
        loc.sMobileCall AS mobile_call,
        loc.sFax AS fax,
        loc.sUrl AS 'url',
        oh.ID AS officehoursID,
        oh.tStarttime AS starttime,
        oh.tEndtime AS endtime,
        oh.sOffice AS officehours_office,
        oh.sRepeat AS 'repeat',
        oh.sComment AS comment
    FROM 
        rrze_hub_person p
    LEFT JOIN
        (SELECT
            pd.personID,
            org.sUnivisID AS org_univisID,
            dep.sUnivisID AS dep_univisID,
            org.sName AS organization,
            dep.sName AS department,
            pd.sWork
        FROM 
            rrze_hub_organization org,
            rrze_hub_department dep,
            rrze_hub_personDepartment pd
        WHERE 
            org.ID = dep.organizationID AND 
            dep.ID = pd.departmentID
        ) orga 
    ON p.ID = orga.personID
    LEFT JOIN 
        (SELECT 
            pl.personID,
            l.ID,
            l.sOffice,
            l.sEmail,
            l.sCity,
            l.sStreet,
            l.sTel,
            l.sTelCall,
            l.sMobile,
            l.sMobileCall,
            l.sFax,
            l.sUrl
        FROM 
            rrze_hub_location l,
            rrze_hub_personLocation pl 
        WHERE 
            l.ID = pl.locationID) loc 
    ON p.ID = loc.personID
    LEFT JOIN 
        (SELECT 
            po.personID,
            o.ID,
            DATE_FORMAT(o.tStart, "%H:%i") AS tStarttime,
            DATE_FORMAT(o.tEnd, "%H:%i") AS tEndtime,
            o.sOffice,
            o.sRepeat,
            o.sComment
        FROM 
            rrze_hub_officehours o,
            rrze_hub_personOfficehours po 
        WHERE 
            o.ID = po.officehoursID
        ORDER BY 
            FIELD(o.sRepeat, 'Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So')) oh 
    ON p.ID = oh.personID
    LEFT JOIN 
        (SELECT
            pp.personID,
            ps.sName,
            pp.iOrder
        FROM
            rrze_hub_position ps,
            rrze_hub_personPosition pp
        WHERE
            ps.ID = pp.positionID) pos
    ON p.ID = pos.personID;


CREATE OR REPLACE VIEW getLectures AS 
    SELECT 
        u.sUnivisID AS univisID,
        lec.sLectureID AS lecture_id, 
        lec.sName AS lecture_title,
        lec.sEctsname AS ects_name,
        lang.sShort AS leclanguage,
        lec.sKey AS 'key',
        lectype.sLong AS lecture_type,
        lec.sUrl AS url_description,
        lec.sSummary AS summary,
        IF(lec.iSws, CONCAT(lec.iSws, " SWS"), NULL) AS sws,
        IF(lec.bEcts, "ECTS-Studium", NULL) AS ects,
        lec.sEctscredits AS ects_cred,
        IF(lec.bBeginners, "Für Anfänger geeignet", NULL) AS beginners,
        IF(lec.bEarlystudy, "Frühstudium", NULL) AS fruehstud,
        IF(lec.bGuest, "Für Gasthörer zugelassen", NULL) AS gast,
        IF(lec.bEvaluation, "Evaluation", NULL) AS evaluation,
        co.tStart AS starttime,
        co.tEnd AS endtime,
        co.sRepeat AS 'repeat',
        co.sExclude AS exclude,
        co.sShort AS short,
        co.sNorth AS north,
        co.sEast AS east,
        p.title,
        p.firstname,
        p.lastname,
        p.person_id 
    FROM 
        rrze_hub_univis u,
        rrze_hub_lecturetype lectype,
        rrze_hub_language lang,
        rrze_hub_lecture lec
    LEFT JOIN 
        (SELECT 
            c.lectureID,
            c.tStart,
            c.tEnd,
            c.sRepeat,
            c.sExclude,
            r.sShort,
            r.sNorth,
            r.sEast
        FROM 
            rrze_hub_course c,
            rrze_hub_room r 
        WHERE
            c.roomID = r.ID
        ) co
    ON lec.ID = co.lectureID
    LEFT JOIN 
        (SELECT 
            gp.*,
            pl.lectureID
        FROM
            getPersons gp,
            rrze_hub_personLecture pl
        WHERE 
            gp.ID = pl.personID    
        ) p
    ON lec.ID = p.lectureID
    WHERE 
        lec.univisID = u.ID AND
        lec.lecturetypeID = lectype.ID AND
        lec.languageID = lang.ID;





-- Stammdaten:
CALL setLanguage("('de', 'German'),('en', 'English'),('es', 'Spanish'),('fr', 'French'),('ru', 'Russian'),('zh', 'Chinese')");

