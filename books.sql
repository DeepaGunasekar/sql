create schema joins;
use joins;

--  creating Parent Table: Publishers
create table Publishers(
 publisher_id  INT Primary Key,
 publisher_name VARCHAR(100),
 publisher_location VARCHAR(100)
 );
 
 
 -- Child Table 1: Authors
 CREATE TABLE authors(
author_id INT Primary Key,
author_name VARCHAR(100) NOT NULL,
publisher_id int,
Foreign Key (publisher_id) REFERENCES Publishers(publisher_id)
);

-- Child Table 2: Books
CREATE TABLE books(
book_id  INT Primary Key ,
book_title VARCHAR(100),
publish_year INT ,
author_id int,
publisher_id int,
FOREIGN KEY (author_id) REFERENCES authors(author_id),
FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id)
);


-- inserting Publishers Table :

INSERT INTO Publishers (publisher_id,publisher_name, publisher_location) VALUES
(1,'Penquin Random House', 'NewYork'),
(2,'Harpercollns', 'London'),
(3,'Macmilan', 'NewYork'),
(4,'Oxford University Press', 'Oxford'),
(5,'Simon & Schuster', 'NewYork');


-- Insert values into Authors
INSERT INTO Authors (author_id, author_name, publisher_id) VALUES
(1, 'J.K Rowling', 1),
(2, 'George Orwell', 2),
(3, 'Stephen King', 3),
(4, 'Aquatha Christie',4),
(5, 'Dan Brown', 5),
(6, 'J.R.R Token', 1);



-- Insert Values into Books Table
INSERT INTO Books (book_id, book_title, author_id, publisher_id, publish_year) VALUES
(1, 'Harry Potter and the sorcerers Stone',1 , 1 , 1997),
(2, 'pet',  2 , 2 , 1949),
(3,  'The Shining', 3, 3, 1977),
(4, 'Murder on the Orient Express', 4 , 4 , 1934),
(5, 'The Da Vinci Code', 5 , 5, 2003),
(6, 'The Hobbit', 6 , 1 , 1937);


select * from publishers;
select * from authors;
select * from books;

-- Questions :
-- 1. Get the titles of books along with their authors.

select a.book_title,b.author_name
from  books as a
join authors as b
on a.author_id=b.author_id;
-- -----------------------------------------------------------------------------------------------------------------------------------

-- 2. Get all books with their publisher information, including books without a publisher
select  a.publisher_name,a.publisher_id,b.book_id,b.book_title
from publishers as a
join books as b
on a.publisher_id= b.publisher_id
where b.book_title is not null or book_title is null;

-- -------------------------------------------------------------------------------------------------------------------------------------

-- 3. Get all publishers with the books they've published, including publishers with no books.

SELECT a.publisher_name, a.publisher_id, b.book_title
FROM publishers AS a
LEFT JOIN books AS b
ON a.publisher_id = b.publisher_id
WHERE a.publisher_name IS NOT NULL;


-- ---------------------------------------------------------------------------------------------------------------
-- 4. Get all authors and the books they have written, even those without books.

select a.author_name,b.book_title
from authors as a
join books as b
on a.author_id=b.author_id
where b.book_title is null or b.book_title is not null;

-- -------------------------------------------------------------------------------------------------------------------------

-- 5. Get authors who published books with other authors under the same publisher.

select a.book_title,a.book_id,b.author_name,c.publisher_name
from books as a
join authors as b
on a.author_id=b.author_id
join publishers as c
on b.publisher_id=c.publisher_id
WHERE a.book_id IN (
    SELECT a.book_id
    FROM books
    where COUNT(DISTINCT b.author_id) > 1
);
-- ------------------------------------------------------------------------------------------------------------------------

-- 6. Get books that were published after 1950, along with their authors and publishers.

select a.author_name,b.publisher_name,b.publisher_id,c.book_title,c.publish_year
from authors a
join publishers b
on a.publisher_id = b.publisher_id
join books c
on c.author_id = a.author_id
where c.publish_year > 1950;

-- ------------------------------------------------------------------------------------------------------------------------

-- 7. Get authors who have not written any books

SELECT a.author_id, a.author_name
FROM authors a
LEFT JOIN books b 
ON a.author_id = b.author_id
WHERE b.book_id IS NULL;

-- ------------------------------------------------------------------------------------------------------------------------

-- 8. Get the count of books published by each publisher.

select  count(a.book_title) count_book,b.publisher_name,b.publisher_id
from books a
join publishers b
on a.publisher_id= b.publisher_id
group by b.publisher_name,b.publisher_id;

-- -------------------------------------------------------------------------------------------------------------------------------------

-- 9. Get the books sorted by publish year in descending order.

SELECT 
    b.book_id,b.book_title,b.publish_year,p.publisher_name
FROM books b
JOIN publishers p 
ON b.publisher_id = p.publisher_id
ORDER BY b.publish_year DESC;

-- ----------------------------------------------------------------------------------------------------------------------------------------

