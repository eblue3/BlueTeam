# SQLi

## History

The first public discussions of SQL injection started appearing around 1998;[[3]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-3) for example, a 1998 article in [Phrack Magazine](https://en.wikipedia.org/wiki/Phrack_Magazine).[[4]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-4)

## Form

SQL injection (SQLI) was considered one of the top 10 web application vulnerabilities of 2007 and 2010 by the [Open Web Application Security Project](https://en.wikipedia.org/wiki/OWASP).[[5]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-5) In 2013, SQLI was rated the number one attack on the OWASP top ten.[[6]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-6) There are four main sub-classes of SQL injection:

- Classic SQLI
- Blind or Inference SQL injection
- [Database management system](https://en.wikipedia.org/wiki/Database_management_system)-specific SQLI
- Compounded SQLI

- SQL injection + insufficient authentication[[7]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-7)
- SQL injection + [DDoS](https://en.wikipedia.org/wiki/DDoS) attacks[[8]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-8)
- SQL injection + [DNS hijacking](https://en.wikipedia.org/wiki/DNS_hijacking)[[9]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-9)
- SQL injection + [XSS](https://en.wikipedia.org/wiki/Cross-site_scripting)[[10]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-10)

The [Storm Worm](https://en.wikipedia.org/wiki/Storm_Worm) is one representation of Compounded SQLI.[[11]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-11)

This classification represents the state of SQLI, respecting its evolution until 2010—further refinement is underway.[[12]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-12)

## Technical implementations

### Incorrectly filtered escape characters

This form of injection occurs when user input is not filtered for [escape characters](https://en.wikipedia.org/wiki/Escape_character) and is then passed into an SQL statement. This results in the potential manipulation of the statements performed on the database by the end-user of the application.

The following line of code illustrates this vulnerability:

```
statement = "SELECT * FROM users WHERE name = '" + userName + "';"
```

This SQL code is designed to pull up the records of the specified username from its table of users. However, if the &quot;userName&quot; variable is crafted in a specific way by a malicious user, the SQL statement may do more than the code author intended. For example, setting the &quot;userName&quot; variable as:

```
' OR '1'='1
```

or using comments to even block the rest of the query (there are three types of SQL comments[[13]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-13)). All three lines have a space at the end:

```
' OR '1'='1' --
' OR '1'='1' {
' OR '1'='1' /*
```

renders one of the following SQL statements by the parent language:

```
SELECT * FROM users WHERE name = '' OR '1'='1';
```
```
SELECT * FROM users WHERE name = '' OR '1'='1' -- ';
```

If this code were to be used in authentication procedure then this example could be used to force the selection of every data field (\*) from _all_ users rather than from one specific user name as the coder intended, because the evaluation of &#39;1&#39;=&#39;1&#39; is always true.

The following value of &quot;userName&quot; in the statement below would cause the deletion of the &quot;users&quot; table as well as the selection of all data from the &quot;userinfo&quot; table (in essence revealing the information of every user), using an [API](https://en.wikipedia.org/wiki/API) that allows multiple statements:

```
a';DROP TABLE users; SELECT * FROM userinfo WHERE 't' = 't
```

This input renders the final SQL statement as follows and specified:

```
SELECT * FROM users WHERE name = 'a';DROP TABLE users; SELECT * FROM userinfo WHERE 't' = 't';
```

While most SQL server implementations allow multiple statements to be executed with one call in this way, some SQL APIs such as [PHP](https://en.wikipedia.org/wiki/PHP)&#39;s `mysql_query()` function do not allow this for security reasons. This prevents attackers from injecting entirely separate queries, but doesn&#39;t stop them from modifying queries.

### Blind SQL injection

Blind SQL injection is used when a web application is vulnerable to an SQL injection but the results of the injection are not visible to the attacker. The page with the vulnerability may not be one that displays data but will display differently depending on the results of a logical statement injected into the legitimate SQL statement called for that page. This type of attack has traditionally been considered time-intensive because a new statement needed to be crafted for each bit recovered, and depending on its structure, the attack may consist of many unsuccessful requests. Recent advancements have allowed each request to recover multiple bits, with no unsuccessful requests, allowing for more consistent and efficient extraction.[[14]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-14) There are several tools that can automate these attacks once the location of the vulnerability and the target information has been established.[[15]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-15)

#### Conditional responses

One type of blind SQL injection forces the database to evaluate a logical statement on an ordinary application screen. As an example, a book review website uses a [query string](https://en.wikipedia.org/wiki/Query_string) to determine which book review to display. So the [URL](https://en.wikipedia.org/wiki/URL)`https://books.example.com/review?id=5` would cause the server to run the query

```
SELECT * FROM bookreviews WHERE ID = '5';
```

from which it would populate the review page with data from the review with [ID](https://en.wikipedia.org/wiki/Identifier) 5, stored in the [table](https://en.wikipedia.org/wiki/Table_(database)) bookreviews. The query happens completely on the server; the user does not know the names of the database, table, or fields, nor does the user know the query string. The user only sees that the above URL returns a book review. A [hacker](https://en.wikipedia.org/wiki/Security_hacker) can load the URLs `https://books.example.com/review?id=5 OR 1=1` and `https://books.example.com/review?id=5 AND 1=2`, which may result in queries

```
SELECT * FROM bookreviews WHERE ID = '5' OR '1'='1';
SELECT * FROM bookreviews WHERE ID = '5' AND '1'='2';
```

respectively. If the original review loads with the &quot;1=1&quot; URL and a blank or error page is returned from the &quot;1=2&quot; URL, and the returned page has not been created to alert the user the input is invalid, or in other words, has been caught by an input test script, the site is likely vulnerable to a SQL injection attack as the query will likely have passed through successfully in both cases. The hacker may proceed with this query string designed to reveal the version number of [MySQL](https://en.wikipedia.org/wiki/MySQL) running on the server: `https://books.example.com/review?id=5 AND substring(@@version, 1, INSTR(@@version, '.') - 1)=4`, which would show the book review on a server running MySQL 4 and a blank or error page otherwise. The hacker can continue to use code within query strings to achieve their goal directly, or to glean more information from the server in hopes of discovering another avenue of attack.[[16]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-16)[[17]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-17)

### Second order SQL injection

Second order SQL injection occurs when submitted values contain malicious commands that are stored rather than executed immediately. In some cases, the application may correctly encode an SQL statement and store it as valid SQL. Then, another part of that application without controls to protect against SQL injection might execute that stored SQL statement. This attack requires more knowledge of how submitted values are later used. Automated web application security scanners would not easily detect this type of SQL injection and may need to be manually instructed where to check for evidence that it is being attempted.

## Mitigation

An SQL injection is a well known attack and easily prevented by simple measures. After an apparent SQL injection attack on [TalkTalk](https://en.wikipedia.org/wiki/TalkTalk_Group) in 2015, the BBC reported that security experts were stunned that such a large company would be vulnerable to it.[[18]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-18)

### Detection

SQL injection filtering works in similar way to emails spam filters. Database firewalls detect SQL injections based on the number of invalid queries from host, while there are OR and UNION blocks inside of request, or others.[[19]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-19)

### Parameterized statements

Main article: [Prepared statement](https://en.wikipedia.org/wiki/Prepared_statement)

With most development platforms, parameterized statements that work with parameters can be used (sometimes called placeholders or [bind variables](https://en.wikipedia.org/wiki/Bind_variable)) instead of embedding user input in the statement. A placeholder can only store a value of the given type and not an arbitrary SQL fragment. Hence the SQL injection would simply be treated as a strange (and probably invalid) parameter value. In many cases, the SQL statement is fixed, and each parameter is a [scalar](https://en.wikipedia.org/wiki/Scalar_(computing)), not a [table](https://en.wikipedia.org/wiki/Table_(database)). The user input is then assigned (bound) to a parameter.[[20]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-20)

Easily put, using parameterized queries can definitely prevent SQL injection. This mainly means that your variables aren&#39;t query strings that would accept arbitrary SQL inputs, however, some parameters of given types are definitely necessary. Parameterized queries require the developer to define all the code. Therefore, without parameterized queries, anyone could put any kind of SQL code into the field, and have the database erased. But if the parameters were to set to &#39;@username&#39; then the person would only be able to put in a username without any kind of code.[[21]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-21)

#### Enforcement at the coding level

Using [object-relational mapping](https://en.wikipedia.org/wiki/Object-relational_mapping) libraries avoids the need to write SQL code. The ORM library in effect will generate parameterized SQL statements from object-oriented code.

### Escaping

A straightforward, though error-prone way to prevent injections is to escape characters that have a special meaning in SQL. The manual for an SQL DBMS explains which characters have a special meaning, which allows creating a comprehensive [blacklist](https://en.wikipedia.org/wiki/Blacklist_(computing)) of characters that need translation. For instance, every occurrence of a single quote (`'`) in a parameter must be replaced by two single quotes (`''`) to form a valid SQL string literal. For example, in [PHP](https://en.wikipedia.org/wiki/PHP) it is usual to escape parameters using the function `mysqli_real_escape_string();` before sending the SQL query:

```
$mysqli = new mysqli('hostname', 'db_username', 'db_password', 'db_name');
$query = sprintf("SELECT * FROM `Users` WHERE UserName='%s' AND Password='%s'",
                  $mysqli->real_escape_string($username),
                  $mysqli->real_escape_string($password));
$mysqli->query($query);
```

This function prepends backslashes to the following characters: `\x00`, `\n`, `\r`, `\`, `'`, `"` and `\x1a`. This function is normally used to make data safe before sending a query to [MySQL](https://en.wikipedia.org/wiki/MySQL).[[22]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-22)
 PHP has similar functions for other database systems such as pg\_escape\_string() for [PostgreSQL](https://en.wikipedia.org/wiki/PostgreSQL). The function `addslashes(string $str)` works for escaping characters, and is used especially for querying on databases that do not have escaping functions in PHP. It returns a string with backslashes before characters that need to be escaped in database queries, etc. These characters are single quote (&#39;), double quote (&quot;), backslash (\) and NUL (the NULL byte).[[23]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-23)
 Routinely passing escaped strings to SQL is error prone because it is easy to forget to escape a given string. Creating a transparent layer to secure the input can reduce this error-proneness, if not entirely eliminate it.[[24]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-24)

### Pattern check

Integer, float or boolean, string parameters can be checked if their value is valid representation for the given type. Strings that must follow some strict pattern (date, UUID, alphanumeric only, etc.) can be checked if they match this pattern.

### Database permissions

Limiting the permissions on the database login used by the web application to only what is needed may help reduce the effectiveness of any SQL injection attacks that exploit any bugs in the web application.

For example, on [Microsoft SQL Server](https://en.wikipedia.org/wiki/Microsoft_SQL_Server), a database logon could be restricted from selecting on some of the system tables which would limit exploits that try to insert JavaScript into all the text columns in the database.

```
deny select on sys.sysobjects to webdatabaselogon;
deny select on sys.objects to webdatabaselogon;
deny select on sys.tables to webdatabaselogon;
deny select on sys.views to webdatabaselogon;
deny select on sys.packages to webdatabaselogon;
```

## Examples

- In February 2002, Jeremiah Jacks discovered that Guess.com was vulnerable to an SQL injection attack, permitting anyone able to construct a properly-crafted URL to pull down 200,000+ names, credit card numbers and expiration dates in the site&#39;s customer database.[[25]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-25)
- On November 1, 2005, a teenaged hacker used SQL injection to break into the site of a [Taiwanese](https://en.wikipedia.org/wiki/Taiwan) information security magazine from the Tech Target group and steal customers&#39; information.[[26]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-26)
- On January 13, 2006, [Russian](https://en.wikipedia.org/wiki/Russia) computer criminals broke into a [Rhode Island government](https://en.wikipedia.org/wiki/Government_of_Rhode_Island) website and allegedly stole credit card data from individuals who have done business online with state agencies.[[27]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-27)
- On March 29, 2006, a hacker discovered an SQL injection flaw in an official [Indian government](https://en.wikipedia.org/wiki/Government_of_India)&#39;s [tourism](https://en.wikipedia.org/wiki/Tourism_in_India) site.[[28]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-28)
- On June 29, 2007, a computer criminal defaced the [Microsoft](https://en.wikipedia.org/wiki/Microsoft) UK website using SQL injection.[[29]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-29)[[30]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-30) UK website [_The Register_](https://en.wikipedia.org/wiki/The_Register) quoted a Microsoft [spokesperson](https://en.wikipedia.org/wiki/Spokesperson) acknowledging the problem.
- On September 19, 2007 and January 26, 2009 the Turkish hacker group &quot;m0sted&quot; used SQL injection to exploit Microsoft&#39;s SQL Server to hack web servers belonging to [McAlester Army Ammunition Plant](https://en.wikipedia.org/wiki/McAlester_Army_Ammunition_Plant) and the [US Army Corps of Engineers](https://en.wikipedia.org/wiki/United_States_Army_Corps_of_Engineers) respectively.[[31]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-31)
- In January 2008, tens of thousands of PCs were infected by an automated SQL injection attack that exploited a vulnerability in application code that uses [Microsoft SQL Server](https://en.wikipedia.org/wiki/Microsoft_SQL_Server) as the database store.[[32]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-chinesefarm-32)
- In July 2008, [Kaspersky](https://en.wikipedia.org/wiki/Kaspersky_Lab)&#39;s [Malaysian](https://en.wikipedia.org/wiki/Malaysia) site was hacked by the &quot;m0sted&quot; hacker group using SQL injection.
- On April 13, 2008, the [Sexual and Violent Offender Registry](https://en.wikipedia.org/wiki/Sex_offender_registries_in_the_United_States) of [Oklahoma](https://en.wikipedia.org/wiki/Oklahoma) shut down its website for &quot;[routine maintenance](https://en.wikipedia.org/wiki/Routine_maintenance)&quot; after being informed that 10,597 [Social Security numbers](https://en.wikipedia.org/wiki/Social_Security_number) belonging to [sex offenders](https://en.wikipedia.org/wiki/Sex_offender) had been downloaded via an SQL injection attack[[33]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-33)
- In May 2008, a [server farm](https://en.wikipedia.org/wiki/Server_farm) inside [China](https://en.wikipedia.org/wiki/China) used automated queries to [Google&#39;s search engine](https://en.wikipedia.org/wiki/Google_Search) to identify [SQL server](https://en.wikipedia.org/wiki/Microsoft_SQL_Server) websites which were vulnerable to the attack of an automated SQL injection tool.[[32]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-chinesefarm-32)[[34]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-attackspecifics-34)
- In 2008, at least April through August, a sweep of attacks began exploiting the SQL injection vulnerabilities of Microsoft&#39;s [IIS web server](https://en.wikipedia.org/wiki/Internet_Information_Services) and [SQL Server database server](https://en.wikipedia.org/wiki/Microsoft_SQL_Server). The attack does not require guessing the name of a table or column, and corrupts all text columns in all tables in a single request.[[35]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-broad_inject_specifics-35) A HTML string that references a [malware](https://en.wikipedia.org/wiki/Malware)[JavaScript](https://en.wikipedia.org/wiki/JavaScript) file is appended to each value. When that database value is later displayed to a website visitor, the script attempts several approaches at gaining control over a visitor&#39;s system. The number of exploited web pages is estimated at 500,000.[[36]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-broad_inject_numbers-36)
- On August 17, 2009, the [United States Department of Justice](https://en.wikipedia.org/wiki/United_States_Department_of_Justice) charged an American citizen, [Albert Gonzalez](https://en.wikipedia.org/wiki/Albert_Gonzalez), and two unnamed Russians with the theft of 130 million credit card numbers using an SQL injection attack. In reportedly &quot;the biggest case of [identity theft](https://en.wikipedia.org/wiki/Identity_theft) in American history&quot;, the man stole cards from a number of corporate victims after researching their [payment processing systems](https://en.wikipedia.org/wiki/Payment_processor). Among the companies hit were credit card processor [Heartland Payment Systems](https://en.wikipedia.org/wiki/Heartland_Payment_Systems), convenience store chain [7‑Eleven](https://en.wikipedia.org/wiki/7-Eleven), and supermarket chain [Hannaford Brothers](https://en.wikipedia.org/wiki/Hannaford_Brothers).[[37]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-37)
- In December 2009, an attacker breached a [RockYou](https://en.wikipedia.org/wiki/RockYou) plaintext database containing the [unencrypted](https://en.wikipedia.org/wiki/Encryption) usernames and passwords of about 32 million users using an SQL injection attack.[[38]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-38)
- On July 2010, a South American security researcher who goes by the [handle](https://en.wikipedia.org/wiki/User_(computing)) &quot;Ch Russo&quot; obtained sensitive user information from popular [BitTorrent](https://en.wikipedia.org/wiki/BitTorrent) site [The Pirate Bay](https://en.wikipedia.org/wiki/The_Pirate_Bay). He gained access to the site&#39;s administrative control panel and exploited a SQL injection vulnerability that enabled him to collect user account information, including [IP addresses](https://en.wikipedia.org/wiki/IP_address), [MD5](https://en.wikipedia.org/wiki/MD5)[password hashes](https://en.wikipedia.org/wiki/Cryptographic_hash_function) and records of which torrents individual users have uploaded.[[39]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-39)
- From July 24 to 26, 2010, attackers from [Japan](https://en.wikipedia.org/wiki/Japan) and [China](https://en.wikipedia.org/wiki/China) used an SQL injection to gain access to customers&#39; credit card data from Neo Beat, an [Osaka](https://en.wikipedia.org/wiki/Osaka)-based company that runs a large online supermarket site. The attack also affected seven business partners including supermarket chains Izumiya Co, Maruetsu Inc, and Ryukyu Jusco Co. The theft of data affected a reported 12,191 customers. As of August 14, 2010 it was reported that there have been more than 300 cases of credit card information being used by third parties to purchase goods and services in China.
- On September 19 during the [2010 Swedish general election](https://en.wikipedia.org/wiki/2010_Swedish_general_election) a voter attempted a code injection by hand writing SQL commands as part of a [write‑in](https://en.wikipedia.org/wiki/Write-in_candidate) vote.[[40]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-40)
- On November 8, 2010 the British [Royal Navy](https://en.wikipedia.org/wiki/Royal_Navy) website was compromised by a Romanian hacker named TinKode using SQL injection.[[41]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-41)[[42]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-42)
- On February 5, 2011 [HBGary](https://en.wikipedia.org/wiki/HBGary), a technology security firm, was broken into by [LulzSec](https://en.wikipedia.org/wiki/LulzSec) using a SQL injection in their CMS-driven website[[43]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-43)
- On March 27, 2011, www.mysql.com, the official homepage for [MySQL](https://en.wikipedia.org/wiki/MySQL), was compromised by a hacker using SQL blind injection[[44]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-44)
- On April 11, 2011, [Barracuda Networks](https://en.wikipedia.org/wiki/Barracuda_Networks) was compromised using an SQL injection flaw. [Email addresses](https://en.wikipedia.org/wiki/Email_address) and usernames of employees were among the information obtained.[[45]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-45)
- Over a period of 4 hours on April 27, 2011, an automated SQL injection attack occurred on [Broadband Reports](https://en.wikipedia.org/wiki/Broadband_Reports) website that was able to extract 8% of the username/password pairs: 8,000 random accounts of the 9,000 active and 90,000 old or inactive accounts.[[46]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-DSLReports-46)[[47]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-Cnet_News-47)[[48]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-The_Tech_Herald-48)
- On June 1, 2011, &quot;[hacktivists](https://en.wikipedia.org/wiki/Hacktivist)&quot; of the group [LulzSec](https://en.wikipedia.org/wiki/LulzSec) were accused of using SQLI to steal [coupons](https://en.wikipedia.org/wiki/Coupon), download keys, and passwords that were stored in plaintext on [Sony](https://en.wikipedia.org/wiki/Sony)&#39;s website, accessing the personal information of a million users.[[49]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-49)
- In June 2011, [PBS](https://en.wikipedia.org/wiki/PBS) was hacked, most likely through use of SQL injection; the full process used by hackers to execute SQL injections was described in this [Imperva](http://blog.imperva.com/2011/05/pbs-breached-how-hackers-probably-did-it.html) blog.[[50]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-PBS_Breached_-_How_Hackers_Probably_Did_It-50)
- In May 2012, the website for [_Wurm Online_](https://en.wikipedia.org/wiki/Wurm_Online), a [massively multiplayer online game](https://en.wikipedia.org/wiki/Massively_multiplayer_online_game), was shut down from an SQL injection while the site was being updated.[[51]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-51)
- [In July 2012](https://en.wikipedia.org/wiki/2012_Yahoo!_Voices_hack) a hacker group was reported to have stolen 450,000 login credentials from [Yahoo!](https://en.wikipedia.org/wiki/Yahoo!). The logins were stored in [plain text](https://en.wikipedia.org/wiki/Plain_text) and were allegedly taken from a Yahoo [subdomain](https://en.wikipedia.org/wiki/Subdomain), [Yahoo! Voices](https://en.wikipedia.org/wiki/Yahoo!_Voices). The group breached Yahoo&#39;s security by using a &quot;[union](https://en.wikipedia.org/wiki/Set_operations_(SQL)#UNION_operator)-based SQL injection technique&quot;.[[52]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-52)[[53]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-53)
- On October 1, 2012, a hacker group called &quot;Team GhostShell&quot; published the personal records of students, faculty, employees, and alumni from 53 universities including [Harvard](https://en.wikipedia.org/wiki/Harvard), [Princeton](https://en.wikipedia.org/wiki/Princeton_University), [Stanford](https://en.wikipedia.org/wiki/Stanford), [Cornell](https://en.wikipedia.org/wiki/Cornell), [Johns Hopkins](https://en.wikipedia.org/wiki/Johns_Hopkins_University), and the [University of Zurich](https://en.wikipedia.org/wiki/University_of_Zurich) on [pastebin.com](https://en.wikipedia.org/wiki/Pastebin). The hackers claimed that they were trying to &quot;raise awareness towards the changes made in today&#39;s education&quot;, bemoaning changing education laws in Europe and increases in [tuition in the United States](https://en.wikipedia.org/wiki/College_tuition_in_the_United_States).[[54]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-54)
- In February 2013, a group of Maldivian hackers, hacked the website &quot;UN-Maldives&quot; using SQL Injection.
- On June 27, 2013, hacker group &quot;[RedHack](https://en.wikipedia.org/wiki/RedHack)&quot; breached Istanbul Administration Site.[[55]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-55) They claimed that, they&#39;ve been able to erase people&#39;s debts to water, gas, Internet, electricity, and telephone companies. Additionally, they published admin user name and password for other citizens to log in and clear their debts early morning. They announced the news from Twitter.[[56]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-56)
- On November 4, 2013, hacktivist group &quot;RaptorSwag&quot; allegedly compromised 71 Chinese government databases using an SQL injection attack on the Chinese Chamber of International Commerce. The leaked data was posted publicly in cooperation with [Anonymous](https://en.wikipedia.org/wiki/Anonymous_(group)).[[57]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-57)
- On February 2, 2014, AVS TV had 40,000 accounts leaked by a hacking group called @deletesec [[58]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-58)
- On February 21, 2014, United Nations Internet Governance Forum had 3,215 account details leaked.[[59]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-59)
- On February 21, 2014, Hackers of a group called @deletesec hacked Spirol International after allegedly threatening to have the hackers arrested for reporting the security vulnerability. 70,000 user details were exposed over this conflict.[[60]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-60)
- On March 7, 2014, officials at Johns Hopkins University publicly announced that their Biomedical Engineering Servers had become victim to an SQL injection attack carried out by an Anonymous hacker named &quot;Hooky&quot; and aligned with hacktivist group &quot;RaptorSwag&quot;. The hackers compromised personal details of 878 students and staff, posting a [press release](http://pastebin.com/UG4fYnby) and the leaked data on the internet.[[61]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-61)
- In August 2014, [Milwaukee](https://en.wikipedia.org/wiki/Milwaukee)-based computer security company Hold Security disclosed that it uncovered [a theft of confidential information](https://en.wikipedia.org/wiki/2014_Russian_hacker_password_theft) from nearly 420,000 websites through SQL injections.[[62]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-62)[_The New York Times_](https://en.wikipedia.org/wiki/The_New_York_Times) confirmed this finding by hiring a security expert to check the claim.[[63]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-63)
- In October 2015, an SQL injection attack was used to steal the personal details of 156,959 customers from British telecommunications company [TalkTalk&#39;s](https://en.wikipedia.org/wiki/TalkTalk_Group) servers, exploiting a vulnerability in a legacy web portal[[64]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-64)
- In August 2020, an SQL injection attack was used to access information on the romantic interests of many [Stanford](https://en.wikipedia.org/wiki/Stanford_University) students, as a result of insecure data sanitization standards on the part of Link, a start-up founded on campus.[[65]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-65)

## In popular culture

- Unauthorized login to web sites by means of SQL injection forms the basis of one of the subplots in [J.K. Rowling](https://en.wikipedia.org/wiki/J.K._Rowling)&#39;s 2012 novel [_The Casual Vacancy_](https://en.wikipedia.org/wiki/The_Casual_Vacancy).
- An [_xkcd_](https://en.wikipedia.org/wiki/Xkcd) cartoon involved a character _Robert&#39;); DROP TABLE students;--_ named to carry out a SQL injection. As a result of this cartoon, SQL injection is sometimes informally referred to as &quot;Bobby Tables&quot;.[[66]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-66)[[67]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-67)
- In 2014, an individual in Poland legally renamed his business to _Dariusz Jakubowski x&#39;; DROP TABLE users; SELECT &#39;1_ in an attempt to disrupt operation of spammers&#39; [harvesting bots](https://en.wikipedia.org/wiki/Web_scraping).[[68]](https://en.wikipedia.org/wiki/SQL_injection#cite_note-68)
- The 2015 game [Hacknet](https://en.wikipedia.org/wiki/Hacknet) has a hacking program called SQL\_MemCorrupt. It is described as injecting a table entry that causes a corruption error in a SQL database, then queries said table, causing a SQL database crash and core dump.
- In the 2019 [_Star Trek: Discovery_](https://en.wikipedia.org/wiki/Star_Trek:_Discovery) episode _If Memory Serves_ Commander Airiam discovered that a probe that attacked a data store on one of the ship&#39;s shuttlecraft had made a number of SQL injections, but that she couldn&#39;t find any compromised files.

## See also

- [Code injection](https://en.wikipedia.org/wiki/Code_injection)
- [Cross-site scripting](https://en.wikipedia.org/wiki/Cross-site_scripting)
- [Metasploit Project](https://en.wikipedia.org/wiki/Metasploit_Project)
- [OWASP](https://en.wikipedia.org/wiki/OWASP) Open Web Application Security Project
- [SGML entity](https://en.wikipedia.org/wiki/SGML_entity)
- [Uncontrolled format string](https://en.wikipedia.org/wiki/Uncontrolled_format_string)
- [w3af](https://en.wikipedia.org/wiki/W3af)
- [Web application security](https://en.wikipedia.org/wiki/Web_application_security)
