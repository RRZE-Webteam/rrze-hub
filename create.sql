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
    sUnivisID VARCHAR(30) NOT NULL UNIQUE, 
    tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE rrze_hub_language (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    sShort VARCHAR(2) NOT NULL UNIQUE,
    sLong VARCHAR(30) NOT NULL,
    tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE rrze_hub_lecturetype (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    sShort VARCHAR(2) NOT NULL UNIQUE,
    sLong VARCHAR(30) NOT NULL, 
    tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE rrze_hub_lecture (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    univisID INT NOT NULL, 
    sKey VARCHAR(30) NOT NULL UNIQUE, 
    sName VARCHAR(30), 
    sEctsname VARCHAR(30), 
    languageID INT NOT NULL, 
    lecturetypeID INT NOT NULL,  
    sUrl VARCHAR(30) NOT NULL,
    sSummary TEXT NOT NULL,
    iSws INT(2) NOT NULL,
    bEcts BOOLEAN NOT NULL DEFAULT 0,
    sEctscredits VARCHAR(30),
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
    univisID INT NOT NULL, 
    sTitle VARCHAR(30), 
    sAtitle VARCHAR(30), 
    sFirstname VARCHAR(30) NOT NULL,
    sLastname VARCHAR(30) NOT NULL,
    sDepartment VARCHAR(30), 
    sOrganization VARCHAR(30), 
    sWork VARCHAR(30) NOT NULL,
    sOrgaposition VARCHAR(30),
    iOrgaOrder INT,
    sTitleLong VARCHAR(30),
    UNIQUE(univisID, sFirstname, sLastname),
    FOREIGN KEY (univisID) REFERENCES rrze_hub_univis (ID) 
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


CREATE TABLE rrze_hub_course (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    lectureID INT NOT NULL,
    roomID INT NOT NULL,
    sRepeat VARCHAR(30),
    sExclude VARCHAR(30),
    tStart TIME NOT NULL,
    tEnd TIME NOT NULL,
    UNIQUE(lectureID, roomID, tStart, tEnd, sRepeat, sExclude),
    FOREIGN KEY (lectureID) REFERENCES rrze_hub_lecture (ID) 
        ON DELETE CASCADE,
    tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE rrze_hub_job (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE rrze_hub_room (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    sKey VARCHAR(30) NOT NULL UNIQUE, 
    sName VARCHAR(30), 
    sShort VARCHAR(30), 
    sRoomNo VARCHAR(30), 
    sBuildNo VARCHAR(30), 
    sAddress VARCHAR(30), 
    sDescription VARCHAR(255), 
    tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE rrze_hub_officehours (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    tStart TIME NOT NULL,
    tEnd TIME NOT NULL,
    sOffice VARCHAR(30),
    sRepeat VARCHAR(30),
    sComment VARCHAR(30),
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



CREATE TABLE rrze_hub_timeinfo (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    sWeekday VARCHAR(2) NOT NULL,
    tStart TIME NOT NULL, 
    tEnd TIME NOT NULL, 
    bRecurring BOOLEAN DEFAULT TRUE,
    dEnd DATE, 
    tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE rrze_hub_location (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    sOffice VARCHAR(50),
    sEmail VARCHAR(50),
    sTel VARCHAR(50),
    sFax VARCHAR(50),
    sMobile VARCHAR(50),
    sUrl VARCHAR(50),
    sStreet VARCHAR(50),
    sCity VARCHAR(50),
    UNIQUE(sOffice, sEmail),
    tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE rrze_hub_organization (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    locationID INT NOT NULL, 
    sKey VARCHAR(30), 
    sName VARCHAR(50) NOT NULL,
    sUrl VARCHAR(50),
    sEmail VARCHAR(50),
    sTel VARCHAR(50),
    sFax VARCHAR(50),
    FOREIGN KEY (locationID) REFERENCES rrze_hub_location (ID) 
        ON DELETE CASCADE,
    tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE rrze_hub_department (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    sKey VARCHAR(30), 
    organizationID INT NOT NULL, 
    sName VARCHAR(50) NOT NULL,
    sName_en VARCHAR(50),
    sDesc VARCHAR(50),
    sDesc_en VARCHAR(50),
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
    sUnivisIDIN VARCHAR(30),
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
    sOfficeIN VARCHAR(30),
    sRepeatIN VARCHAR(30),
    sCommentIN VARCHAR(30),
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
    IN sFaxIN VARCHAR(50),
    IN sMobileIN VARCHAR(50),
    IN sUrlIN VARCHAR(50),
    IN sStreetIN VARCHAR(50),
    IN sCityIN VARCHAR(50),
    OUT retID INT
)
COMMENT 'return: rrze_hub_location.ID - Add/Update location'
BEGIN
    START TRANSACTION;
    INSERT INTO rrze_hub_location (sOffice, sEmail, sTel, sFax, sMobile, sUrl, sStreet, sCity) VALUES (sOfficeIN, sEmailIN, sTelIN, sFaxIN, sMobileIN, sUrlIN, sStreetIN, sCityIN)
    ON DUPLICATE KEY UPDATE sTel = sTelIN, sFax = sFaxIN, sMobile = sMobileIN, sUrl = sUrlIN, sStreet = sStreetIN, sCity = sCityIN;
    COMMIT;
    SELECT ID INTO retID FROM rrze_hub_location WHERE sOffice = sOfficeIN AND sEmail = sEmailIN AND sTel = sTelIN AND sFax = sFaxIN AND sMobile = sMobileIN AND sUrl = sUrlIN AND sStreet = sStreetIN AND sCity = sCityIN;
    IF retID <= 0 THEN
        ROLLBACK;
    END IF; 
END@@


CREATE OR REPLACE PROCEDURE setLectureType (
    IN sShortIN VARCHAR(2), 
    IN sLongIN VARCHAR(30),
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
    IN univisIDIN INT,
    IN sTitleIN VARCHAR(30), 
    IN sAtitleIN VARCHAR(30), 
    IN sFirstnameIN VARCHAR(30), 
    IN sLastnameIN VARCHAR(30), 
    IN sDepartmentIN VARCHAR(30), 
    IN sOrganizationIN VARCHAR(30), 
    IN sWorkIN VARCHAR(30), 
    IN sOrgapositionIN VARCHAR(30),
    IN iOrgaOrderIN INT,
    IN sTitleLongIN VARCHAR(30),
    OUT retID INT
)
COMMENT 'return: rrze_hub_person.ID - Add/Update person'
BEGIN
    START TRANSACTION;
    INSERT INTO rrze_hub_person (univisID, sTitle, sAtitle, sFirstname, sLastname, sDepartment, sOrganization, sWork, sOrgaposition, iOrgaOrder, sTitleLong) VALUES (univisIDIN, sTitleIN, sAtitleIN, sFirstnameIN, sLastnameIN, sDepartmentIN, sOrganizationIN, sWorkIN, sOrgapositionIN, iOrgaOrderIN, sTitleLongIN)
    ON DUPLICATE KEY UPDATE univisID = univisIDIN, sTitle = sTitleIN, sAtitle = sAtitleIN, sFirstname = sFirstnameIN, sLastname = sLastnameIN, sDepartment = sDepartmentIN, sOrganization = sOrganizationIN, sWork = sWorkIN, sOrgaposition = sOrgapositionIN, iOrgaOrder = iOrgaOrderIN, sTitleLong = sTitleLongIN;
    COMMIT;
    SELECT ID INTO retID FROM rrze_hub_person WHERE univisID = univisIDIN AND sTitle = sTitleIN AND sAtitle = sAtitleIN AND sFirstname = sFirstnameIN AND sLastname = sLastnameIN AND sDepartment = sDepartmentIN AND sOrganization = sOrganizationIN AND sWork = sWorkIN AND sOrgaposition = sOrgapositionIN AND iOrgaOrder = iOrgaOrderIN AND sTitleLong = sTitleLongIN;
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
    IN sRepeatIN VARCHAR(30),
    IN sExcludeIN VARCHAR(30),
    IN tStartIN TIME,
    IN tEndIN TIME
)
COMMENT 'Add/Update course'
BEGIN
    START TRANSACTION;
    -- INSERT INTO rrze_hub_course (personIDIN, sRepeat, sExclude, tStart, tEnd) VALUES (personID, sRepeatIN, sExcludeIN, tStartIN, tEndIN)
    INSERT INTO rrze_hub_course (lectureID, roomID, sRepeat, sExclude, tStart, tEnd) VALUES (lectureIDIN, roomIDIN, sRepeatIN, sExcludeIN, tStartIN, tEndIN)
    -- ON DUPLICATE KEY UPDATE personID = personIDIN, sRepeat = sRepeatIN, sExclude = sExcludeIN, tStart = tStartIN, tEnd = tEndIN;
    ON DUPLICATE KEY UPDATE roomID = roomIDIN, sRepeat = sRepeatIN, sExclude = sExcludeIN, tStart = tStartIN, tEnd = tEndIN;
    COMMIT;
END@@


CREATE OR REPLACE PROCEDURE setRoom (
    IN sKeyIN VARCHAR(30), 
    IN sNameIN VARCHAR(30), 
    IN sShortIN VARCHAR(30), 
    IN sRoomNoIN VARCHAR(30), 
    IN sBuildNoIN VARCHAR(30), 
    IN sAddressIN VARCHAR(30), 
    IN sDescriptionIN VARCHAR(255),
    OUT retID INT
)
COMMENT 'return: rrze_hub_room.ID - Add/Update room'
BEGIN
    START TRANSACTION;
    INSERT INTO rrze_hub_room (sKey, sName, sShort, sRoomNo, sBuildNo, sAddress, sDescription) VALUES (sKeyIN, sNameIN, sShortIN, sRoomNoIN, sBuildNoIN, sAddressIN, sDescriptionIN)
    ON DUPLICATE KEY UPDATE sKey = sKeyIN, sName = sNameIN, sShort = sShortIN, sRoomNo = sRoomNoIN, sBuildNo = sBuildNoIN, sAddress = sAddressIN, sDescription = sDescriptionIN;
    COMMIT;
    SELECT ID INTO retID FROM rrze_hub_room WHERE sKey = sKeyIN AND sName = sNameIN AND sShort = sShortIN AND sRoomNo = sRoomNoIN AND sBuildNo = sBuildNoIN AND sAddress = sAddressIN AND sDescription = sDescriptionIN;
    IF retID <= 0 THEN
        ROLLBACK;
    END IF; 
END@@


CREATE OR REPLACE PROCEDURE setLecture (
    IN univisIDIN INT, 
    IN sNameIN VARCHAR(30),
    IN sEctsnameIN VARCHAR(30),
    IN lecturetypeIDIN INT, 
    IN languageIDIN INT, 
    IN sUrlIN VARCHAR(30),
    IN iSwsIN INT(2),
    IN bBeginnersIN BOOLEAN,
    IN bEarlystudyIN BOOLEAN,
    IN bGuestIN BOOLEAN,
    IN bEvaluationIN BOOLEAN,
    IN bEctsIN BOOLEAN,
    IN sEctscreditsIN VARCHAR(30),
    IN sSummaryIN TEXT,
    IN sKeyIN VARCHAR(30),
    OUT retID INT
)
COMMENT 'return: rrze_hub_lecture.ID - Add/Update lecture'
BEGIN 
    START TRANSACTION;
    INSERT INTO rrze_hub_lecture (univisID, sName, sEctsname, sUrl, iSws, bBeginners, bEarlystudy, bGuest, bEvaluation, bEcts, sEctscredits, sSummary, sKey, lecturetypeID, languageID) VALUES (univisIDIN, sNameIN, sEctsnameIN, sUrlIN, iSwsIN, bBeginnersIN, bEarlystudyIN, bGuestIN, bEvaluationIN, bEctsIN, sEctscreditsIN, sSummaryIN, sKeyIN, lecturetypeIDIN, languageIDIN)
    ON DUPLICATE KEY 
    UPDATE univisID = univisIDIN, sName = sNameIN, sEctsname = sEctsnameIN, sUrl = sUrlIN, iSws = iSwsIN, bBeginners = bBeginnersIN, bEarlystudy = bEarlystudyIN, bGuest = bGuestIN, bEvaluation = bEvaluationIN, bEcts = bEctsIN, sEctscredits = sEctscreditsIN, sSummary = sSummaryIN, sKey = sKeyIN, lecturetypeID = lecturetypeIDIN, languageID = languageIDIN;
    COMMIT;
    SELECT ID INTO retID FROM rrze_hub_lecture WHERE univisID = univisIDIN AND sName = sNameIN AND sEctsname = sEctsnameIN AND sUrl = sUrlIN AND iSws = iSwsIN AND bBeginners = bBeginnersIN AND bEarlystudy = bEarlystudyIN AND bGuest = bGuestIN AND bEvaluation = bEvaluationIN AND bEcts = bEctsIN AND sEctscredits = sEctscreditsIN AND sSummary = sSummaryIN AND sKey = sKeyIN AND lecturetypeID = lecturetypeIDIN AND languageID = languageIDIN;
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
    IN sNameIN VARCHAR(30),
    IN sEctsnameIN VARCHAR(30),
    IN lectureTypeIN VARCHAR(30), 
    IN lectureTypeShortIN VARCHAR(2), 
    IN sUrlIN VARCHAR(30),
    IN iSwsIN INT(2),
    IN bBeginnersIN BOOLEAN,
    IN bEarlystudyIN BOOLEAN,
    IN bGuestIN BOOLEAN,
    IN bEvaluationIN BOOLEAN,
    IN bEctsIN BOOLEAN,
    IN sEctscreditsIN VARCHAR(30),
    IN sLanguageIN VARCHAR(2),
    IN sSummaryIN TEXT,
    IN sKeyIN VARCHAR(30),
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
    CALL setLecture(univisIDIN, sNameIN, sEctsnameIN, ltID, lID, sUrlIN, iSwsIN, bBeginnersIN, bEarlystudyIN, bGuestIN, bEvaluationIN, bEctsIN, sEctscreditsIN, sSummaryIN, sKeyIN, @retID);
    SET retID = @retID;
END@@


DELIMITER @@

CREATE OR REPLACE PROCEDURE deleteUnivis (
    IN sUnivisIDIN VARCHAR(30)
)
COMMENT 'deletes entries in rrze_hub_univis and cascading all persons and all lectures related to'
BEGIN 
    START TRANSACTION;
    DELETE FROM rrze_hub_univis WHERE sUnivisID = sUnivisIDIN;
    COMMIT;
END@@



    SET @sql = CONCAT("INSERT INTO rrze_hub_language (sShort, sLong) VALUES ", aLangIN, " ON DUPLICATE KEY UPDATE sLong = VALUES(sLong)");
    PREPARE stmt FROM @sql;
    EXECUTE stmt;


DELIMITER @@

CREATE OR REPLACE PROCEDURE deleteLecture (
    IN univisIDIN INT,
    IN sIDIN TEXT
)
COMMENT 'deletes lectures'
BEGIN 
    IF sIDIN = '' THEN SET sIDIN = '0'; END IF;
    SET @sql = CONCAT("DELETE FROM rrze_hub_lecture WHERE univisID = ", univisIDIN, " AND ID NOT IN (", sIDIN, ")");
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
END@@


DELIMITER @@

CREATE OR REPLACE PROCEDURE deletePerson (
    IN univisIDIN INT,
    IN sIDIN TEXT
)
COMMENT 'deletes persons'
BEGIN 
    IF sIDIN = '' THEN SET sIDIN = '0'; END IF;
    SET @sql = CONCAT("DELETE FROM rrze_hub_person WHERE univisID = ", univisIDIN, " AND ID NOT IN (", sIDIN, ")");
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
END@@




-- CREATE OR REPLACE PROCEDURE getLectureByID (
--     IN IDIN INT(2),
--     IN bBeginnersIN BOOLEAN,
--     IN bEarlystudyIN BOOLEAN,
--     IN bGuestIN BOOLEAN,
--     IN bEvaluationIN BOOLEAN,
--     IN bEctsIN BOOLEAN,
--     IN sEctscreditsIN VARCHAR(30),
--     IN sLanguageIN VARCHAR(2),
--     IN sSummaryIN TEXT,
--     IN sKeyIN VARCHAR(30),
--     OUT retID VARCHAR(255)
-- )
-- COMMENT 'return: rrze_hub_lecture.ID - Add/Update lecture'
-- BEGIN 
--     DECLARE ltID INT DEFAULT 0;
--     DECLARE lID INT DEFAULT 0;

--     START TRANSACTION;
--     -- store reference data
--     CALL setLectureType(lectureTypeShortIN, lectureTypeIN, @retID);
--     SELECT @retID INTO ltID;
--     SELECT ID INTO lID FROM rrze_hub_language WHERE sShort = sLanguageIN;
--     -- store lecture
--     CALL setLecture(sNameIN, sEctsnameIN, ltID, lID, sUrlIN, iSwsIN, bBeginnersIN, bEarlystudyIN, bGuestIN, bEvaluationIN, bEctsIN, sEctscreditsIN, sSummaryIN, sKeyIN, @retID);
--     SET retID = @retID;
-- END@@



DELIMITER ;





-- views

CREATE OR REPLACE VIEW getLectures AS 
    SELECT 
        u.sUnivisID AS UnivisID,
        lec.ID AS ID,
        lec.sName AS title,
        lec.sEctsname AS title_en,
        lec.sSummary AS summary,
        lec.sUrl AS url_description,
        lectype.sLong AS lecture_type,
        lang.sShort AS lang
    FROM 
        rrze_hub_univis u,
        rrze_hub_lecture lec,
        rrze_hub_lecturetype lectype,
        rrze_hub_language lang
    WHERE 
        lec.univisID = u.ID AND
        lec.lecturetypeID = lectype.ID AND
        lec.languageID = lang.ID;



-- Stammdaten:
CALL setLanguage("('de', 'German'),('en', 'English'),('es', 'Spanish'),('fr', 'French'),('ru', 'Russian'),('zh', 'Chinese')");