-- 10. Get publishers who have more than one author.
 SELECT 
    p.publisher_id,p.publisher_name,
    COUNT(DISTINCT a.author_id) AS total_authors
FROM publishers p
JOIN authors a ON p.publisher_id = a.publisher_id
GROUP BY p.publisher_id, p.publisher_name
HAVING COUNT(DISTINCT a.author_id) > 1;

-- -----------------------------------------------------------------------------------------------------------------------------

-- 11. Get the first 3 books along with their authors.

select a.book_title,a.book_id, b.author_name
from books a
join authors b
on a.publisher_id = b.publisher_id
order by a.book_id desc
limit 3;

-- ------------------------------------------------------------------------------------------------------------------------------------------

-- 12. Get books published before 2000 and their authors.

select a.book_title,a.publish_year,b.author_name,b.author_id
from books a
join authors b
on a.author_id = b.author_id
where publish_year < 2000;

-- ---------------------------------------------------------------------------------------------------------------------------

-- 13. Get distinct authors and the publishers they work with.

select distinct b.publisher_name,a.author_id,a.author_name
from authors a
join publishers b
on a.publisher_id = b.publisher_id;

-- ----------------------------------------------------------------------------------------------------------------------

-- 14. Get books, authors, and their publishers.

select a.book_title,a.book_id,b.author_name,b.author_id,c.publisher_name
from books a 
join authors b
on a.author_id = b.author_id
join publishers c
on b.publisher_id = c.publisher_id;

-- -----------------------------------------------------------------------------------------------------------------------------------------

-- 15. Get all publishers and books published by them, including books with no publisher.


SELECT 
    a.book_id,a.book_title,b.publisher_name
FROM books a
LEFT JOIN publishers b 
ON a.publisher_id = b.publisher_id;

-- -------------------------------------------------------------------------------------------------------------------------

-- 16. Get books published between 1950 and 2000.

select a.book_id,a.book_title,a.publish_year
from books a
join publishers b
on a.publisher_id = b.publisher_id
where a.publish_year between 1950 and 2000;

-- --------------------------------------------------------------------------------------------------------------------------------------

-- 17. Get authors whose books were published after 1990.

select a.book_id,a.book_title,a.publish_year
from books a
join publishers b
on a.publisher_id = b.publisher_id
where a.publish_year > 1990;

-- ----------------------------------------------------------------------------------------------------------------------------------------

-- 18. Get books that are published by either 'Penguin Random House' or 'Macmillan'

SELECT 
    a.book_title,
    a.book_id,
    b.publisher_name
FROM books a
JOIN publishers b ON a.publisher_id = b.publisher_id
WHERE b.publisher_name IN ('Penguin Random House', 'Macmillan');

-- ------------------------------------------------------------------------------------------------------------------------

-- 19. Get authors who haven't written books.

SELECT 
    a.author_id,a.author_name
FROM authors a
LEFT JOIN books b ON a.author_id = b.author_id
WHERE b.book_id IS NULL;

-- ---------------------------------------------------------------------------------------------------------------------

-- 20. Get books and their publishers, and replace NULL publisher with 'Unknown'.

SELECT 
    b.book_id,
    b.book_title,
	p.publisher_name, 'Unknown' AS publisher_name
FROM books b
LEFT JOIN publishers p ON b.publisher_id = p.publisher_id;

-- ---------------------------------------------------------------------------------------------------

-- 21. Get books whose title contains the word "Harry".

SELECT 
    b.book_id,b.book_title,p.publisher_name
FROM books b
JOIN publishers p 
ON b.publisher_id = p.publisher_id
WHERE b.book_title LIKE '%Harry%';

-- -----------------------------------------------------------------------------------------------------------------

-- 22. Get authors who have written books.

select a.book_id,a.book_title,b.author_name
from books a
join authors b
on a.author_id = b.author_id;

-- ----------------------------------------------------------------------------------------------------------------------

-- 23. Get all authors and books, including authors who have not written any books.

select a.book_id,a.book_title,b.author_name
from books a
join authors b
on a.author_id = b.author_id;
-- ------------------------------------------------------------------------------------------------------------------------------------------------
SELECT 
    a.author_id,
    a.author_name,
    b.book_id,
    b.book_title
FROM authors a
LEFT JOIN books b ON a.author_id = b.author_id;

-- -------------------------------------------------------------------------------------------------------------------------------------------------

-- 24. Get publishers and their books, grouped by publisher.

SELECT 
    p.publisher_id,p.publisher_name,b.book_title
FROM publishers p
JOIN books b ON p.publisher_id = b.publisher_id
ORDER BY p.publisher_name, b.book_title;

-- --------------------------------------------------------------------------------------------------------------------------------------------------

-- 25. Get publishers who have authors who have written books after 2000.

SELECT DISTINCT 
    p.publisher_id,
    p.publisher_name,b.publish_year
FROM publishers p
JOIN authors a ON p.publisher_id = a.publisher_id
JOIN books b ON a.author_id = b.author_id
WHERE b.publish_year > 2000;
