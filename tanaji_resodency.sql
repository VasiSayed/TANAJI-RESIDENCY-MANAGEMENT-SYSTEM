-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 22, 2025 at 01:33 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `tanaji_resodency`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `doc` ()   begin
select * from document;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_reserv_Id` (IN `id` INT)   begin
declare co int default 0 ;
select count(*) into co from reservation_all_info where re_id=id or guest_id=id or room_no=id;
if co>0 then
select * from reservation_all_info where re_id=id or guest_id=id or room_no=id ;
else 
signal sqlstate "45000"
set message_text ="NAMASHKAR ! Check Your Entered Id , No Record Found From Your Entered ID";
end if ;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `guest` ()   begin 
select * from guest;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ins_guest` (IN `naam` VARCHAR(50), IN `DO` DATE, IN `Adde` VARCHAR(50), IN `pin` INT(7), IN `no` BIGINT(10), IN `Em` VARCHAR(50), IN `document_type` INT(1), IN `Document` BIGINT)   begin
declare count_i int;
select count(*) into count_i from guest where Document_no=Document;
if count_i > 0 then
signal sqlstate "45000"
set message_text="NAMASKAR ! Document Already in Used By Other Guest Please Give Your document Id";
else
insert into guest
(Name,DOB,Address,PINCODE,Contact_no,Email,document_type_id,Document_no)
values
(naam,DO,Adde,pin,no,Em,document_type,Document);
end if ;
End$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ins_reserv_with_trans_no` (IN `id` INT, IN `G_id` INT, IN `Ro_No` INT, IN `in_date` DATE, IN `out_date` DATE, IN `trans_no` BIGINT, IN `st` ENUM("Failed","Successful"))   begin
declare t_no int;
declare am int;
 select count(*) into t_no from transaction where Transaction_No = trans_no;
 if t_no >0 then
  signal sqlstate "45000"
  SET message_text = " NAMASKAR ! Transaction Id Already Exists Create New Transaction ";
  else
          insert into reservation(re_id,Guest_id ,room_no,check_in_date,check_out_date,Payment_Status) values(id,G_id,ro_no,in_date,out_date,st);   
select amount into am from reservation where re_id = id;
insert into transaction(re_id,Transaction_No,Payment_Status,payment_date,amount)values(id,trans_no, st,out_date,am);
end if ;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `remove_staff` (IN `id` INT)   begin
delete from staff where staff_id=id;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `reserv` ()   begin
select * from reservation;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `re_all_info` ()   begin
select * from reservation_all_info ;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `room` ()   begin
select * from rooms;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ro_ty` ()   begin
select * from room_type;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `staff` ()   begin
select * from staff;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `staff_details_by_id` (IN `id` INT)   begin
declare count_i int default 0;
select count(work_id) into count_i from staff_scedule where work_id =id ;
if count_i  >  0 then
select work_id,staff_id,name,shift,start_time,end_time,role,salary from staff_scedule join staff using(staff_id)where work_id=id;
else
signal sqlstate "45000"
set Message_text = "Namaskar ! Your Entered ID Is Invalid ";
END IF;
End$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `staff_sced` ()   begin
select * from staff_scedule;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `trans` ()   begin
select * from transaction order by re_id ;
end$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `AVG_AMOUNT_YEAR` (`YE` INT) RETURNS INT(11) DETERMINISTIC BEGIN
DECLARE YR INT;
declare count_i int;
select count(*) into count_i FROM RESERVATION WHERE YEAR(CHECK_IN_DATE)= ye;
if count_i = 0 then
signal sqlstate "45000"
set message_text="NAMASKAR ! OOPS NO RECORD FOUND FOUND ON YOUR ENTERED YEAR";
ELSE
SELECT ROUND(AVG(AMOUNT)) into yr FROM RESERVATION WHERE YEAR(CHECK_IN_DATE)= ye;
END IF ;
return yr ;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `SUM_AMOUNT_YEAR` (`YO` INT) RETURNS INT(11) DETERMINISTIC BEGIN
DECLARE YR INT;
declare count_i int;
select count(*) into count_i FROM RESERVATION WHERE YEAR(CHECK_IN_DATE)= yO;
if count_i = 0 then
signal sqlstate "45000"
set message_text="NAMASKAR ! OOPS NO RECORD FOUND FOUND ON YOUR ENTERED YEAR";
ELSE
SELECT ROUND(SUM(AMOUNT)) into yr FROM RESERVATION WHERE YEAR(CHECK_IN_DATE)= yO;
END IF ;
return yr ;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `total_resrv_monthly` (`m` INT, `yr` INT) RETURNS INT(11) DETERMINISTIC begin
declare monthh int default 0;
declare yearr int default 0;
declare count_i int default 0;
declare total int default 0;
select m into monthh ;
select yr into yearr;
select count(*) into count_i from reservation where year(check_in_date)=yearr and month(check_in_date)=monthh;
if count_i > 0 then
select count(*) as Total_Reservation into total from reservation where year(check_in_date)=yearr and month(check_in_date)=monthh;
else
signal sqlstate "45000"
set message_text = "Namaskar ! No Reservation Found on Your Entered Month In Year";
end if ;
return total;
end$$

