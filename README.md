# Data-Extraction-and-Summarisation-in-Shell-Script
Data Extraction and Summarisation in Shell Script.


## Background:
Write a script that processes a log file and extracts useful information summaries from it, which is common in system administration work.

The log file is a web server log file from the small, portable and secure webserver httpd. It follows a standard format that is common in the UNIX world. It’s a flat text file with one record per line and fields delimited by whitespace or other characters.

Task is to write a script that answers the following questions, the idea is that this script will be used by system admins to extract and summarise relevant information about the operation of the webserver so that they can check for anomalies, i.e. things that stand out from the ordinary, and investigate further if necessary. This is in fact a very simple and common form of intrusion detection.

The logfile consists of lines where each line represent one access request. It pretty much follows the unified Apache combined log format. The fields, describe the following: IP number the request originated from; the ident answer from the originator (always ’-’); the username of the requester as determined by http authentication; date and time the request was processed; the request line as it was received from the client in double quotes; http status code that was sent to the client; number of bytes that was transferred to the client; referer page (from the client); user agent string (from the client). See e.g. the Apache documentation for more details (http://httpd.apache.org/docs/1.3/logs. html). Note that the fields are not well delimited (i.e. there is no reserved character to separate fields), this is unfortunately common when it comes to log files and a problem you have to contend with.


## How I solved:
I developed separate function for each task as well as helper function. As I did not use the powerful built-in functions/commands – such as “awk” and so forth, so I had to write long and detailed functions for implementing the given tasks. I called appropriate tasks functions by matching command and arguments. I used “case” statement for controlling them.

## Major Commands Used:
I mostly used cat, cut, sort, uniq, egrep, head and so forth commands for implementing the tasks functions. I avoided using “awk” commands.
