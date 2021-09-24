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
    sUnivisID VARCHAR(255), 
    sName TEXT NOT NULL UNIQUE,
    tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE rrze_hub_department (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    sUnivisID VARCHAR(255), 
    organizationID INT NOT NULL, 
    sName TEXT NOT NULL UNIQUE,
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
    sShort VARCHAR(10) NOT NULL UNIQUE,
    sLong VARCHAR(255) NOT NULL, 
    tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE rrze_hub_lecture (
    ID BIGINT AUTO_INCREMENT PRIMARY KEY,
    univisID INT NOT NULL, 
    sKey VARCHAR(255) NOT NULL UNIQUE, 
    sLectureID VARCHAR(255), 
    sName VARCHAR(255), 
    sEctsname VARCHAR(255), 
    languageID INT NOT NULL, 
    lecturetypeID INT NOT NULL,  
    tStartdate DATE,
    tEnddate DATE,
    tStarttime TIME,
    tEndtime TIME,
    sUrl VARCHAR(255) NOT NULL,
    sComment TEXT,
    sOrganizational TEXT,
    iMaxturnout INT,
    sSummary TEXT NOT NULL,
    iSws INT(2) NOT NULL,
    bEcts BOOLEAN NOT NULL DEFAULT 0,
    sEctscredits VARCHAR(255),
    sEctsliterature TEXT,
    sEctssummary TEXT,
    sEctsorganizational TEXT,
    sKeywords TEXT,
    sLiterature TEXT,
    bBeginners BOOLEAN NOT NULL DEFAULT 0,
    bEarlystudy BOOLEAN NOT NULL DEFAULT 0,
    bGuest BOOLEAN NOT NULL DEFAULT 0,
    bEvaluation BOOLEAN NOT NULL DEFAULT 0,
    bCertification BOOLEAN NOT NULL DEFAULT 0,
    FOREIGN KEY (univisID) REFERENCES rrze_hub_univis (ID) 
        ON DELETE CASCADE,
    FOREIGN KEY (lecturetypeID) REFERENCES rrze_hub_lecturetype (ID) 
        ON DELETE CASCADE,
    tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE rrze_hub_person (
    ID BIGINT AUTO_INCREMENT PRIMARY KEY,
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
    ID BIGINT AUTO_INCREMENT PRIMARY KEY,
    personID BIGINT NOT NULL,
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
    ID BIGINT AUTO_INCREMENT PRIMARY KEY,
    personID BIGINT NOT NULL,
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
    ID BIGINT AUTO_INCREMENT PRIMARY KEY,
    personID BIGINT NOT NULL,
    lectureID BIGINT NOT NULL,
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
    ID BIGINT AUTO_INCREMENT PRIMARY KEY,
    lectureID BIGINT NOT NULL,
    sCourseID VARCHAR(255),
    sName TEXT,
    sDescription VARCHAR(255),
    UNIQUE(lectureID, sCourseID),
    FOREIGN KEY (lectureID) REFERENCES rrze_hub_lecture (ID) 
        ON DELETE CASCADE,
    tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE rrze_hub_personCourse (
    ID BIGINT AUTO_INCREMENT PRIMARY KEY,
    personID BIGINT NOT NULL,
    courseID BIGINT NOT NULL,
    UNIQUE(personID, courseID),
    FOREIGN KEY (personID) REFERENCES rrze_hub_person (ID) 
        ON DELETE CASCADE,
    FOREIGN KEY (courseID) REFERENCES rrze_hub_course (ID) 
        ON DELETE CASCADE,
    tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);



CREATE TABLE rrze_hub_term (
    ID BIGINT AUTO_INCREMENT PRIMARY KEY,
    courseID BIGINT NOT NULL,
    roomID INT NOT NULL,
    sRepeat VARCHAR(255),
    sExclude VARCHAR(255),
    tStartdate DATE,
    tEnddate DATE,
    tStarttime TIME,
    tEndtime TIME,
    FOREIGN KEY (courseID) REFERENCES rrze_hub_course (ID) 
        ON DELETE CASCADE,
    FOREIGN KEY (roomID) REFERENCES rrze_hub_room (ID) 
        ON DELETE CASCADE,
    tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE rrze_hub_stud (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    lectureID BIGINT NOT NULL,
    sRicht VARCHAR(255), 
    sPflicht VARCHAR(255), 
    iSem INT, 
    sCredits VARCHAR(255),
    UNIQUE(lectureID, sRicht, sPflicht, iSem, sCredits),
    FOREIGN KEY (lectureID) REFERENCES rrze_hub_lecture (ID) 
        ON DELETE CASCADE,
    tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE rrze_hub_job (
    ID BIGINT AUTO_INCREMENT PRIMARY KEY,
    tsInsert TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE rrze_hub_officehours (
    ID BIGINT AUTO_INCREMENT PRIMARY KEY,
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
    ID BIGINT AUTO_INCREMENT PRIMARY KEY,
    personID BIGINT NOT NULL,
    officehoursID BIGINT NOT NULL,
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
    ID BIGINT AUTO_INCREMENT PRIMARY KEY,
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
    ID BIGINT AUTO_INCREMENT PRIMARY KEY,
    personID BIGINT NOT NULL,
    locationID BIGINT NOT NULL,
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
    OUT retID BIGINT
)
COMMENT 'return: rrze_hub_officehours.ID - Add/Update officehours'
BEGIN
    START TRANSACTION;
    -- all fields refer to unique key, but INSERT IGNORE is not recommended as it ignores ALL errors
    INSERT INTO rrze_hub_officehours (tStart, tEnd, sOffice, sRepeat, sComment) VALUES (tStartIN, tEndIN, sOfficeIN, sRepeatIN, sCommentIN)
    ON DUPLICATE KEY UPDATE tStart = tStartIN; 
    COMMIT;
    SELECT ID INTO retID FROM rrze_hub_officehours WHERE tStart = tStartIN AND tEnd = tEndIN AND sOffice = sOfficeIN AND sRepeat = sRepeatIN AND sComment = sCommentIN;
    IF retID <= 0 THEN
        ROLLBACK;
    END IF; 
END@@


CREATE OR REPLACE PROCEDURE setPersonOfficehours (
    IN personIDIN BIGINT,
    IN officehoursIDIN BIGINT
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
    OUT retID BIGINT
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
    IN sUnivisIDIN VARCHAR(255), 
    IN sNameIN VARCHAR(255), 
    OUT retID INT
)
COMMENT 'return: rrze_hub_organization.ID - Add/Update organization'
BEGIN
    START TRANSACTION;
    -- all fields refer to unique key, but INSERT IGNORE is not recommended as it ignores ALL errors
    INSERT INTO rrze_hub_organization (sUnivisID, sName) VALUES (sUnivisIDIN, sNameIN)
    ON DUPLICATE KEY UPDATE sName = sNameIN; 
    COMMIT;
    SELECT ID INTO retID FROM rrze_hub_organization WHERE sName = sNameIN;
    IF retID <= 0 THEN
        ROLLBACK;
    END IF; 
END@@


CREATE OR REPLACE PROCEDURE setDepartment (
    IN sUnivisIDIN VARCHAR(255), 
    IN organizationIDIN INT,
    IN sNameIN VARCHAR(255), 
    OUT retID INT
)
COMMENT 'return: rrze_hub_department.ID - Add/Update department'
BEGIN
    START TRANSACTION;
    -- all fields refer to unique key, but INSERT IGNORE is not recommended as it ignores ALL errors
    INSERT INTO rrze_hub_department (sUnivisID, organizationID, sName) VALUES (sUnivisIDIN, organizationIDIN, sNameIN)
    ON DUPLICATE KEY UPDATE sName = sNameIN; 
    COMMIT;
    SELECT ID INTO retID FROM rrze_hub_department WHERE sName = sNameIN;
    IF retID <= 0 THEN
        ROLLBACK;
    END IF; 
END@@


CREATE OR REPLACE PROCEDURE setPersonDepartment (
    IN personIDIN BIGINT,
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
    -- all fields refer to unique key, but INSERT IGNORE is not recommended as it ignores ALL errors
    INSERT INTO rrze_hub_position (sName) VALUES (sNameIN)
    ON DUPLICATE KEY UPDATE sName = sNameIN; 
    COMMIT;
    SELECT ID INTO retID FROM rrze_hub_position WHERE sName = sNameIN;
    IF retID <= 0 THEN
        ROLLBACK;
    END IF; 
END@@


CREATE OR REPLACE PROCEDURE setPersonPosition (
    IN personIDIN BIGINT,
    IN positionIDIN INT,
    IN iOrderIN INT
)
BEGIN
    START TRANSACTION;
    INSERT INTO rrze_hub_personPosition (personID, positionID, iOrder) VALUES (personIDIN, positionIDIN, iOrderIN)
    ON DUPLICATE KEY UPDATE iOrder = iOrderIN;
    COMMIT;
END@@

DELIMITER @@

CREATE OR REPLACE PROCEDURE setLectureType (
    IN sShortIN VARCHAR(10), 
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
    IN sShortIN VARCHAR(2), 
    IN sLongIN VARCHAR(255),
    OUT retID INT
)
BEGIN
    START TRANSACTION;
    INSERT INTO rrze_hub_language (sShort, sLong) VALUES (sShortIN, sLongIN)
    ON DUPLICATE KEY UPDATE sLong = sLongIN;
    COMMIT;
    SELECT ID INTO retID FROM rrze_hub_language WHERE sShort = sShortIN;
    IF retID <= 0 THEN
        ROLLBACK;
    END IF; 
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
    IN personIDIN BIGINT,
    IN locationIDIN BIGINT
)
BEGIN
    START TRANSACTION;
    INSERT INTO rrze_hub_personLocation (personID, locationID) VALUES (personIDIN, locationIDIN)
    ON DUPLICATE KEY UPDATE personID = personIDIN, locationID = locationIDIN;
    COMMIT;
    -- 2DO: bulk insert
END@@


CREATE OR REPLACE PROCEDURE setCourse (
    IN lectureIDIN BIGINT, 
    IN sCourseIDIN VARCHAR(255),
    IN sNameIN TEXT,
    IN sDescriptionIN VARCHAR(255),
    OUT retID INT
)
COMMENT 'return: rrze_hub_course.ID - Add/Update course'
BEGIN
    START TRANSACTION;
    INSERT INTO rrze_hub_course (lectureID, sCourseID, sName, sDescription) VALUES (lectureIDIN, sCourseIDIN, sNameIN, sDescriptionIN)
    ON DUPLICATE KEY UPDATE sCourseID = sCourseIDIN, sName = sNameIN, sDescription = sDescriptionIN;
    COMMIT;
    SELECT ID INTO retID FROM rrze_hub_course WHERE lectureID = lectureIDIN AND sCourseID = sCourseIDIN AND sName = sNameIN AND sDescription = sDescriptionIN;
    IF retID <= 0 THEN
        ROLLBACK;
    END IF; 
END@@


CREATE OR REPLACE PROCEDURE setPersonCourse (
    IN personIDIN BIGINT,
    IN courseIDIN BIGINT
)
BEGIN
    START TRANSACTION;
    INSERT INTO rrze_hub_personCourse (personID, courseID) VALUES (personIDIN, courseIDIN)
    ON DUPLICATE KEY UPDATE personID = personIDIN, courseID = courseIDIN;
    COMMIT;
    -- 2DO: bulk insert
END@@


CREATE OR REPLACE PROCEDURE setTerm (
    IN courseIDIN BIGINT,
    IN roomIDIN INT,
    IN sRepeatIN VARCHAR(255),
    IN sExcludeIN VARCHAR(255),
    IN tStartdateIN DATE,
    IN tEnddateIN DATE,
    IN tStarttimeIN TIME,
    IN tEndtimeIN TIME
)
COMMENT 'Add/Update term'
BEGIN
    START TRANSACTION;
    INSERT INTO rrze_hub_term (courseID, roomID, sRepeat, sExclude, tStartdate, tEnddate, tStarttime, tEndtime) VALUES (courseIDIN, roomIDIN, sRepeatIN, sExcludeIN, tStartdateIN, tEnddateIN, tStarttimeIN, tEndtimeIN)
    ON DUPLICATE KEY UPDATE sRepeat = sRepeatIN, sExclude = sExcludeIN, tStartdate = tStartdateIN, tEnddate = tEnddateIN, tStarttime = tStarttimeIN, tEndtime = tEndtimeIN;
    COMMIT;
END@@


CREATE OR REPLACE PROCEDURE setStud (
    IN lectureIDIN BIGINT,
    IN sRichtIN VARCHAR(255),
    IN sPflichtIN VARCHAR(255),
    IN iSemIN INT, 
    IN sCreditsIN VARCHAR(255)
)
COMMENT 'Add/Update stud'
BEGIN
    START TRANSACTION;
    INSERT INTO rrze_hub_stud (lectureID, sRicht, sPflicht, iSem, sCredits) VALUES (lectureIDIN, sRichtIN, sPflichtIN, iSemIN, sCreditsIN)
    ON DUPLICATE KEY UPDATE lectureID = lectureIDIN, sRicht = sRichtIN, sPflicht = sPflichtIN, iSem = iSemIN, sCredits = sCreditsIN;
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



DELIMITER @@

CREATE OR REPLACE PROCEDURE setLecture (
    IN univisIDIN INT,
    IN lecturetypeIDIN INT, 
    IN languageIDIN INT, 
    IN sNameIN VARCHAR(255),
    IN sEctsnameIN VARCHAR(255),
    IN sUrlIN VARCHAR(255),
    IN tStartdateIN DATE,
    IN tEnddateIN DATE,
    IN tStarttimeIN TIME,
    IN tEndtimeIN TIME,
    IN sCommentIN TEXT,
    IN sOrganizationalIN TEXT,
    IN iMaxturnoutIN INT,
    IN iSwsIN INT(2),
    IN bBeginnersIN BOOLEAN,
    IN bEarlystudyIN BOOLEAN,
    IN bGuestIN BOOLEAN,
    IN bEvaluationIN BOOLEAN,
    IN bCertificationIN BOOLEAN,
    IN bEctsIN BOOLEAN,
    IN sEctscreditsIN VARCHAR(255),
    IN sEctsliteratureIN TEXT,
    IN sEctssummaryIN TEXT,
    IN sEctsorganizationalIN TEXT,
    IN sKeywordsIN TEXT,
    IN sLiteratureIN TEXT,
    IN sSummaryIN TEXT,
    IN sKeyIN VARCHAR(255),
    IN sLectureIDIN VARCHAR(255), 
    OUT retID BIGINT
)
COMMENT 'return: rrze_hub_lecture.ID - Add/Update lecture'
BEGIN 
    START TRANSACTION;
    INSERT INTO rrze_hub_lecture (univisID, lecturetypeID, languageID, sName, sEctsname, sUrl, tStartdate, tEnddate, tStarttime, tEndtime, sComment, sOrganizational, iMaxturnout, iSws, bBeginners, bEarlystudy, bGuest, bEvaluation, bCertification, bEcts, sEctscredits, sEctsliterature, sEctssummary, sEctsorganizational, sKeywords, sLiterature, sSummary, sKey, sLectureID) VALUES (univisIDIN, lecturetypeIDIN, languageIDIN, sNameIN, sEctsnameIN, sUrlIN, tStartdateIN, tEnddateIN, tStarttimeIN, tEndtimeIN, sCommentIN, sOrganizationalIN, iMaxturnoutIN, iSwsIN, bBeginnersIN, bEarlystudyIN, bGuestIN, bEvaluationIN, bCertificationIN, bEctsIN, sEctscreditsIN, sEctsliteratureIN, sEctssummaryIN, sEctsorganizationalIN, sKeywordsIN, sLiteratureIN, sSummaryIN, sKeyIN, sLectureIDIN)
    ON DUPLICATE KEY 
    UPDATE univisID = univisIDIN, lecturetypeID = lecturetypeIDIN, languageID = languageIDIN, sName = sNameIN, sEctsname = sEctsnameIN, sUrl = sUrlIN, tStartdate = tStartdateIN, tEnddate = tEnddateIN, tStarttime = tStarttimeIN, tEndtime = tEndtimeIN, sComment = sCommentIN, sOrganizational = sOrganizationalIN, iMaxturnout = iMaxturnoutIN, iSws = iSwsIN, bBeginners = bBeginnersIN, bEarlystudy = bEarlystudyIN, bGuest = bGuestIN, bEvaluation = bEvaluationIN, bCertification = bCertificationIN, bEcts = bEctsIN, sEctscredits = sEctscreditsIN, sEctsliterature = sEctsliteratureIN, sEctssummary = sEctssummaryIN, sEctsorganizational = sEctsorganizationalIN, sKeywords = sKeywordsIN, sLiterature = sLiteratureIN, sSummary = sSummaryIN, sKey = sKeyIN, sLectureID = sLectureIDIN;
    COMMIT;
    SELECT ID INTO retID FROM rrze_hub_lecture WHERE univisID = univisIDIN AND lecturetypeID = lecturetypeIDIN AND languageID = languageIDIN AND sName = sNameIN AND sEctsname = sEctsnameIN AND sUrl = sUrlIN AND tStartdate = tStartdateIN AND tEnddate = tEnddateIN AND tStarttime = tStarttimeIN AND tEndtime = tEndtimeIN AND sComment = sCommentIN AND sOrganizational = sOrganizationalIN AND iMaxturnout = iMaxturnoutIN AND iSws = iSwsIN AND bBeginners = bBeginnersIN AND bEarlystudy = bEarlystudyIN AND bGuest = bGuestIN AND bEvaluation = bEvaluationIN AND bCertification = bCertificationIN AND bEcts = bEctsIN AND sEctscredits = sEctscreditsIN AND sEctsliterature = sEctsliteratureIN AND sEctssummary = sEctssummaryIN AND sEctsorganizational = sEctsorganizationalIN AND sKeywords = sKeywordsIN AND sLiterature = sLiteratureIN AND sSummary = sSummaryIN AND sKey = sKeyIN AND sLectureID = sLectureIDIN;
    IF retID <= 0 THEN
        ROLLBACK;
    END IF; 
END@@


CREATE OR REPLACE PROCEDURE setPersonLecture (
    IN lectureIDIN BIGINT,
    IN personIDIN BIGINT
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


-- 2DO: departmentID -> rrze_hub_personDepartment
CREATE OR REPLACE PROCEDURE deletePerson (
    IN departmentIDIN INT,
    IN sIDIN TEXT,
    OUT iDel INT
)
COMMENT 'deletes persons'
BEGIN 
    IF sIDIN = '' THEN SET sIDIN = '0'; END IF;
    SET @sql = CONCAT("DELETE p.* FROM rrze_hub_person p WHERE p.ID NOT IN (", sIDIN, ") AND p.ID IN (SELECT pd.personID FROM rrze_hub_department d, rrze_hub_personDepartment pd WHERE pd.departmentID = d.ID AND pd.departmentID = ", departmentIDIN, ")");
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    SELECT ROW_COUNT() INTO iDel;
END@@


DELIMITER ;






-- views


CREATE OR REPLACE VIEW getPerson AS 
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




CREATE OR REPLACE VIEW getLecture AS 
    SELECT 
        u.sUnivisID AS univisID,
        lec.ID AS lectureID,
        lec.sLectureID AS lecture_univisID, 
        lec.sName AS lecture_title,
        lec.sEctsname AS ects_name,
        lang.sLong AS leclanguage,
        lec.sKey AS 'key',
        lectype.sShort AS lecture_type_short,
        lectype.sLong AS lecture_type,
        lec.sUrl AS url_description,
        lec.sComment AS comment,
        lec.sOrganizational AS organizational,
        lec.iMaxturnout AS maxturnout,
        lec.sSummary AS summary,
        lec.tStartdate AS lecture_startdate,
        lec.tEnddate AS lecture_enddate,
        DATE_FORMAT(lec.tStarttime, "%H:%i") AS lecture_starttime,
        DATE_FORMAT(lec.tEndtime, "%H:%i") AS lecture_endtime,
        IF(lec.iSws, CONCAT(lec.iSws, " SWS"), NULL) AS sws,
        IF(lec.bEcts, "ECTS-Studium", NULL) AS ects,
        lec.sEctscredits AS ects_cred,
        IF(lec.bBeginners, "Für Anfänger geeignet", NULL) AS beginners,
        IF(lec.bEarlystudy, "Frühstudium", NULL) AS earlystudy,
        IF(lec.bGuest, "Für Gasthörer zugelassen", NULL) AS guest,
        IF(lec.bEvaluation, "Evaluation", NULL) AS evaluation,
        IF(lec.bCertification, "Schein", NULL) AS certification,
        co.courseID AS courseID,
        co.termID AS termID,
        co.sName AS coursename,
        co.sDescription AS time_description,
        co.sRepeat AS 'repeat',
        co.sExclude AS exclude,
        co.sShort AS room,
        co.sNorth AS north,
        co.sEast AS east,
        co.title AS course_person_title,
        co.firstname AS course_person_firstname,
        co.lastname AS course_person_lastname,
        co.person_id AS course_person_univisID,
        co.tStartdate AS term_startdate,
        co.tEnddate AS term_enddate,
        DATE_FORMAT(co.tStarttime, "%H:%i") AS term_starttime,
        DATE_FORMAT(co.tEndtime, "%H:%i") AS term_endtime,
        p.title AS lecture_person_title,
        p.firstname AS lecture_person_firstname,
        p.lastname AS lecture_person_lastname,
        p.person_id AS lecture_person_univisID,
        stud.lectureID AS stud_lectureID,
        stud.ID AS studID,
        stud.sRicht AS richt,
        stud.sPflicht AS pflicht,
        stud.iSem AS sem,
        stud.sCredits AS credits
    FROM 
        rrze_hub_univis u,
        rrze_hub_lecturetype lectype,
        rrze_hub_language lang,
        rrze_hub_lecture lec
    LEFT JOIN 
        (SELECT
            c.ID AS courseID, 
            c.sName,
            c.lectureID,
            c.sDescription,
            t.ID AS termID,
            t.tStartdate,
            t.tEnddate,
            t.tStarttime,
            t.tEndtime,
            t.sRepeat,
            t.sExclude,
            r.sShort,
            r.sNorth,
            r.sEast,
            tp.person_id,
            tp.title,
            tp.firstname,
            tp.lastname,
            tp.ID
        FROM 
            rrze_hub_room r,
            rrze_hub_term t,
            rrze_hub_course c
        LEFT JOIN 
            (SELECT 
                gp.title,
                gp.firstname,
                gp.lastname,
                gp.ID,
                gp.person_id,
                pc.courseID
            FROM
                getPerson gp,
                rrze_hub_personCourse pc
            WHERE 
                gp.ID = pc.personID    
            ) tp
        ON c.ID = tp.courseID
        WHERE
            c.ID = t.courseID AND 
            t.roomID = r.ID
        ) co
    ON lec.ID = co.lectureID
    LEFT JOIN 
        (SELECT 
            gp.title,
            gp.firstname,
            gp.lastname,
            gp.ID,
            gp.person_id,
            pl.lectureID
        FROM
            getPerson gp,
            rrze_hub_personLecture pl
        WHERE 
            gp.ID = pl.personID    
        ) p
    ON lec.ID = p.lectureID
    LEFT JOIN
        (SELECT 
            ID,
            lectureID,
            sRicht,
            sPflicht,
            iSem,
            sCredits
        FROM
            rrze_hub_stud
        )stud
    ON lec.ID = stud.lectureID
    WHERE 
        lec.univisID = u.ID AND
        lec.lecturetypeID = lectype.ID AND
        lec.languageID = lang.ID;