CREATE DEFINER=`root`@`localhost` FUNCTION `yearly_reservation_count` (`yr` INT) RETURNS INT(11) DETERMINISTIC begin
declare year int default 0 ;
declare co int;
select count(*) into co from reservation where year(check_in_date) = yr;

if co>0 then
select count(*) into year from reservation where year(check_in_date) = yr;

else 
signal sqlstate "45000"
set message_text ="NAMASKAR ! RECORD NOT FOUND FROM THIS YEAR";
END IF ;
RETURN YEAR;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `document`
--

CREATE TABLE `document` (
  `document_type_id` int(11) NOT NULL,
  `Document_Name` varchar(20) DEFAULT NULL,
  `ISSUED_BY_GOVERNMENT` varchar(30) DEFAULT 'INDIA'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `document`
--

INSERT INTO `document` (`document_type_id`, `Document_Name`, `ISSUED_BY_GOVERNMENT`) VALUES
(1, 'ADHAAR', 'INDIA'),
(2, 'PAN CARD', 'INDIA'),
(3, 'VOTER_ID', 'INDIA'),
(4, 'PASSPORT', 'INDIA'),
(5, 'PASSPORT CARD', 'USA'),
(6, 'IDENTITY CARD', 'NYC'),
(7, 'DL', 'KANSAS'),
(8, 'DL', 'MISSOURI'),
(9, 'DL', 'IOWA'),
(10, 'DL', 'WASHINGTON');

-- --------------------------------------------------------

--
-- Table structure for table `ex_staff`
--

CREATE TABLE `ex_staff` (
  `Name` varchar(30) DEFAULT NULL,
  `Contact_no` int(10) DEFAULT NULL,
  `CITY` varchar(30) DEFAULT NULL,
  `Pincode` int(6) DEFAULT NULL,
  `last_day` date DEFAULT NULL,
  `Adhar_No` bigint(12) DEFAULT NULL,
  `refference_by` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ex_staff`
--

INSERT INTO `ex_staff` (`Name`, `Contact_no`, `CITY`, `Pincode`, `last_day`, `Adhar_No`, `refference_by`) VALUES
('Aftab', 2147483647, 'balika nagar shahu n', 400019, '2024-09-16', 234156780943, 'owner'),
('PIYUSH', 2147483647, 'PRATIKSHA NAGER SOIN', 400029, '2024-09-16', 787635670923, 'OWNER'),
('Ramesh', 2147483647, 'Dombilvali East Manp', 400087, '2024-09-18', 876523450981, 'KRYSTAL AG');

-- --------------------------------------------------------

--
-- Table structure for table `guest`
--

CREATE TABLE `guest` (
  `Guest_id` int(11) NOT NULL,
  `Name` varchar(30) NOT NULL,
  `DOB` date NOT NULL,
  `Address` varchar(50) DEFAULT NULL,
  `PINCODE` int(6) DEFAULT NULL,
  `Contact_no` bigint(20) DEFAULT NULL,
  `Email` varchar(40) DEFAULT NULL,
  `document_type_id` int(11) DEFAULT NULL,
  `Document_no` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `guest`
--

INSERT INTO `guest` (`Guest_id`, `Name`, `DOB`, `Address`, `PINCODE`, `Contact_no`, `Email`, `document_type_id`, `Document_no`) VALUES
(101, 'MOMIN SAYED', '1976-07-10', 'MAHIM EAST', 400016, 7666519002, 'Smhussain7214@gmail.com', 1, 746709874567),
(102, 'Mehdi Sayed', '1982-10-10', 'MAHIM EAST', 400016, 7400118109, 'mehdibegum.com', 1, 986734560192),
(103, 'raziya Ali', '0000-00-00', 'hyderbad Attpur', 500016, 9873456029, 'raziyasayed09.com', 1, 945634560192),
(104, 'Sara ', '2004-10-12', 'hyderbad Attpur', 500019, 9834456029, 'karrar@ali', 1, 678650987223),
(105, 'Shreya Dhuri ', '2004-07-09', 'diva east', 400065, 7510987609, 'shreyadhuri@80', 1, 902987223),
(106, 'Vasi Sayed', '2002-12-25', 'mahim east', 400016, 8104771784, 'vaisayed09421@gmail.com', 2, 987623450987),
(107, 'Atharva Raut', '2003-02-09', 'kopairkherne', 400032, 873628909, 'athaevaraut@gmail.com', 1, 367823450987),
(108, 'jayesh bakkam', '2003-07-19', 'diva', 500012, 873628009, 'bakkam@gmail.com', 2, 0),
(110, 'Rushikesh Golapkar', '1998-04-04', 'Dadar worli Koliwada', 400054, 9231782312, 'rusharika389@gmail.com', 2, 8764636889),
(111, 'Piyush Nirbhavne', '2003-08-29', 'Sion GTB Nagar', 400059, 8104477189, 'piyushnirbhavne6@gmail.com', 1, 778650582233),
(112, 'Shubham Kokane', '2002-02-12', 'karjat', 400019, 8765234501, 'shubhamkokane21@gmail.com', 1, 980950582233);

--
-- Triggers `guest`
--
DELIMITER $$
CREATE TRIGGER `guest_email` BEFORE INSERT ON `guest` FOR EACH ROW begin
if new.email not like "%@gmail.com" then 
set new.email = concat(new.email,"@gmail.com");
end if;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `reservation`
--

CREATE TABLE `reservation` (
  `re_id` int(11) NOT NULL,
  `Guest_id` int(11) NOT NULL,
  `Room_No` int(11) NOT NULL,
  `check_in_date` date NOT NULL,
  `Check_out_date` date NOT NULL,
  `Payment_Status` enum('Failed','Successful') DEFAULT NULL,
  `Amount` decimal(10,3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reservation`
--

INSERT INTO `reservation` (`re_id`, `Guest_id`, `Room_No`, `check_in_date`, `Check_out_date`, `Payment_Status`, `Amount`) VALUES
(1100, 101, 15, '2024-07-08', '2024-07-09', 'Successful', 3000.000),
(1101, 102, 13, '2023-10-10', '2023-10-11', 'Successful', 4500.000),
(1103, 106, 17, '2023-10-03', '2023-10-10', 'Successful', 14000.000),
(1104, 103, 11, '2019-04-10', '2019-04-15', 'Successful', 10000.000),
(1105, 105, 19, '2024-12-24', '2024-12-26', 'Successful', 9000.000),
(1106, 105, 5, '2024-07-08', '2024-07-09', 'Successful', 3000.000),
(1107, 108, 11, '2024-03-21', '2024-03-22', 'Successful', 2000.000),
(1108, 107, 11, '2022-07-23', '2022-07-27', 'Successful', 8000.000),
(1109, 106, 9, '2021-01-13', '2021-02-13', 'Successful', 46500.000),
(1110, 103, 10, '2020-02-14', '2020-02-16', 'Successful', 3000.000),
(1111, 107, 9, '2021-04-29', '2021-04-30', 'Successful', 1500.000),
(1112, 107, 17, '2024-12-19', '2024-12-20', 'Successful', 2000.000),
(1113, 102, 13, '2024-09-19', '2024-09-20', 'Successful', 4500.000),
(1114, 102, 15, '2019-03-14', '2019-03-15', 'Successful', 3000.000),
(1115, 110, 5, '2023-07-15', '2023-07-18', 'Successful', 9000.000),
(1116, 104, 3, '2022-07-15', '2022-07-18', 'Successful', 9000.000),
(1117, 105, 12, '2023-07-09', '2023-07-11', 'Successful', 6000.000),
(1118, 106, 11, '2021-07-09', '2021-07-11', 'Successful', 4000.000),
(1119, 105, 11, '2024-09-21', '2024-09-23', 'Successful', 4000.000),
(1120, 105, 11, '2024-03-02', '2024-03-05', 'Successful', 6000.000);

--
-- Triggers `reservation`
--
DELIMITER $$
CREATE TRIGGER `Check_guest_id` BEFORE INSERT ON `reservation` FOR EACH ROW begin

declare count_i int;

select count(*) into count_i from Guest where guest_id = new.guest_id;

if count_i = 0 then
signal sqlstate "45000"
SET Message_Text = "NAMASKAR ! Unidentified Guest Id CHeck Your Entered ID";
end if ;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Check_reservation_id` BEFORE INSERT ON `reservation` FOR EACH ROW begin

declare count_i int;
declare mx int;
declare msg varchar(255);

select count(*) into count_i from reservation where re_id= new.re_id;

select max(re_id)+1 into mx from reservation;

 SET msg = concat('Namaskar! Your Entered Reservation ID Already Exists. Please Enter a New One such as ',mx);

if count_i > 0 then
signal sqlstate "45000"
SET Message_Text = msg;
end if ;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `auto_amountBYdate` BEFORE INSERT ON `reservation` FOR EACH ROW begin
declare room_price decimal(10,2);
declare stay_duration int;

select price_per_night into room_price
from 
rooms join
room_type using(Room_Type_id) 
where room_no= new.room_no;

set 
stay_duration = datediff(new.Check_out_date,new.check_in_date);

set new.amount = stay_duration*room_price;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `date_time_error` BEFORE INSERT ON `reservation` FOR EACH ROW begin
declare check_av int default 0;

select count(*) into check_av from reservation where check_in_date = new.check_in_date and room_no = new.room_no;

if check_av >0 then
signal sqlstate "45000"
set message_text = "Namashkar ! Room Occupied Your reservation Has Been Cancelled";
end if ;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `dlt_reservation` BEFORE INSERT ON `reservation` FOR EACH ROW begin
if new.Payment_Status = "failed" then
signal sqlstate "45000"
set message_text = " Namaskar! Your Transaction Failled !  Your Reservation Has Been Cancelled " ;
end if;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `room_ready` BEFORE INSERT ON `reservation` FOR EACH ROW begin
     declare st varchar(30);
     select Status into st from rooms where Room_No=new.Room_No;
     if st !="READY"
     then
     signal sqlstate "45000"
     set Message_text = "NAMASKAR ! Sorry For Inconnvenince Room is NOT READY";
     end if ;
     end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `reservation_all_info`
-- (See below for the actual view)
--
CREATE TABLE `reservation_all_info` (
`re_id` int(11)
,`Guest_id` int(11)
,`Guest_Name` varchar(30)
,`Room_Type` varchar(20)
,`Room_No` int(11)
,`check_in_date` date
,`Check_out_date` date
,`Stay_duration` int(7)
,`Amount` decimal(10,3)
);

-- --------------------------------------------------------

--
-- Table structure for table `rooms`
--

CREATE TABLE `rooms` (
  `Room_No` int(11) NOT NULL,
  `Room_type_id` int(11) DEFAULT NULL,
  `Capacity` int(11) DEFAULT NULL,
  `Status` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rooms`
--

INSERT INTO `rooms` (`Room_No`, `Room_type_id`, `Capacity`, `Status`) VALUES
(1, 1, 3, 'READY'),
(2, 1, 3, 'READY'),
(3, 2, 3, 'READY'),
(4, 2, 3, 'NOT-READY'),
(5, 2, 3, 'READY'),
(6, 2, 3, 'NOT-READY'),
(9, 4, 4, 'READY'),
(10, 4, 4, 'READY'),
(11, 1, 2, 'READY'),
(12, 2, 4, 'READY'),
(13, 3, 3, 'READY'),
(14, 4, 3, 'NOT-READY'),
(15, 2, 3, 'READY'),
(16, 3, 2, 'NOT-READY'),
(17, 1, 2, 'READY'),
(18, 1, 3, 'NOT-READY'),
(19, 3, 3, 'READY'),
(20, 3, 3, 'READY'),
(21, 3, 3, 'READY');

-- --------------------------------------------------------

--
-- Table structure for table `room_type`
--

CREATE TABLE `room_type` (
  `Room_type_id` int(11) NOT NULL,
  `Room_Type` varchar(20) DEFAULT NULL,
  `price_per_night` decimal(8,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `room_type`
--

INSERT INTO `room_type` (`Room_type_id`, `Room_Type`, `price_per_night`) VALUES
(1, 'Standard', 2000.00),
(2, 'Deluxe', 3000.00),
(3, 'Super_deluxe', 4500.00),
(4, 'budget', 1500.00);

-- --------------------------------------------------------

--
-- Table structure for table `staff`
--

CREATE TABLE `staff` (
  `Staff_Id` int(11) NOT NULL,
  `Name` varchar(30) NOT NULL,
  `Contact_no` bigint(10) DEFAULT NULL,
  `DOB` date NOT NULL,
  `CITY` varchar(20) DEFAULT NULL,
  `Pincode` int(11) DEFAULT NULL,
  `Adhar_No` bigint(20) NOT NULL,
  `refference_by` varchar(10) DEFAULT 'None'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `staff`
--

INSERT INTO `staff` (`Staff_Id`, `Name`, `Contact_no`, `DOB`, `CITY`, `Pincode`, `Adhar_No`, `refference_by`) VALUES
(1, 'DILIP JOGIESH', 8345266532, '1980-01-13', '125 ROOM NO JAIPUR', 160047, 345665437890, 'NATTEST AN'),
(2, 'SANJAY SEKAT', 7645266532, '1990-01-13', '12 JASLOK DOMBIVALI', 400612, 432166543789, 'NATTEST AN'),
(3, 'OJAVAS', 9424526653, '1997-01-13', 'LASHKKAR CITY MADHYA', 474006, 972166543789, 'NATTEST AN'),
(4, 'ODHESH', 6435266532, '1992-01-13', ' AZAMGARH UTTARPRADE', 472006, 239866437890, 'NATTEST AN'),
(5, 'RAM', 9087266532, '0000-00-00', ' DONDIA UTTARPRADESH', 472096, 429875437890, 'KRYSTAL AG'),
(7, 'VINESH', 8547266532, '1999-05-04', 'UP', 472096, 323775437890, 'KRYSTAL AG'),
(8, 'IYER', 7870206532, '1991-08-15', 'TAMIL NAIDU', 342237, 867575437899, 'MUMBAI_RES');

--
-- Triggers `staff`
--
DELIMITER $$
CREATE TRIGGER `ex_staff` BEFORE DELETE ON `staff` FOR EACH ROW begin
    delete from staff_scedule where staff_id=old.staff_id;
     insert into ex_staff values(old.name,old.contact_no,old.city,old.pincode,curdate(),old.adhar_no,old.refference_by);
    end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `staff_scedule`
--

CREATE TABLE `staff_scedule` (
  `work_id` int(11) NOT NULL,
  `staff_id` int(11) NOT NULL,
  `shift` varchar(20) DEFAULT 'MORNING',
  `Start_Time` varchar(10) DEFAULT NULL,
  `end_time` varchar(10) DEFAULT NULL,
  `Role` varchar(255) DEFAULT NULL,
  `Salary` decimal(8,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `staff_scedule`
--

INSERT INTO `staff_scedule` (`work_id`, `staff_id`, `shift`, `Start_Time`, `end_time`, `Role`, `Salary`) VALUES
(1, 1, 'MORNING', '9AM', '7PM', 'HELPER', 12000.00),
(2, 2, 'MORNING', '9AM', '7PM', 'CLEANER', 10000.00),
(3, 3, 'FULL-TIME', ' -- ', ' -- ', 'CLEANER', 10000.00),
(4, 4, 'FULL-TIME', ' 10PM ', ' 8AM ', 'MANAGER', 25000.00),
(5, 5, 'NIGHT-SHIFT', ' 10PM ', '8AM', 'WATCHMEN', 25000.00),
(7, 7, 'MORNING', ' 9AM ', '9PM', 'WATCHMEN', 18000.00),
(8, 8, 'MORNING', ' 9AM ', '8PM', 'BATHROOM_CLEANER', 9000.00);

-- --------------------------------------------------------

--
-- Table structure for table `transaction`
--

CREATE TABLE `transaction` (
  `re_id` int(11) DEFAULT NULL,
  `Transaction_No` bigint(20) DEFAULT NULL,
  `Payment_Status` enum('Failed','Successful') DEFAULT NULL,
  `payment_date` date DEFAULT NULL,
  `amount` decimal(10,3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaction`
--

INSERT INTO `transaction` (`re_id`, `Transaction_No`, `Payment_Status`, `payment_date`, `amount`) VALUES
(1100, 10010191, 'Successful', '2024-07-09', 3000.000),
(1101, 10013479, 'Successful', '2023-10-11', 4500.000),
(1103, 10010925, 'Successful', '2023-10-10', 14000.000),
(1104, 10010620, 'Successful', '2019-04-15', 10000.000),
(1105, 10012509, 'Successful', '2024-12-26', 9000.000),
(1106, 10017291, 'Successful', '2024-07-09', 3000.000),
(1107, 10013459, 'Successful', '2024-03-22', 2000.000),
(1108, 10018337, 'Successful', '2022-07-27', 8000.000),
(1109, 10029461, 'Successful', '2021-02-13', 46500.000),
(1111, 10038932, 'Successful', '2021-04-30', 1500.000),
(1114, 10019510, 'Successful', '2019-03-15', 3000.000),
(1110, 10015801, 'Successful', '2020-02-16', 3000.000),
(1112, 10015022, 'Successful', '2024-12-20', 2000.000),
(1113, 10015920, 'Successful', '2024-09-20', 4500.000),
(1115, 10014899, 'Successful', '2023-07-18', 9000.000),
(1116, 10010003, 'Successful', '2022-07-18', 9000.000),
(1117, 12345678, 'Successful', '2023-07-11', 6000.000),
(1118, 10000000, 'Successful', '2021-07-11', 4000.000),
(1119, 10018456, 'Successful', '2024-09-23', 4000.000),
(1120, 10010629, 'Successful', '2024-03-05', 6000.000);

--
-- Triggers `transaction`
--
DELIMITER $$
CREATE TRIGGER `dlt_failed_trasns` AFTER INSERT ON `transaction` FOR EACH ROW begin
              declare status enum("Failed","Successful");
              select Payment_Status into status from reservation where re_id=new.re_id;
              if Status = "failed" then
              delete from reservation where re_id=new.re_id;
              end if;
              end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `dlt_reservation_and_transaction` AFTER DELETE ON `transaction` FOR EACH ROW begin
delete from reservation where re_id=old.re_id;

end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure for view `reservation_all_info`
--
DROP TABLE IF EXISTS `reservation_all_info`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `reservation_all_info`  AS SELECT `reservation`.`re_id` AS `re_id`, `reservation`.`Guest_id` AS `Guest_id`, `guest`.`Name` AS `Guest_Name`, `room_type`.`Room_Type` AS `Room_Type`, `reservation`.`Room_No` AS `Room_No`, `reservation`.`check_in_date` AS `check_in_date`, `reservation`.`Check_out_date` AS `Check_out_date`, to_days(`reservation`.`Check_out_date`) - to_days(`reservation`.`check_in_date`) AS `Stay_duration`, `reservation`.`Amount` AS `Amount` FROM ((((`reservation` join `guest` on(`reservation`.`Guest_id` = `guest`.`Guest_id`)) join `transaction` on(`reservation`.`re_id` = `transaction`.`re_id` and `reservation`.`Payment_Status` = `transaction`.`Payment_Status` and `reservation`.`Amount` = `transaction`.`amount`)) join `rooms` on(`reservation`.`Room_No` = `rooms`.`Room_No`)) join `room_type` on(`rooms`.`Room_type_id` = `room_type`.`Room_type_id`)) ORDER BY `reservation`.`re_id` ASC ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `document`
--
ALTER TABLE `document`
  ADD PRIMARY KEY (`document_type_id`);

--
-- Indexes for table `ex_staff`
--
ALTER TABLE `ex_staff`
  ADD UNIQUE KEY `Adhar_No` (`Adhar_No`);

--
-- Indexes for table `guest`
--
ALTER TABLE `guest`
  ADD PRIMARY KEY (`Guest_id`),
  ADD UNIQUE KEY `Document_no` (`Document_no`),
  ADD KEY `document_type_id_IN_guest` (`document_type_id`);

--
-- Indexes for table `reservation`
--
ALTER TABLE `reservation`
  ADD PRIMARY KEY (`re_id`),
  ADD UNIQUE KEY `for date_room` (`Room_No`,`check_in_date`),
  ADD KEY `guest_id_reservation` (`Guest_id`);

--
-- Indexes for table `rooms`
--
ALTER TABLE `rooms`
  ADD PRIMARY KEY (`Room_No`),
  ADD KEY `Room_type_id_FROM_ROOM_TYPE` (`Room_type_id`);

--
-- Indexes for table `room_type`
--
ALTER TABLE `room_type`
  ADD PRIMARY KEY (`Room_type_id`);

--
-- Indexes for table `staff`
--
ALTER TABLE `staff`
  ADD PRIMARY KEY (`Staff_Id`),
  ADD UNIQUE KEY `Adhar_No` (`Adhar_No`);

--
-- Indexes for table `staff_scedule`
--
ALTER TABLE `staff_scedule`
  ADD PRIMARY KEY (`work_id`),
  ADD UNIQUE KEY `staff_id` (`staff_id`);

--
-- Indexes for table `transaction`
--
ALTER TABLE `transaction`
  ADD UNIQUE KEY `Transaction_No` (`Transaction_No`),
  ADD UNIQUE KEY `Transaction_No_2` (`Transaction_No`),
  ADD UNIQUE KEY `re_id` (`re_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `document`
--
ALTER TABLE `document`
  MODIFY `document_type_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `guest`
--
ALTER TABLE `guest`
  MODIFY `Guest_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=113;

--
-- AUTO_INCREMENT for table `reservation`
--
ALTER TABLE `reservation`
  MODIFY `re_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1121;

--
-- AUTO_INCREMENT for table `rooms`
--
ALTER TABLE `rooms`
  MODIFY `Room_No` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `room_type`
--
ALTER TABLE `room_type`
  MODIFY `Room_type_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `staff`
--
ALTER TABLE `staff`
  MODIFY `Staff_Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `staff_scedule`
--
ALTER TABLE `staff_scedule`
  MODIFY `work_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `guest`
--
ALTER TABLE `guest`
  ADD CONSTRAINT `document_type_id_IN_guest` FOREIGN KEY (`document_type_id`) REFERENCES `document` (`document_type_id`);

--
-- Constraints for table `reservation`
--
ALTER TABLE `reservation`
  ADD CONSTRAINT `guest_id_reservation` FOREIGN KEY (`Guest_id`) REFERENCES `guest` (`Guest_id`),
  ADD CONSTRAINT `reservation_ibfk_1` FOREIGN KEY (`Room_No`) REFERENCES `rooms` (`Room_No`);

--
-- Constraints for table `rooms`
--
ALTER TABLE `rooms`
  ADD CONSTRAINT `Room_type_id_FROM_ROOM_TYPE` FOREIGN KEY (`Room_type_id`) REFERENCES `room_type` (`Room_type_id`);

--
-- Constraints for table `staff_scedule`
--
ALTER TABLE `staff_scedule`
  ADD CONSTRAINT `staff_scedule_ibfk_1` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`Staff_Id`);

--
-- Constraints for table `transaction`
--
ALTER TABLE `transaction`
  ADD CONSTRAINT `transaction_ibfk_1` FOREIGN KEY (`re_id`) REFERENCES `reservation` (`re_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
