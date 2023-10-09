/* Social Media Data Analysis
*/

------------------------------------------------------------------------------------------------------------
/*Looking at Most Used Hashtags*/

SELECT hashtag_name, COUNT(post_tags.hashtag_id) 
FROM hashtags,post_tags
WHERE hashtags.hashtag_id = post_tags.hashtag_id
GROUP BY post_tags.hashtag_id
ORDER BY COUNT(post_tags.hashtag_id) DESC LIMIT 10;

------------------------------------------------------------------------------------------------------------
/*Looking at Most Inactive Users*/

SELECT user_id, username
FROM users
WHERE user_id NOT IN (SELECT user_id FROM post);

------------------------------------------------------------------------------------------------------------
/*Looking at Most Liked Posts*/

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

SELECT post_likes.user_id, post_likes.post_id, COUNT(post_likes.post_id) 
FROM post_likes, post
WHERE post.post_id = post_likes.post_id 
GROUP BY post_likes.post_id
ORDER BY COUNT(post_likes.post_id) DESC ;

------------------------------------------------------------------------------------------------------------
/*Looking at Average Posts per User*/

SELECT ROUND((COUNT(post_id) / COUNT(DISTINCT user_id) ),2)
FROM post;

------------------------------------------------------------------------------------------------------------
/*Looking at Users who have Liked all the Posts (Checking for Potential Bots)*/

SELECT username, Count(*) AS num_likes 
FROM users 
INNER JOIN post_likes ON users.user_id = post_likes.user_id 
GROUP  BY post_likes.user_id 
HAVING num_likes = (SELECT Count(*) FROM   post); 

------------------------------------------------------------------------------------------------------------
/*Looking at Users who have Never Commented*/

SELECT user_id, username
FROM users
WHERE user_id NOT IN (SELECT user_id FROM comments);

------------------------------------------------------------------------------------------------------------
/*Looking at Users who have Commented on all the Posts (Checking for Potential Bots)*/

SELECT username, Count(*)
FROM users 
INNER JOIN comments ON users.user_id = comments.user_id 
GROUP  BY comments.user_id 
HAVING Count(*) = (SELECT Count(*) FROM comments); 

------------------------------------------------------------------------------------------------------------
/*Looking at Users who are not following anyone*/

SELECT user_id, username AS 'Users Not Following Anyone'
FROM users
WHERE user_id NOT IN (SELECT follower_id FROM follows);

------------------------------------------------------------------------------------------------------------
/*Looking at Users Who Have Posted More Than 5 Times*/

SELECT user_id, COUNT(user_id) AS post_count 
FROM post
GROUP BY user_id
HAVING post_count > 5
ORDER BY COUNT(user_id) DESC;

------------------------------------------------------------------------------------------------------------
/*Looking at Comments With Specific Words*/

SELECT * FROM comments
WHERE comment_text REGEXP'good|beautiful';

------------------------------------------------------------------------------------------------------------
/*Looking at Posts With Longest Caption*/

SELECT user_id, caption, LENGTH(post.caption) AS caption_length FROM post
ORDER BY caption_length DESC LIMIT 5;