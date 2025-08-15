USE khalil_library;

DELIMITER //
CREATE PROCEDURE GetIssuedBooksByMember(IN memberName VARCHAR(100))
BEGIN
    SELECT 
        b.title,
        i.issue_date,
        i.return_date
    FROM IssuedBook i
    JOIN Book b ON i.book_id = b.book_id
    JOIN Member m ON i.member_id = m.member_id
    WHERE m.name = memberName;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE CountBooksInCategory(IN categoryName VARCHAR(100), OUT totalBooks INT)
BEGIN
    SELECT COUNT(*) INTO totalBooks
    FROM Book b
    JOIN Category c ON b.category_id = c.category_id
    WHERE c.name = categoryName;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION CalculateFine(issueId INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE fine DECIMAL(10,2);
    DECLARE daysLate INT;

    SELECT DATEDIFF(CURDATE(), return_date) INTO daysLate
    FROM IssuedBook
    WHERE issue_id = issueId;

    IF daysLate > 0 THEN
        SET fine = daysLate * 5; -- Rs.5 per late day
    ELSE
        SET fine = 0;
    END IF;

    RETURN fine;
END //
DELIMITER ;

